import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:time_tracker_flutter_course/app/home/maps/poly_drawer.dart';
//import 'package:permission/permission.dart';

// Hue used by the Google Map Markers to match the theme
//const _pinkHue = 210.0;
BitmapDescriptor myIcon;
const _pinkHue = 20.0;
Set<Marker> markers;
final Firestore firestore = Firestore.instance;

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
    @required this.polylines,
    @required this.defaultMapType,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final Map<PolylineId, Polyline> polylines;
  final MapType defaultMapType;

  @override
  Widget build(BuildContext context) {
    //markers.clear();
    //loadMarkers();
    getFromFirestore();
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 11.0,
      ),
      mapType: defaultMapType,
      markers: markers,
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }

  Future<void> getFromFirestore() async {
    //DocumentReference ref = Firestore.instance.collection('pks_travaux').document('');
    //final List<DocumentSnapshot> documents = snapshot.documents;
    //DocumentSnapshot document = snap.documents[(snap.documents.length - 1)];
    //print('Number of docs: ${snap.documents.length}');
    //var docId = document.documentID;
    //documents.forEach((data) => print(data));
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'assets/20px-Peaje.png')
        .then((onValue) {
      myIcon = onValue;
    });

    QuerySnapshot snap = await firestore
        .collection('pks_travaux')
        .where('jobType', isGreaterThan: '')
        .getDocuments();

    List<String> listOfDocs = [];
    if (snap.documents.length != 0) {
      int j = 1;
      for (final doc in snap.documents) {
        listOfDocs.add(doc.documentID);
        print('Marker $j');
        j++;
        markers = snap.documents
            .map((doc) => Marker(
                  markerId: MarkerId(doc['id'] as String),
                  //icon: myIcon,
                  icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                  position: LatLng(
                    doc['location'].latitude as double,
                    doc['location'].longitude as double,
                  ),
                  infoWindow: InfoWindow(
                    title: doc['name'] as String,
                    snippet: doc['jobType'] as String,
                  ),
                  //onDragEnd:  (LatLng position) {_onMarkerDragEnd(MarkerId(document['placeId'] as String), position);},
                ))
            .toSet();
      }
      print('all documents $listOfDocs');
    }
  }

/*void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }*/

}
