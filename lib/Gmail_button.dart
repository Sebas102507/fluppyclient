import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
class GmailButton extends StatefulWidget{
  final VoidCallback onPresed;// toca que sea final porque es requerida @require

  GmailButton ({Key key,@required this.onPresed});
//  final VoidCallback onPresed;// toca que sea final porque es requerida @require

  //GmailButton ({Key key,@required this.onPresed});

  @override
  State<StatefulWidget> createState() {
    return _GmailButton();
  }

}
class _GmailButton extends State<GmailButton>{
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return   ButtonTheme(
          minWidth: double.infinity,
           height: SizeConfig.safeBlockHorizontal* 15,
          child: RaisedButton(
            onPressed: widget.onPresed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.red,
            child: Center(
              child: Container(
                child: Text("Continuar con Google",
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal* 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white//Color(0xFF00c68e)
                  ),
                ),
              )
            )
          ),
    );
  }
}