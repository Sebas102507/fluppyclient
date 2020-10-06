import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';



class TipsScreen extends StatelessWidget {
  double screenWidth;
  double screenHeight;
  double bigContainer;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    bigContainer = (screenHeight - (2 * (screenHeight / 20)));
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              //color: Colors.red,
                margin: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeVertical,
                    top: SizeConfig.safeBlockVertical * 4
                ),
                width: double.infinity,
                height: screenHeight / 16,
                child: Container(
                  //color: Colors.deepOrangeAccent,
                    width: SizeConfig.safeBlockHorizontal * 2,
                    height: SizeConfig.blockSizeVertical * 7,
                    margin: EdgeInsets.only(
                        right: SizeConfig.safeBlockHorizontal * 90
                    ),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF211551),
                        size: SizeConfig.blockSizeVertical * 4,
                      ),
                    )
                )
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: SizeConfig.safeBlockVertical
              ),
              height: SizeConfig.safeBlockVertical * 30,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: "https://static.wixstatic.com/media/07fea2_22257b83a2ca48c3bb454bd0cade141f~mv2.png/v1/fill/w_614,h_614,al_c,lg_1/idea.png",
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockVertical
              ),
              //color: Colors.redAccent,
              height: SizeConfig.safeBlockVertical * 5,
              width: double.infinity,
              child: Text(
                "¿Sabías que?",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  color: Color(0xFF211551),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _tipStream()
          ],
        ),
      ),
    );
  }
  Widget _tipStream() {
    return StreamBuilder(
        stream: Firestore.instance.collection('fluppyConsejo').document("consejo").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                ),
              ),
            );
          } else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text("ERROR"),
              ),
            );
          }else{
            return   Container(
              //color: Colors.amberAccent,
                height: SizeConfig.safeBlockVertical * 42,
                width: SizeConfig.safeBlockHorizontal*90,
                child: Text(snapshot.data["textoConsejo"],
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.justify,
                )
            );
          }
        }
    );
  }
}
