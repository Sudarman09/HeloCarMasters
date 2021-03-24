import 'package:helocar/Models/history.dart';
import 'package:helocar/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helocar/Assistants/requestAssistant.dart';
import 'package:helocar/DataHandler/appData.dart';

import 'package:helocar/Models/directionDetails.dart';
import 'package:helocar/configMaps.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "gagal") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  //Hitung Biaya
  static int calculateFares(DirectionDetails directionDetails) {
    double totalFareAmount;
    if (rideType == "helo-otoE") {
      totalFareAmount = (directionDetails.distanceValue / 1000) * 2000;
    } else if (rideType == "helo-otoX") {
      totalFareAmount = (directionDetails.distanceValue / 1000) * 2500;
    } else if (rideType == "helo-pickUp") {
      totalFareAmount = (directionDetails.distanceValue / 1000) * 3500;
    }

    return totalFareAmount.truncate();
  }

  static void disableHomeTabLiveLocation() {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLiveLocation() {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //Retrieve and display earnings
    driversRef
        .child(currentFirebaseUser.uid)
        .child("earnings")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        String earning = dataSnapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earning);
      }
    });

    //Retrieve and display Trip History
    driversRef
        .child(currentFirebaseUser.uid)
        .child("history")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        //merge two data source
        // update total number trip count to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        // update trip keys count to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRequestsRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    // Intl.defaultLocale = 'id';
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }
}
