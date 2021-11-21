import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.flutter_android_method_call');
  String batteryLevel = 'Unknown battery level.';

  @override
  Widget build(BuildContext context) {
    const spacer = Padding(padding: EdgeInsets.only(top: 10));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton(
            onPressed: () => onButtonClicked(),
            child: Text("Click"),
          ),
          spacer,
          Text(batteryLevel)
        ],),
      ),
    );
  }

  void onButtonClicked(){
     getBatteryLevel();
     showToast();
  }

  Future<void> getBatteryLevel() async {
    String _batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      _batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      _batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      batteryLevel = _batteryLevel;
    });
  }

  void showToast(){
    platform.invokeMethod('showToast');
  }
}
