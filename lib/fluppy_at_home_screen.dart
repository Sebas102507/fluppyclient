import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/como_llegar_veterinaria_screen.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/recetas_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/veterinarias_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class FluppyAtHomeScreen extends StatefulWidget {
  @override
  _FluppyAtHomeScreen createState() => _FluppyAtHomeScreen();
}

class _FluppyAtHomeScreen extends State<FluppyAtHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        //color: Colors.red,
        child: Column(
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.safeBlockVertical * 28,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  )
              ),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 5
                      ),
                      //color: Colors.orange,
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 2,
                          right: SizeConfig.safeBlockHorizontal * 2,
                        ),
                        width: double.infinity,
                        height: SizeConfig.safeBlockVertical * 18,
                        child: Container(
                          //color: Colors.red,
                            margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical,
                            ),
                            width: double.infinity,
                            height: SizeConfig.blockSizeVertical * 7,
                            child: Container(
                              //color: Colors.deepOrangeAccent,
                                width: SizeConfig.safeBlockHorizontal * 2,
                                height: SizeConfig.blockSizeVertical * 7,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.safeBlockHorizontal * 90
                                ),
                                child: InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context, MaterialPageRoute(builder: (
                                        context) => VeterinariasScreen()));
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                )
                            )
                        ),
                      )
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.safeBlockVertical * 15,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                            width: SizeConfig.blockSizeHorizontal*20,
                            height: SizeConfig.safeBlockVertical * 5,
                            //color: Colors.yellow,
                            child: CachedNetworkImage(
                              imageUrl: "https://static.wixstatic.com/media/07fea2_a9773a483c5744de9a683361e954e9c3~mv2.png",
                              fit: BoxFit.fitHeight,
                            )
                        ),
                        Container(
                            width: SizeConfig.blockSizeHorizontal*75,
                            height: SizeConfig.safeBlockVertical * 8,
                            //color: Colors.brown,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text("Fluppy Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*3.5),),
                                  Text("Comparte en casa con tu peludo",style: TextStyle(color: Colors.white,fontSize: SizeConfig.safeBlockVertical*2),textAlign: TextAlign.start,)
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.safeBlockVertical * 70,
              //color: Colors.red,
              child: ListView(
                children: [
                  optionButton("Recetas", "https://static.wixstatic.com/media/07fea2_a6eacbe453244abaaa26015f77ba3b47~mv2.png", Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RecetasScreen()));
                  }),
                  optionButton("Próximamente", "https://static.wixstatic.com/media/07fea2_95f8e7503466476ea3a52db88015a93d~mv2.png", Colors.grey, () {
                    Fluttertoast.showToast(
                        msg: "Próximamente :)",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                        timeInSecForIos: 2);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget optionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        margin: EdgeInsets.only(
            top: SizeConfig.safeBlockVertical*2
        ),
        width: SizeConfig.safeBlockHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Material(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: background,
          child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: SizeConfig.safeBlockHorizontal * 100,
                    height: SizeConfig.safeBlockVertical * 15,
                    child: Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 1,
                          child: Container(
                            //color: Colors.green,
                            width: SizeConfig.safeBlockHorizontal * 100,
                            height: SizeConfig.safeBlockVertical * 8,
                            child: CachedNetworkImage(
                              imageUrl: image,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Container(
                          //color: Colors.green,
                            width: SizeConfig.safeBlockHorizontal * 85,
                            height: SizeConfig.safeBlockVertical * 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(title,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical*2.3,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        )
                      ],
                    )
                ),
              )
          ),
        )
    );
  }
}