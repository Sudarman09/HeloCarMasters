import 'dart:async';
import 'package:helocar/AllScreens/registrationScreen.dart';
import 'package:helocar/Assistants/assistantMethods.dart';
import 'package:helocar/Models/drivers.dart';
import 'package:helocar/Notifications/pushNotificationService.dart';
import 'package:helocar/configMaps.dart';
import 'package:helocar/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class HomeTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.527896275163215, 120.19268580228974),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();

  // String driverStatusText = " Lagi Tidak AKtif ";
  String pathToReference = "availableDrivers";

  // Color driverStatusColor = Colors.red;

  // bool isDriverAvailable = false;
  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  getRideType() {
    driversRef
        .child(currentFirebaseUser.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          rideType = snapshot.value.toString();
        });
      }
    });
  }

  getRatings() {
    //Retrieve and display ratings
    driversRef
        .child(currentFirebaseUser.uid)
        .child("ratings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        double ratings = double.parse(dataSnapshot.value.toString());

        setState(() {
          starCounter = ratings;
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Sangat Buruk";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Buruk";
          });
          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Baik";
          });
          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Sangat Baik";
          });
          return;
        }
        if (starCounter <= 5) {
          setState(() {
            title = "Excelent";
          });
          return;
        }
      }
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print("Alamat Anda kira-kira ini: " + address);
  }

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;

    driversRef
        .child(currentFirebaseUser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot != null) {
        driversInformation = Drivers.fromSnapshot(dataSnapshot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRatings();
    getRideType();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 28.0),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locatePosition();
          },
        ),

        //Online offline container for driver

        Positioned(
          top: 33.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0, left: 0),
                child: Center(
                  child: Container(
                    child: LiteRollingSwitch(
                      value: isDriverAvailable,
                      textOn: 'online',
                      textOff: 'offline',
                      colorOn: Colors.green,
                      colorOff: Colors.grey,
                      iconOn: Icons.lightbulb_outline,
                      iconOff: Icons.power_settings_new,
                      onChanged: (bool state) {
                        if (isDriverAvailable != true && state == true) {
                          makeDriverOnlineNow();
                          getLocationLiveUpdate();
                          setState(() {
                            isDriverAvailable = true;
                            rideRequestRef.set("searching");
                          });
                          displayToastMessage("Anda Berhasil Aktif", context);
                        } else if (isDriverAvailable == true &&
                            state == false) {
                          setState(() {
                            isDriverAvailable = false;
                          });
                          makeDriverOfflineNow();
                          displayToastMessage("Anda Berhasil Offline", context);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize(pathToReference);

    // Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.onValue.listen((event) {
      print(" Ini Geofire");
    });
  }

  void getLocationLiveUpdate() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef = null;
  }
}
