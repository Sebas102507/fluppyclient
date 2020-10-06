import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluppyclient/fluppy_icons_icons.dart';
import 'package:fluppyclient/recetas_screen.dart';
import 'package:fluppyclient/retos_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'blocUser.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:video_player/video_player.dart';

class RecetaLayout extends StatefulWidget {
  String name;
  String backgroundImage;
  String recetaImage;
  String type;
  String description;
  RecetaLayout({Key key,this.backgroundImage,this.description,this.type,this.name,this.recetaImage});
  State<StatefulWidget> createState() => _RecetaLayout();
}

class _RecetaLayout extends State<RecetaLayout> {
  UserBloc userBloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  //height: SizeConfig.blockSizeVertical*100,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.blockSizeHorizontal*100 ,
                        height: SizeConfig.blockSizeVertical*64,
                        color: Colors.deepOrange,
                        //color: Colors.blue,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 2
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
                                                Navigator.pop(context, MaterialPageRoute(builder: (context)=>RecetasScreen()));
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
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*2,
                                    //left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  width: SizeConfig.blockSizeHorizontal*100 ,
                                  height: SizeConfig.blockSizeVertical * 50,
                                  //color: Colors.redAccent,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.recetaImage,
                                  )
                              ),
                              Container(
                                  width: SizeConfig.safeBlockHorizontal*90,
                                  //height: SizeConfig.safeBlockVertical*4,
                                  decoration: BoxDecoration(
                                      //color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                      )
                                  ),
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.safeBlockHorizontal*40,
                                      right: SizeConfig.safeBlockHorizontal*40
                                  ),
                                  child: widget.type.toLowerCase()=="perro"? Icon(FluppyIcons.dogcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*5,)
                                      : widget.type.toLowerCase()=="gato"? Icon(FluppyIcons.catcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*5,)
                                      : Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        //width: SizeConfig.safeBlockHorizontal*12,
                                        child: Row(
                                          children: [
                                            Icon(FluppyIcons.dogcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*5,),
                                            Icon(FluppyIcons.catcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*5,)
                                          ],
                                        ),
                                      )
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        height: SizeConfig.blockSizeVertical*100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          /* borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight:Radius.circular(20),
                        )*/
                        ),
                        margin: EdgeInsets.only(
                          //left: SizeConfig.safeBlockHorizontal*1,
                          //right: SizeConfig.safeBlockHorizontal*1
                        ),
                        child: Column(
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*1
                              ),
                              //color: Colors.red,
                              width: double.infinity,
                              child: Text("¡${widget.name}!",
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                  fontSize: SizeConfig.safeBlockVertical*3,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical*1
                                ),
                                //color: Colors.red,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: Text("${widget.description.replaceAll("\\n", "\n")}",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: SizeConfig.safeBlockVertical*2,
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}