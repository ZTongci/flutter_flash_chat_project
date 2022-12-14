import 'package:flutter/material.dart';

class materialbutton extends StatelessWidget {
  materialbutton({@required this.color,@required this.onpress,@required this.title});
  Color color;
  Function onpress;
  Text title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color:color ,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: title,
        ),
      ),
    );
  }
}