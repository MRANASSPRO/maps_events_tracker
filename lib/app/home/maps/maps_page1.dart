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
import 'package:time_tracker_flutter_course/model/myLocations.dart'
    as locations;

const initialPosition = LatLng(35.828406, -5.362848);

class MapsPage01 extends StatefulWidget {
  const MapsPage01({@required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MapsPage01State();
  }
}

class _MapsPage01State extends State<MapsPage01> {
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  Stream<QuerySnapshot> _streamRoutePlaces;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  final Completer<GoogleMapController> _mapController = Completer();
  final MapType _maptype = MapType.satellite;
  var _tripDistance = 0;
  var i = 1;

  @override
  void initState() {
    markers.clear();
    onPlaceSelected();
    super.initState();
    _streamRoutePlaces = Firestore.instance.collection('adm_pks').orderBy('name').snapshots();
    //getPolyPoints();
    getKMPoints();
    getAndSaveData();
    //getKMPoints();
    //getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    //getPolyPoints();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamRoutePlaces,
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

  //Future<Set<Marker>> getPKPoints() async{
  Future<void> getKMPoints() async {
    final pointsSaved = await pks.loadData();
    setState(() {
      //markers.clear();
      for (final pk in pointsSaved.pks) {
        print(pk.name);
        final marker = Marker(
          markerId: MarkerId(pk.name),
          position: LatLng(pk.coordinates.lat, pk.coordinates.lng),
          infoWindow: InfoWindow(
            title: pk.name,
            snippet: pk.address,
          ),
        );
        markers.add(marker);
      }
    });
    //return markers;
  }

  void getAndSaveData() async {
    if (firestore.collection('PKs') == null) {
      print('Saving to Another Firestore DB');
      firestore
          .collection('adm_pks')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        //snapshot.documents.forEach((f) => print('${f.data}}'));
        snapshot.documents.forEach((f) => firestore.collection('PKs').add({
              'address': f['address'] as String,
              'coordinates': GeoPoint(
                f['location'].latitude as double,
                f['location'].longitude as double,
              ),
              'name': f['name'] as String,
              'placeId': f['placeId'] as String
            }));
      });
    }
  }

  /*Future<DocumentReference> _addGeoPoint(
      double lat, double long, String name) async {
    print('Saving to Another Firestore DB');
    GeoFirePoint myPoint = geo.point(latitude: lat, longitude: long);
    return firestore.collection('places').add(
        {'address': name, 'coordinates': name, 'name': name, 'placeId': name});
  }*/

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
