class TimerData{
   double _percent;
   Duration _currentTime;

  TimerData(this._currentTime,this._percent);

  String currentTime(){
    int minutes = _currentTime.inMinutes;
    int remainSeconds = _currentTime.inSeconds - minutes*60;
    String strMinutes = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
    String strSeconds = (remainSeconds < 10) ? "0" + remainSeconds.toString() : remainSeconds.toString();

    return strMinutes + ":" + strSeconds;
  }

  double percent(){
    return this._percent;
  }
}