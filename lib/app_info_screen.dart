import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/reset_password_screen.dart';
import 'package:fluppyclient/sign_in_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'blocUser.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
class AppInfoScreen extends StatefulWidget {

  State<StatefulWidget> createState() => _AppInfoScreen();
}

class _AppInfoScreen extends State<AppInfoScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  String _email, _password, name;
  FirebaseUser user, currentUser;
  bool exists=false;
  final formKey = new GlobalKey<FormState>();
  bool isLoading=false;
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 28)));
    return Scaffold(
      body: Container(
        width: SizeConfig.safeBlockHorizontal*100,
        height: SizeConfig.safeBlockVertical*100,
        color: Color(0xFF211551),
        child: Container(
          width: SizeConfig.safeBlockHorizontal*100,
          height: SizeConfig.safeBlockVertical*100,
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.pink,
                  margin: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical*4,
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
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => BeginScreen()));
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: SizeConfig.blockSizeVertical * 4,
                        ),
                      )
                  )
              ),
              Container(
                width: SizeConfig.safeBlockHorizontal*100,
                height: SizeConfig.safeBlockVertical*20,
                decoration: BoxDecoration(
                    //color: Colors.green,
                  image: DecorationImage(
                    image: AssetImage("assets/fluppyLogoNom.png"),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Container(
                width: SizeConfig.safeBlockHorizontal*100,
                height: SizeConfig.safeBlockVertical*8,
                //color: Colors.blue,
                child: Center(
                  child: Text("¡Hola, somos Fluppy!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockVertical*3,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                )
              ),
              Container(
                width: SizeConfig.safeBlockHorizontal*100,
                height: SizeConfig.safeBlockVertical*30,
                //color: Colors.yellow,
                child: Text("Somos una app móvil que te ofrece todo lo que necesitas para tu mascota, desde alimentos hasta servicios de paseo. Pide por nuestra tienda y recibe el mismo día, además estaremos regalando ciertos días cupones con los cuales podrás tener paseos y domicilios gratis. ¡Debes estar atento!Si necesitas ayuda o tienes alguna duda nos puedas escribir a través de nuestro soporte en la app y/o nuestro correo electrónico fluppypetsofficial@gmail.com.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockVertical*2,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal*2,
                  right: SizeConfig.safeBlockHorizontal*2
                ),
                width: SizeConfig.safeBlockHorizontal*100,
                height: SizeConfig.safeBlockVertical*20,
                //color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.safeBlockHorizontal*32,
                      height: SizeConfig.safeBlockVertical*18,
                      //color: Colors.deepOrange,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*32,
                            height: SizeConfig.safeBlockVertical*12,
                            //color: Colors.cyan,
                            child: Center(
                              child: Icon(
                                Icons.tap_and_play,
                                size: SizeConfig.safeBlockVertical*8,
                                color: Colors.white,
                              )
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal*32,
                            height: SizeConfig.safeBlockVertical*6,
                           // color: Colors.deepPurpleAccent,
                            child: Center(
                              child: Text("Ubicación en tiempo real",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.safeBlockVertical*2,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.safeBlockHorizontal*32,
                      height: SizeConfig.safeBlockVertical*18,
                      //color: Colors.blue,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*32,
                            height: SizeConfig.safeBlockVertical*12,
                            //color: Colors.cyan,
                            child: Center(
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: SizeConfig.safeBlockVertical*8,
                                  color: Colors.white,
                                )
                            ),
                          ),
                          Container(
                              width: SizeConfig.safeBlockHorizontal*32,
                              height: SizeConfig.safeBlockVertical*6,
                              //color: Colors.deepPurpleAccent,
                              child: Center(
                                child: Text("Tienda para tu mascota",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockVertical*2,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          )
                        ],
                      ),

                    ),
                    Container(
                      width: SizeConfig.safeBlockHorizontal*32,
                      height: SizeConfig.safeBlockVertical*18,
                      //color: Colors.orange,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*32,
                            height: SizeConfig.safeBlockVertical*12,
                           // color: Colors.cyan,
                            child: Center(
                                child: Icon(
                                  Icons.pets,
                                  size: SizeConfig.safeBlockVertical*8,
                                  color: Colors.white,
                                )
                            ),
                          ),
                          Container(
                              width: SizeConfig.safeBlockHorizontal*32,
                              height: SizeConfig.safeBlockVertical*6,
                              //color: Colors.deepPurpleAccent,
                              child: Center(
                                child: Text("Consentimos tu mascota",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockVertical*2,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        )
      ),
    );
  }


}