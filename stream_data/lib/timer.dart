import 'package:stream_data/Entity/timerData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timer{
  bool _isActive = false;
  Duration _currentTime = Duration(minutes: 0);
  Duration _fullTime = Duration(minutes: 0);
  double _percent = 1.0;
  int _currentMode = 1;

  SharedPreferences? _sharedPreferences;

  Timer(){
    initSharePreference();
  }

  Stream<TimerData> stream() async*{
    yield* Stream.periodic(Duration(seconds: 1), (int count){
      if(_isActive){
        _currentTime -= Duration(seconds: 1);
        _percent = (_currentTime.inSeconds/_fullTime.inSeconds);
        if(_currentTime.inSeconds < 0){
          _isActive = false;
        }
      }
      return TimerData(_currentTime,_percent);
    });
  }

  void start(){
    _isActive = true;
  }

  void stop(){
    _isActive = false;
  }

  void restart(){
    _currentTime = _fullTime;
  }

  void setTimerMode(int mode){
    if(_sharedPreferences == null){
      initSharePreference();
    }
    switch(mode){
      case 1:
        _currentTime = Duration(minutes: _sharedPreferences!.getInt("Work")!);
        break;
      case 2:
        _currentTime = Duration(minutes: _sharedPreferences!.getInt("Short Break")!);
        break;
      case 3:
        _currentTime = Duration(minutes:  _sharedPreferences!.getInt("Long Break")!);
        break;
    }
    _fullTime = _currentTime;
    _currentMode = mode;
  }

  Duration refreshCurrentDuration() {
    switch(_currentMode){
      case 1:
        _currentTime = Duration(minutes: _sharedPreferences!.getInt("Work")!);
        break;
      case 2:
        _currentTime = Duration(minutes: _sharedPreferences!.getInt("Short Break")!);
        break;
      case 3:
        _currentTime = Duration(minutes:  _sharedPreferences!.getInt("Long Break")!);
        break;
    }
    _fullTime = _currentTime;
    return _currentTime;
  }

  Future<void> initSharePreference() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

}