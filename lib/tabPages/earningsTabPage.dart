import 'package:helocar/AllScreens/historyScreen.dart';
import 'package:helocar/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configMaps.dart';

class EarningsTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var formatter = NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0);
    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  "Total Pendapatan",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "${formatter.format(double.parse(Provider.of<AppData>(context, listen: false).earnings))}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 41,
                      fontFamily: "Brand Bold"),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  "images/ubergo.png",
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Total Perjalanan",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    Provider.of<AppData>(context, listen: false)
                        .countTrips
                        .toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),
                  ),
                )),
              ],
            ),
          ),
        ),
        Divider(
          height: 2.0,
          thickness: 2.0,
        ),
      ],
    );
  }
}
