import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helocar/Models/allUsers.dart';
import 'package:helocar/Models/drivers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

String mapKey = "AIzaSyDlM0ZKlniBn4uum3uZE00KgtWoa5bOnp4";

User firebaseUser;

Users userCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> rideStreamSubscription;

// final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";

double starCounter = 0.0;

String rideType = "";

bool isDriverAvailable = false;

var formatter = NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0);
