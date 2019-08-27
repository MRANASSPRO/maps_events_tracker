import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_tracker_flutter_course/app/home/maps/api_key.dart';
import 'package:time_tracker_flutter_course/app/home/maps/store_map.dart';
import 'package:time_tracker_flutter_course/app/home/maps/store_carousel.dart';
import 'package:time_tracker_flutter_course/model/trip_info_res.dart';

//import 'package:time_tracker_flutter_course/repository/PointLatLng.dart';
import 'package:time_tracker_flutter_course/services/place_service.dart';
import 'package:time_tracker_flutter_course/resources/car_pickup.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:time_tracker_flutter_course/model/myPKs.dart' as pks;
import 'package:dio/dio.dart';

const initialPosition = LatLng(35.828406, -5.362848);

class MapsPage01 extends StatefulWidget {
  const MapsPage01({@required this.title});

  //const MapsPage01();

  final String title;

  @override
  State<StatefulWidget> createState() {
    return MapsPage01State();
  }
}

class MapsPage01State extends State<MapsPage01> {
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  //Stream<QuerySnapshot> _streamRoutePoints;
  Stream<QuerySnapshot> _streamPK_Points;
  Dio dio = new Dio();
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  final Completer<GoogleMapController> _mapController = Completer();
  final MapType _maptype = MapType.satellite;
  var _tripDistance = 0;
  var i = 1;

  @override
  void initState() {
    //markers.clear();
    onPlaceSelected();
    super.initState();
    _streamPK_Points =
        Firestore.instance.collection('PK_Points').orderBy('name').snapshots();
    //_streamRoutePoints = Firestore.instance.collection('adm_pks').orderBy('name').snapshots();
    //getKMPoints();
    //getPKDistance();
    //backupData();
  }

  @override
  Widget build(BuildContext context) {
    //getKMPoints();
    //markers.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //stream: _streamRoutePoints,
        stream: _streamPK_Points,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: const Text('Loading...'));
          }
          return Stack(
            children: [
              StoreMap(
                documents: snapshot.data.documents,
                initialPosition: initialPosition,
                mapController: _mapController,
                polylines: _polylines,
                defaultMapType: _maptype,
                //markers: _markers,
              ),
              StoreCarousel(
                mapController: _mapController,
                documents: snapshot.data.documents,
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                height: 110,
                child: CarPickup(_tripDistance),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> getPKDistance() async {
    const double originLatitude = 35.607747,
        originLongitude = -5.337742,
        destLatitude = 35.5997531,
        destLongitude = -5.3391261;

    String urlDist =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=" +
            originLatitude.toString() +
            "," +
            originLongitude.toString() +
            "&destinations=" +
            destLatitude.toString() +
            "," +
            destLongitude.toString() +
            "&mode=driving" +
            "&key=$googleMapsApiKey";
    Response response = await dio.get(urlDist);
    print("distancePKi_i++");
    print(urlDist);
    print(response.data);
  }

  //Future<Set<Marker>> getPKPoints() async{
  Future<void> getKMPoints() async {
    final pointsSaved = await pks.loadData();
    setState(() {
      //markers.clear();
      for (final pk in pointsSaved.pks) {
        print(pk.name);
        //final marker = Marker(
        Marker(
          markerId: MarkerId(pk.name),
          position: LatLng(pk.location.lat, pk.location.lng),
          infoWindow: InfoWindow(
            title: pk.name,
            snippet: pk.address,
          ),
        );
        //markers.add(marker);

        //if (firestore.collection('PK_Points') == null){
        print('Saving JSON PKs Into Markers');
        firestore.collection('PK_Points').add({
          'address': pk.address,
          'location': GeoPoint(
            pk.location.lat,
            pk.location.lng,
          ),
          'name': pk.name,
          'id': pk.id
        });
        //}
      }
    });
    //return markers;
  }

  void backupData() async {
    if (firestore.collection('backup_PKs') == null) {
    print('Backup Data');
    firestore
        .collection('PK_Points')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      //snapshot.documents.forEach((f) => print('${f.data}}'));
      snapshot.documents.forEach((f) => firestore.collection('backup_PKs').add({
            'address': f['address'] as String,
            'location': GeoPoint(
              f['location'].latitude as double,
              f['location'].longitude as double,
            ),
            'name': f['name'] as String,
            'id': f['id'] as String
          }));
    });
    }
  }

  void onPlaceSelected() {
    //var mkId = fromAddress ? "from_address" : "to_address";
    PolylineId polyId = PolylineId(i.toString());
    //_addMarker(mkId, place);
    //_moveCamera();
    _checkDrawPolyline(polyId);
    print(i);
    i++;
  }

  void _checkDrawPolyline(PolylineId polyId) async {
    setState(() {
      _polylines.clear();
    });
    setState(() {});

    PlaceService.getStep(googleMapsApiKey, originLatitude, originLongitude,
            destLatitude, destLongitude)
        .then((vl) async {
      TripInfoRes infoRes = vl;

      _tripDistance = infoRes.distance;
      setState(() {});

      //List<StepsRes> rs = infoRes.steps;;
      List<PointLatLng> rs = infoRes.polylinePoints;
      List<LatLng> paths = new List();
      for (var t in rs) {
        paths.add(LatLng(t.latitude, t.longitude));
      }

      //print('snaps received');
      //print(paths);

      PolylineId id = PolylineId('1');
      final Polyline poly = Polyline(
        polylineId: id,
        color: Colors.blue,
        width: 4,
        points: paths,
      );
      setState(() {
        _polylines[id] = poly;
      });
    });
  }
}

/*Polyline _addPolyLine(PolylineId polyId) {
      PolylineId id = PolylineId("1");
      Polyline poly = Polyline(
          polylineId: id,
          color: Colors.blue,
          width: 4,
          points: polylineCoordinates);
      setState(() {
        _polylines[id] = poly;
        //print(polylineCoordinates);
        //print(polylines.values);
      });
      return poly;
    }

    _getPolyline() async {
    //List<PointLatLng> result = polylinePoints.decodePolyline("");
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        _originLatitude,
        _originLongitude,
        _destLatitude,
        _destLongitude);
    if (result.isNotEmpty) {
      //print(result);
      //print('not empty');
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        //_addGeoPoint(point.latitude, point.longitude, point.toString());
      });
    }
    //_addPolyLine(polyId);
  }*/
