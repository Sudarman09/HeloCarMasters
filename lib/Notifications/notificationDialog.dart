import 'package:helocar/AllScreens/newRideScreen.dart';
import 'package:helocar/AllScreens/registrationScreen.dart';
import 'package:helocar/Assistants/assistantMethods.dart';
import 'package:helocar/Models/rideDetails.dart';
// import 'package:helocar/configMaps.dart';
import 'package:helocar/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Image.asset(
              "images/bike.png",
              width: 100.0,
            ),
            SizedBox(
              height: 18.0,
            ),
            Text(
              "Ada Permintaan Baru",
              style: TextStyle(fontFamily: "Brand Bold", fontSize: 18.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "images/pickicon.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Container(
                              child: Text(
                            rideDetails.pickup_address,
                            style: TextStyle(fontSize: 18.0),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "images/pickicon.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                            child: Container(
                          child: Text(
                            rideDetails.dropoff_address,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                  ],
                )),
            SizedBox(
              height: 20.0,
            ),
            Divider(
              height: 2.2,
              color: Colors.pink,
              thickness: 2.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      // assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Tolak!".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      // assetsAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },
                    color: Colors.white,
                    child: Text(
                      "Terima".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context) {
    rideRequestRef.once().then((DataSnapshot dataSnapshot) {
      Navigator.pop(context);
      String theRideId = "";
      if (dataSnapshot.value != null) {
        theRideId = dataSnapshot.value.toString();
      } else {
        displayToastMessage("Driver tidak aktif", context);
      }

      if (theRideId == rideDetails.ride_request_id) {
        rideRequestRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocation();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRideScreen(rideDetails: rideDetails)));
      } else if (theRideId == "cancelled") {
        displayToastMessage("Pesanan Dibatalkan", context);
      } else if (theRideId == "timeout") {
        displayToastMessage("waktu habis", context);
      } else {
        displayToastMessage("TIdak ada Driver yang aktif", context);
      }
    });
  }
}
