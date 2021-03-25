import 'package:flutter/material.dart';
import 'package:curved_splash_screen/curved_splash_screen.dart';
import 'package:helocar/AllScreens/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String idScreen = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String skipBtn = 'Lewat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CurvedSplashScreen(
          screensLength: splashContent.length,
          backText: 'Balik',
          skipText: 'Lewat',
          firstGradiantColor: Colors.greenAccent,
          secondGradiantColor: Colors.green,
          forwardColor: Colors.deepOrange,
          screenBuilder: (index) {
            return SplashContent(
              title: splashContent[index]["title"],
              image: splashContent[index]["image"],
              text: splashContent[index]["text"],
            );
          },
          onSkipButton: () {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.idScreen, (route) => false);
          }),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String title;
  final String text;
  final String image;

  const SplashContent({
    Key key,
    @required this.title,
    @required this.text,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Container(
            height: 150,
            child: Image.asset(image),
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
            ),
          )
        ],
      ),
    );
  }
}

final splashContent = [
  {
    "title": "Download App",
    "text":
    "Start learning now by using this app, Get your choosen course and start the journey.",
    "image": "images/onboard_1.png",
  },
  {
    "title": "Buat Akun",
    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.",
    "image": "images/onboard_2.png",
  },
  {
    "title": "DI Jemput di Mana",
    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor!",
    "image": "images/onboard_3.png"
  },
  {
    "title": "Diantar Kemana.",
    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut.",
    "image": "images/onboard_4.png"
  },
  {
    "title": "Pilih Jenis Kendaraan",
    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.",
    "image": "images/onboard_5.png"
  },
  {
    "title": "Nikmati Perjalanan",
    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "image": "images/onboard_6.png"
  },
];