//import 'package:fl_uberapp/src/model/step_res.dart';
//import 'package:time_tracker_flutter_course/repository/PointLatLng.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class TripInfoRes {
  TripInfoRes(this.distance, this.polylinePoints);
  final int distance;
  final List<PointLatLng> polylinePoints;
//final List<StepsRes> steps;

}