import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_webservice/places.dart';
//import 'api_key.dart';

// Places API client used for Place Photos
//final _placesApiClient = GoogleMapsPlaces(apiKey: googleMapsApiKey);

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key key,
    @required this.document,
    @required this.mapController,
  }) : super(key: key);

  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  //bool _disposed = false;

  @override
  void initState() {
    super.initState();
    //_retrievePlacesDetails();
  }

  @override
  void dispose() {
    //_disposed = true;
    super.dispose();
  }

  /*Future<void> _retrievePlacesDetails() async {
    final details = await _placesApiClient.getDetailsByPlaceId(widget.document['placeId'] as String);
    //if (!_disposed) {
    if(details.result.photos != null && !_disposed){
      setState(() {
        _placePhotoUrl = _placesApiClient.buildPhotoUrl(
          photoReference: details.result.photos[0].photoReference,
          maxHeight: 300,
        );
      });
    }
    else{
      setState(() {
        _placePhotoUrl = '';
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['name'] as String),
      subtitle: Text(widget.document['address'] as String),
      leading: Container(
        width: 100,
        height: 100,
        //child: _placePhotoUrl.isNotEmpty
          child: _placePhotoUrl.isNotEmpty
            ? ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          child: Image.network(_placePhotoUrl, fit: BoxFit.cover),
        )
            //: Container(),
            : ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          child: Image.asset('assets/150px-Autoroute.png', fit: BoxFit.contain),
        )
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.document['location'].latitude as double,
                widget.document['location'].longitude as double,
              ),
              zoom: 30,
            ),
          ),
        );
      },
    );
  }
}