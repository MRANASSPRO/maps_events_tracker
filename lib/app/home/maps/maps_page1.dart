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

const initialPosition = LatLng(35.828406,-5.362848);

Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//double _destLatitude = 35.5997531, _destLongitude = -5.3391261;
//List<LatLng> polylineCoordinates = [];

class MapsPage01 extends StatefulWidget {
  const MapsPage01({@required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MapsPage01State();
  }
}

class _MapsPage01State extends State<MapsPage01> {
  Stream<QuerySnapshot> _iceCreamStores;
  final Completer<GoogleMapController> _mapController = Completer();
  final MapType _maptype = MapType.satellite;
  var _tripDistance = 0;
  var i = 1;

  @override
  void initState() {
    onPlaceSelected();
    super.initState();
    _iceCreamStores = Firestore.instance.collection('adm_pks').orderBy('name').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _iceCreamStores,
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

    PlaceService.getStep(googleMapsApiKey, originLatitude, originLongitude, destLatitude, destLongitude)
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

/*Future<DocumentReference> _addGeoPoint(
      double lat, double long, String name) async {
    print('Saving to Firestore');
    GeoFirePoint myPoint = geo.point(latitude: lat, longitude: long);
    return firestore
        .collection('locations')
        .add({'position': myPoint.data, 'name': name});
    //return firestore.collection('places')
    //.add( {'nom': name, 'latitude': point.latitude, 'longitude': point.longitude} );
  }*/


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
