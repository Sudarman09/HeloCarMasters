import 'package:helocar/AllScreens/carInfoScreen.dart';
import 'package:helocar/AllScreens/loginScreen.dart';
import 'package:helocar/AllScreens/splashScreen.dart';
import 'package:helocar/DataHandler/appData.dart';
import 'package:helocar/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AllScreens/mainScreen.dart';
import 'AllScreens/registrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef =
    FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.reference().child("ride_requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .reference()
    .child("drivers")
    .child(currentFirebaseUser.uid)
    .child("newRide");
// DatabaseReference availableDriverRef = FirebaseDatabase.instance.reference().child("availableDrivers");

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('Could not load app'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => AppData(),
            child: MaterialApp(
              title: 'Helocar Driver',
              theme: ThemeData(
                primarySwatch: Colors.green,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: FirebaseAuth.instance.currentUser == null
                  ? SplashScreen.idScreen
                  : MainScreen.idScreen,
              routes: {
                SplashScreen.idScreen: (context) => SplashScreen(),
                RegistrationScreen.idScreen: (context) => RegistrationScreen(),
                MainScreen.idScreen: (context) => MainScreen(),
                CarInfoScreen.idScreen: (context) => CarInfoScreen(),
                LoginScreen.idScreen: (context) => LoginScreen(),
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                ],
              )
            ]);
      },
    );


  }
}
