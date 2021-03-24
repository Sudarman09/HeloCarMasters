import 'package:helocar/AllScreens/loginScreen.dart';
import 'package:helocar/AllScreens/mainScreen.dart';
import 'package:helocar/AllScreens/registrationScreen.dart';
import 'package:helocar/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import '../main.dart';

class ProfileTabPage extends StatefulWidget {
  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              driversInformation.name,
              style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"),
            ),
            SizedBox(
              height: 10,
              width: 100,
              child: Divider(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
              width: 100,
              child: Divider(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            InfoCard(
              text: driversInformation.phone,
              icon: Icons.phone,
              onPressed: () async {
                print("Ini no telepon kamu");
              },
            ),
            InfoCard(
              text: driversInformation.email,
              icon: Icons.email,
              onPressed: () async {
                print("Ini no email kamu");
              },
            ),
            InfoCard(
              text: driversInformation.car_color +
                  " | " +
                  driversInformation.car_model +
                  " | " +
                  driversInformation.car_number,
              icon: Icons.car_repair,
              onPressed: () async {
                print("Ini no info mobil kamu");
              },
            ),
            GestureDetector(
              onTap: () async {
                if (isDriverAvailable == false) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                  await Geofire.removeLocation(currentFirebaseUser.uid);
                  rideRequestRef.onDisconnect();
                  rideRequestRef.remove();
                  rideRequestRef = null;
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                  displayToastMessage(
                      "Oflinekan dulu di halaman utama lalu keluar", context);
                }
              },
              child: Card(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.follow_the_signs_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Keluar Aplikasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Brand Bold'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title: Text(
            text,
            style: TextStyle(
                color: Colors.black87, fontSize: 16, fontFamily: 'Brand Bold'),
          ),
        ),
      ),
    );
  }
}
