//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/maps/api_key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class PolyDrawer extends StatefulWidget {
  @override
  PolyDrawerState createState() => PolyDrawerState();
}

class PolyDrawerState extends State<PolyDrawer> {
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double _originLatitude = 35.828341, _originLongitude = -5.362877;
  double _destLatitude = 35.599752, _destLongitude = -5.339131;

  @override
  void initState() {
    _getPolyline();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Text(
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text(" Polyline Added")))
          .toString(),
    );
  }

  Polyline _addPolyLine() {
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
        googleMapsApiKey,
        _originLatitude,
        _originLongitude,
        _destLatitude,
        _destLongitude);
    if (result.isNotEmpty) {
      print(result);
      print('not empty');
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        //_addGeoPoint(point.latitude, point.longitude, point.toString());
      });
    }
    _addPolyLine();
  }
}
