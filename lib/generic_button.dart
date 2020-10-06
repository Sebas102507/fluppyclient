import 'package:flutter/material.dart';

class GenericButton extends StatefulWidget{
  String text;
  double width;
  Color color;
  Color textColor;
  double height;
  VoidCallback onPressed;
  double textSize;
  double radius;
  GenericButton({Key key,this.text,this.height, this.width, this.color, this.textColor, this.onPressed, this.textSize,this.radius});
  @override
  State<StatefulWidget> createState() {
    return _GenericButton();
  }

}
class _GenericButton extends State<GenericButton>{
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
         width: widget.width,
        height: widget.height,
        child: ButtonTheme(
          minWidth: widget.width,
          height: widget.height,
          child: RaisedButton(
              onPressed: widget.onPressed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
              color: widget.color,
              child: Center(
                child: Text(widget.text,
                  style: TextStyle(
                      fontSize: widget.textSize,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                      fontFamily: "RobotoRegular"
                  ),
                ),
              )
          ),
        )
    );
  }

}