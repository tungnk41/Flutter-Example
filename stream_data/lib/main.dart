
import 'package:flutter/material.dart';
import 'package:stream_data/Entity/timerData.dart';
import 'package:stream_data/settingScreen.dart';
import 'package:stream_data/timer.dart';
import 'package:stream_data/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerHomePage(title: 'Timer'),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  TimerHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {

  Timer timer = Timer();
  bool isActived = false;
  String state = "Start";
  TimerData initTimerData = TimerData(Duration(seconds: 0), 1);

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>.empty(growable: true);
    menuItems.add(PopupMenuItem(value: "Settings", child: Text("Settings")));


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext context){
                return menuItems.toList();
              },
              onSelected: (item){
                if(item == "Settings"){
                  goToSettingScreen(context);
                }
              },
          ),
        ],
      ),
      body: LayoutBuilder(builder: (BuildContext context,BoxConstraints constraints){
        final double availableWidth = constraints.maxWidth;
        final double defaultPadding = 5;
        return Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(defaultPadding)),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
                Expanded(child: ProductivityButton(
                  color: Color(0xff009688),
                  text: "Work",
                  onPressed: () => onWork(),
                )),
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
                Expanded(child: ProductivityButton(
                  color: Color(0xff607D8B),
                  text: "Short Break",
                  onPressed: onShortBreak,
                )),
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
                Expanded(child: ProductivityButton(
                  color: Color(0xff455A64),
                  text: "Long Break",
                  onPressed: onLongBreak,
                )),
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
              ],
            ),
            StreamBuilder(
                stream: timer.stream(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  TimerData? timerData = snapshot.data;
                  return Expanded(child: CircularPercentIndicator(
                    radius: availableWidth/2,
                    lineWidth: 10,
                    percent: timerData == null ? 1.0 : timerData.percent(),
                    center: Text(timerData == null ? "00:00" : timerData.currentTime(), style: Theme.of(context).textTheme.headline4),
                    progressColor: Color(0xff009688),
                  ));
                },
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
                Expanded(child: ProductivityButton(
                  color: Color(0xff212121),
                  text: state,
                  onPressed: toggleState,
                )),
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
                Expanded(child: ProductivityButton(
                  color: Color(0xff009688),
                  text: "Restart",
                  onPressed: onRestart,
                )),
                Padding(padding: EdgeInsets.only(left: 5,right: 5)),
              ],
            ),
            Padding(padding: EdgeInsets.all(defaultPadding)),
          ],
        );
       }
      ),
    );
  }

  void toggleState(){
    if(isActived){
      isActived = false;
      timer.stop();
    }else{
      isActived = true;
      timer.start();
    }
    setState(() {
      state = isActived ? "Stop" : "Start";
    });
  }

  void onRestart(){
    timer.restart();
  }
  void onWork(){
    timer.setTimerMode(1);
  }
  void onShortBreak(){
    timer.setTimerMode(2);
  }
  void onLongBreak(){
    timer.setTimerMode(3);
  }

  void goToSettingScreen(BuildContext context){
    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    };

    Navigator.of(context)
        .push(_createRoute())
        .then((value) {
           timer.refreshCurrentDuration();
        });
  }
}


