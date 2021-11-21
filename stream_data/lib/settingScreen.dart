import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_data/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: SettingPage(),
      );
  }
  
}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  static const String WORKTIME = "Work";
  static const String SHORTBREAKTIME = "Short Break";
  static const String LONGBREAKTIME = "Long Break";
  int workTimeValue = 0;
  int workTimeMinValue = 0;
  int workTimeMaxValue = 10;

  int shortTimeValue = 0;
  int shortTimeMinValue = 0;
  int shortTimeMaxValue = 5;

  int longTimeValue = 0;
  int longTimeMinValue = 0;
  int longTimeMaxValue = 15;

  late SharedPreferences sharedPreferences;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: readSetting(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SettingButton(title: "Work",
                minusLabel: "-",
                plusLabel: "+",
                value: workTimeValue,
                minValue: workTimeMinValue,
                maxValue: workTimeMaxValue,
                onMinusPressed: updateSetting,
                onPlusPressed: updateSetting,
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              SettingButton(title: "Short Break",
                  minusLabel: "-",
                  plusLabel: "+",
                  value: shortTimeValue,
                  minValue: shortTimeMinValue,
                  maxValue: shortTimeMaxValue,
                  onMinusPressed: updateSetting,
                  onPlusPressed: updateSetting),
              Padding(padding: EdgeInsets.only(top: 50)),
              SettingButton(title: "Long Break",
                  minusLabel: "-",
                  plusLabel: "+",
                  value: longTimeValue,
                  minValue: longTimeMinValue,
                  maxValue: longTimeMaxValue,
                  onMinusPressed: updateSetting,
                  onPlusPressed: updateSetting)
            ],);
        }
        else{
          return Center(
              child: Text("Loading..."),
          );
        }
        });
  }

  Future<void> readSetting() async{
    sharedPreferences = await SharedPreferences.getInstance();
    int? _workTimeValue = sharedPreferences.getInt(WORKTIME);
    if(_workTimeValue == null){
      workTimeValue = 0;
      sharedPreferences.setInt(WORKTIME, workTimeValue);
    }else{
      workTimeValue = _workTimeValue;
    }

    int? _shortTimeValue = sharedPreferences.getInt(SHORTBREAKTIME);
    if(_shortTimeValue == null){
      shortTimeValue = 0;
      sharedPreferences.setInt(WORKTIME, shortTimeValue);
    }else{
      shortTimeValue = _shortTimeValue;
    }
    int? _longTimeValue = sharedPreferences.getInt(LONGBREAKTIME);
    if(_longTimeValue == null){
      longTimeValue = 0;
      sharedPreferences.setInt(WORKTIME, longTimeValue);
    }else{
      longTimeValue = _longTimeValue;
    }
  }

  void updateSetting(String key, int value){
    switch(key){
      case WORKTIME:
        workTimeValue = value;
        sharedPreferences.setInt(key, value);
        break;
      case SHORTBREAKTIME:
        shortTimeValue = value;
        sharedPreferences.setInt(key, value);
        break;
      case LONGBREAKTIME:
        longTimeValue = value;
        sharedPreferences.setInt(key, value);
        break;
    }
  }

}


