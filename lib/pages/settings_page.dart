import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  double _lowerValue = 0.5;
  double _upperValue = 20;
  double thumbLeftPosition;
  double thumbRightPosition;

  Widget slider(){
    return RangeSlider(
      min: 0.0,
      max: 20,
      lowerValue: _lowerValue,
      upperValue: _upperValue,
      divisions: 1000,
      showValueIndicator: true,
      valueIndicatorMaxDecimals: 1,
      onChanged: (double newLowerValue, double newUpperValue) {
        setState(() {
          _lowerValue = newLowerValue;
          _upperValue = newUpperValue;
        });
      },
      onChangeStart: (double startLowerValue, double startUpperValue) {
        print('Started with values: $startLowerValue and $startUpperValue');
      },
      onChangeEnd: (double newLowerValue, double newUpperValue) {
        print('Ended with values: $newLowerValue and $newUpperValue');
      },
    );
  }

  Widget settingsTile(Widget child, Color color, Function func) => Column(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 13,
        color: color,
        child: FlatButton(
          onPressed: (){
            func();
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              child: child,
              padding: EdgeInsets.only(left: 15),
            ) 
          )
        ),
      ),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade300,
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: <Widget>[
          FlatButton(
            child: Text("Done",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          settingsTile(
            Text(
              "Get Adino Diamond", 
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ) 
            ),
            Colors.yellowAccent[700],
            null
          ),
          Container(
            height: MediaQuery.of(context).size.height / 13,
            padding: EdgeInsets.fromLTRB(30,30,30,10),
            child: Text(
              "Discovery Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, 
                color: Colors.black
              )
            ),
          ),
          settingsTile(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Location: "),
                Text("Current location")
              ],
            ), 
            Colors.white,
            null
          ),
          settingsTile(Text("Maximum distance"), Colors.white, null),
          Container(
            width: double.infinity,
            height: 100,
            child:SliderTheme(
              data: SliderTheme.of(context).copyWith(
                 overlayColor: Colors.grey[300],
                 valueIndicatorColor: Colors.black,
                 thumbColor: Colors.black,
                 activeTickMarkColor: Colors.grey,
                 inactiveTickMarkColor: Colors.grey,
                
                activeTrackColor: Colors.red,
                // inactiveTrackColor: Colors.grey
              ),
              
              child: slider(),
            ),
          ),
          settingsTile(Text("Share Adino"), Colors.white, null),
          settingsTile(Text("Push notification"),Colors.white,  null),
          Container(
            height: MediaQuery.of(context).size.height / 13,
            child: Text(
              "Legal", 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, 
                color: Colors.black
              )
            ),
            padding: EdgeInsets.fromLTRB(30,30,30,30),
          ),
          settingsTile(Text("Privacy and Policy"),Colors.white,  null),
          settingsTile(Text("Terms of Service"), Colors.white, null),
          Container(
            height: MediaQuery.of(context).size.height / 13,
            child: Text("About Us",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold)),
            padding: EdgeInsets.fromLTRB(30,30,30,30),
          ),
          settingsTile(Text("Contact Us"),Colors.white,  null),
          settingsTile(Text("FAQ"),Colors.white,  null),
          Container(
            height: MediaQuery.of(context).size.height / 13,
            child: Text("Account",style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold)),
            padding: EdgeInsets.fromLTRB(30,30,30,30),
          ),
          settingsTile(Text("Logout", style:TextStyle(fontSize: 15)),Colors.white,  null),
          settingsTile(Text("Delete account",textAlign: TextAlign.center,
           style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.redAccent[400])),
           Colors.white,  null)
        ],
      ),
    );
    
  }
  
}