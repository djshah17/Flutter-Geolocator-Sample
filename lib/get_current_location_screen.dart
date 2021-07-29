import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentLocationScreen extends StatefulWidget {
  @override
  _GetCurrentLocationScreenState createState() =>
      _GetCurrentLocationScreenState();
}

class _GetCurrentLocationScreenState extends State<GetCurrentLocationScreen> {
  Position currentPosition;
  String currentLocationAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Geolocator Sample'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPosition != null) Text("LAT: ${currentPosition.latitude}", style: TextStyle(fontSize: 23),),
              SizedBox(height: 15),
              if (currentPosition != null) Text("LONG: ${currentPosition.longitude}", style: TextStyle(fontSize: 23),),
              SizedBox(height: 15),
              if (currentLocationAddress != null) Text(currentLocationAddress, style: TextStyle(fontSize: 23),),
              SizedBox(height: 25),
              ElevatedButton(
                child: Text("Get Current Location",
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                onPressed: () {
                  getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        ));
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        getCurrentLocationAddress();
      });
    }).catchError((e) {
      print(e);
    });
  }

  getCurrentLocationAddress() async {
    try {
      List<Placemark> listPlaceMarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = listPlaceMarks[0];

      setState(() {
        currentLocationAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
