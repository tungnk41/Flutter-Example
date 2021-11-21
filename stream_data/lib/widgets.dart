import 'package:flutter/material.dart';

class ProductivityButton extends StatelessWidget{
   final Color color;
   final String text;
   final double? size;
   final VoidCallback? onPressed;

   ProductivityButton({required this.color, required this.text, this.size,required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        color: this.color,
        minWidth: (this.size != null) ? this.size : 0,
        onPressed: this.onPressed);
  }
}

typedef CallbackSetting = void Function(String, int);
class SettingButton extends StatefulWidget {
  String title;
  String minusLabel;
  String plusLabel;
  int value = 0;
  int minValue = 0;
  int maxValue = 0;
  CallbackSetting? onMinusPressed;
  CallbackSetting? onPlusPressed;

  SettingButton({Key? key,
    required this.title,
    required this.minusLabel,
    required this.plusLabel,
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.onMinusPressed,
    this.onPlusPressed,}) : super(key: key);

  @override
  _SettingButtonState createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {

  final double defaultPadding = 10;
  TextEditingController txtValue = TextEditingController(text: "0");
  TextStyle lableStyle = TextStyle(color: Color(0xff607D8B),fontSize: 18);
  TextStyle edtStyle = TextStyle(color: Color(0xff607D8B),fontSize: 18);
  TextStyle lableButtonStyle = TextStyle(color: Colors.white,fontSize: 16);

  @override
  void initState() {
      txtValue.text = (widget.value < widget.minValue ? widget.minValue : (widget.value > widget.maxValue ? widget.maxValue : widget.value)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(padding: EdgeInsets.only(top: defaultPadding)),
      Text(widget.title,style: lableStyle),
      Padding(padding: EdgeInsets.only(top: defaultPadding)),
      Row(children: [
        Padding(padding: EdgeInsets.only(left: defaultPadding)),
        Expanded(
          child: MaterialButton(
            color: Color(0xff455A64),
            onPressed: () => onMinusPressed(),
            child: Text(widget.minusLabel,style: lableButtonStyle,)), ),
        Padding(padding: EdgeInsets.only(left: defaultPadding)),
        Expanded(
          child: TextField(
            style: edtStyle,
            controller: txtValue,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,),
        ),
        Padding(padding: EdgeInsets.only(left: defaultPadding)),
        Expanded(
          child: MaterialButton(
              color: Color(0xff009688),
              onPressed: () => onPlusPressed(),
              child: Text(widget.plusLabel,style: lableButtonStyle,)),
        ),
        Padding(padding: EdgeInsets.only(right: defaultPadding)),
      ],)
    ],);
  }

  void onMinusPressed(){
    widget.value = (widget.value - 1 < widget.minValue) ? widget.minValue : (widget.value - 1);

    setState(() {
      txtValue.text = widget.value.toString();
    });
    if(widget.onMinusPressed != null){
      widget.onMinusPressed!(widget.title,widget.value);
    }
  }

  void onPlusPressed(){
    widget.value = (widget.value + 1 > widget.maxValue) ? widget.maxValue : (widget.value + 1);
    setState(() {
      txtValue.text = widget.value.toString();
    });

    if(widget.onPlusPressed != null){
      widget.onPlusPressed!(widget.title,widget.value);
    }
  }
}
