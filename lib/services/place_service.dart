import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:time_tracker_flutter_course/app/home/maps/api_key.dart';
import 'package:time_tracker_flutter_course/model/place_item_res.dart';
import 'package:time_tracker_flutter_course/model/trip_info_res.dart';

//import 'package:time_tracker_flutter_course/repository/network_util.dart';
//import 'package:time_tracker_flutter_course/repository/PointLatLng.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            googleMapsApiKey +
            "&language=en&region=US&query=" +
            Uri.encodeQueryComponent(keyword);

    print("search >>: " + url);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return new List();
    }
  }

  //static Future<dynamic> getStep(double lat, double lng, double tolat, double tolng) async {
  static Future<dynamic> getStep(String googleApiKey, double lat, double lng,
      double tolat, double tolng) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=" +
            lat.toString() +
            "," +
            lng.toString() +
            "&destination=" +
            tolat.toString() +
            "," +
            tolng.toString() +
            "&mode=driving" +
            "&key=$googleApiKey";
    print(url);

    final JsonDecoder _decoder = new JsonDecoder();
    //var response = await http.get(url);
    return http.get(url).then((http.Response response) async {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      //List<PointLatLng> steps = _parseSteps(json["routes"][0]["legs"][0]["steps"]);

      TripInfoRes tripInfoRes;
      try {
        var json = _decoder.convert(response.body);
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        final PolylinePoints polylinePointsInstance = PolylinePoints();
        List<PointLatLng> routePoints = await polylinePointsInstance
            .getRouteBetweenCoordinates(googleApiKey, lat, lng, tolat, tolng);

        tripInfoRes = TripInfoRes(distance, routePoints);
      } catch (error) {
        throw Exception(error.toString());
      }

      return tripInfoRes;
    });
  }
}

/*//static List<StepsRes> _parseSteps(final responseBody) {
  static List<PointLatLng> _parseSteps(final responseBody) {
    var list = responseBody.map<StepsRes>((json) => new StepsRes.fromJson(json)).toList();

    return list;
  }*/
