import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/maps/maps_page01.dart';
//import 'package:time_tracker_flutter_course/widgets/car_pickup.dart';
//import 'package:time_tracker_flutter_course/widgets/ride_picker.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MapsPage01(title: 'Section Fnideq-Tetouan'),
      //body: const MapsPage01(),
    );
  }

/*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: const MapsPage01(title: ''),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
    );
  }*/

/*@override
  Widget build(BuildContext context) {
    print('build UI');
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              polylines: Set<Polyline>.of(_polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(10.7915178, 106.7271422),
                zoom: 14.4746,
              ),
            ),
            /*Positioned(
              left: 20,
              top: 0,
              right: 0,
              //bottom: 50,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  ),
                ],
              ),
            ),*/
            /*Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              height: 110,
              child: CarPickup(_tripDistance),
            )*/
          ],
        ),
      ),
      /*drawer: Drawer(
        child: HomeMenu(),
      ),*/
    );
  }*/


}
