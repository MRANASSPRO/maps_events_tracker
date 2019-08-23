import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/resources/blocs/car_pickup_bloc.dart';

class CarPickup extends StatefulWidget {
  CarPickup(this.distance);
  final int distance;

  @override
  _CarPickupState createState() => _CarPickupState();
}

class _CarPickupState extends State<CarPickup> {
  var carBloc = new CarPickupBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: carBloc.stream,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            Positioned(
              bottom: 50,
              right: 0,
              left: 0,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Distance (' + _getDistanceInfo() + ') ', style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getDistanceInfo() {
    print('distance3');
    print(widget.distance);
    double distanceInKM = widget.distance / 1000;
    return distanceInKM.toString() + ' km';
  }

  double _getTotal() {
    double distanceInKM = widget.distance / 1000;
    return (distanceInKM * carBloc.getCurrentCar().pricePerKM);
  }
}
