import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/fluppy_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/reset_password_screen.dart';
import 'package:fluppyclient/reto_layout_screen.dart';
import 'package:fluppyclient/sign_in_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'blocUser.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
class RetosScreen extends StatefulWidget {
  String userId;
  RetosScreen(this.userId);
  State<StatefulWidget> createState() => _RetosScreen();
}

class _RetosScreen extends State<RetosScreen> {
  UserBloc userBloc;
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    return handlePointsStream();
  }


  Widget handlePointsStream(){
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(widget.userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot userSnapshot){
        if(!userSnapshot.hasData){
          return Scaffold(
            body: Container(
              child: Center(
                child: Container(
                  width: SizeConfig.blockSizeHorizontal*20,
                 height: SizeConfig.blockSizeHorizontal*20,
                 child: Center(
                   child: Container(
                     width: SizeConfig.blockSizeHorizontal*10,
                     height: SizeConfig.blockSizeHorizontal*10,
                     child: CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                     ),
                   ),
                 )
                )
              ),
            ),
          );
        }else{
          return Scaffold(
            body: Container(
              //color: Colors.green,
              child: Column(
                children: [
                  Container(
                    //color: Colors.pink,
                      margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical,
                        top: SizeConfig.blockSizeVertical * 5,
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
                              FocusScope.of(context).requestFocus(new FocusNode());
                              Navigator.of(context).pop(MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF53d2be),
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                          )
                      )
                  ),
                  Container(
                    //color: Colors.blue,
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical * 22,
                    child: Center(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal*100,
                              height: SizeConfig.blockSizeVertical * 12,
                              decoration: BoxDecoration(
                                 // color: Colors.green,
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: "https://static.wixstatic.com/media/07fea2_f4aea0f1f89246dabd75f8280ea81806~mv2.png",
                              ),
                            ),
                            /*Divider(
                              color: Colors.grey,
                              height: SizeConfig.blockSizeVertical * 2,
                            ),*/
                            Container(
                              width: SizeConfig.blockSizeHorizontal*100,
                                //height: SizeConfig.blockSizeVertical * 8,
                              //color: Colors.red,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal*35,
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Icon(
                                          FluppyIcons.coin,
                                          size: SizeConfig.safeBlockVertical*4,
                                          color: Colors.deepOrange
                                      ),
                                      Text("${userSnapshot.data["points"]}",
                                        style: TextStyle(
                                            fontSize: SizeConfig.safeBlockVertical*4,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "RobotoRegular",
                                            color: Colors.deepOrange
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              )
                            ),
                            Divider(
                              color: Colors.grey,
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  Container(
                    //color: Colors.greenAccent,
                      width: double.infinity,
                      height: SizeConfig.blockSizeVertical*55,
                      decoration: BoxDecoration(
                        //color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                       // border: Border.all(color: Color.fromRGBO(83, 210, 190, 0.5),width: SizeConfig.blockSizeHorizontal*2)
                      ),
                      child: StreamBuilder(
                          stream: Firestore.instance.collection("challenges").snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot ){
                            if(!snapshot.hasData || snapshot.hasError){
                              return Container(
                                  child: Center(
                                      child: Container(
                                          width: SizeConfig.blockSizeHorizontal*20,
                                          height: SizeConfig.blockSizeHorizontal*20,
                                          child: Center(
                                            child: Container(
                                              width: SizeConfig.blockSizeHorizontal*10,
                                              height: SizeConfig.blockSizeHorizontal*10,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                                              ),
                                            ),
                                          )
                                      )
                                  ),
                                );
                            }else{
                              return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return retoLayout(
                                      snapshot.data.documents[index].data["image"],
                                      snapshot.data.documents[index].data["name"],
                                      snapshot.data.documents[index].data["shortDescription"],
                                      snapshot.data.documents[index].data["description"],
                                      snapshot.data.documents[index].data["video"],
                                      snapshot.data.documents[index].data["points"],
                                      userSnapshot.data["points"],
                                      snapshot.data.documents[index].data["id"],
                                  );
                                },
                              );
                            }
                          }
                      )
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }



Widget retoLayout(String image, String name,String shortDescription,String description,String videoLink,
    int points,int userCurrentPoints, String retoId){
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.safeBlockVertical*1
      ),
      width: SizeConfig.blockSizeHorizontal*90,
      height: SizeConfig.blockSizeVertical * 12,
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow (
              color:  Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0.0, 0.2)
          )
        ],
      ),
      child: RaisedButton(
        onPressed: (){
          print("INICIAR RETO");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>RetoLayoutScreen(retoName: name,retoDescription: description,
                videoUrl: videoLink,
                userId: widget.userId,
                retoCoins: points,
                retoId: retoId,
                userCurrentCoins: userCurrentPoints,
              )));
        },
        color: Colors.white,
        padding: EdgeInsets.all(0),
        child: Row(
          children: [
            Container(
                width: SizeConfig.blockSizeHorizontal*25,
                height: SizeConfig.blockSizeVertical*12,
                //color: Colors.red,
                child: Center(
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal*22,
                    height:SizeConfig.blockSizeHorizontal*22,
                    decoration: BoxDecoration(
                      //color: Colors.grey,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(image)
                        )
                    ),
                  ),
                )
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal*60,
              height: SizeConfig.blockSizeVertical * 12,
              //color: Colors.blue,
              child: Column(
                children: [
                  Container(
                    width: SizeConfig.blockSizeHorizontal*60,
                    height: SizeConfig.blockSizeVertical * 3,
                    //color: Colors.amber,
                    child: Text(name,style: TextStyle(color:Color(0xFF53d2be),fontWeight: FontWeight.bold,fontFamily: "RobotoRegular",fontSize: SizeConfig.safeBlockVertical*2),),
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal*60,
                    height: SizeConfig.blockSizeVertical * 6,
                    child: Text(shortDescription, style: TextStyle(color:Colors.grey,fontFamily: "RobotoRegular",fontSize: SizeConfig.safeBlockVertical*1.3),),
                    //color: Colors.blueGrey,
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal*60,
                    height: SizeConfig.blockSizeVertical * 3,
                    //color: Colors.brown,
                    child: Text("Coins/. $points",style: TextStyle(color: Color(0xFF53d2be),fontFamily: "RobotoRegular",fontSize: SizeConfig.safeBlockVertical*2),),
                  )
                ],
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal*6,
              height: SizeConfig.blockSizeVertical * 12,
              //color: Colors.yellow,
              child: Center(
                child: Icon(
                  Icons.arrow_right,
                  color: Color(0xFF53d2be),
                  size: SizeConfig.safeBlockVertical*4,
                ),
              ),
            )
          ],
        ),
      )
    );
}
}