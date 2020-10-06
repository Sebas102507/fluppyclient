import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/sign_in_extra_info.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'generic_button.dart';
class SignInScreen extends StatefulWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInScreen();
  }

}
class _SignInScreen extends State<SignInScreen> {
  UserBloc userBloc;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  String _email, _password,_repeatPassword, _userFirstName,_userLastName;
  File  photoPath;
  bool isLoading=false;
  final formKey= new GlobalKey<FormState>();
  bool exists=false;
  @override
  Widget build(BuildContext context) {
    userBloc= BlocProvider.of(context);
    SizeConfig().init(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 20)));
    return new Scaffold(
      body: handleScreen()
    );
  }

  Widget handleScreen(){
    if(screenHeight<700){
      return Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF211551),
            child: Form(
              key: formKey ,
              child: SingleChildScrollView(
                child:Stack(
                  children: <Widget>[
                    Container(
                      width: null,
                      height: SizeConfig.blockSizeVertical*95,
                      //color: Colors.red,
                      margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical*5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //color: Colors.red,
                              margin: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeVertical*4,
                              ),
                              width: double.infinity,
                              height: screenHeight/16,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    //color: Colors.deepOrangeAccent,
                                      width: SizeConfig.safeBlockHorizontal*2,
                                      height: SizeConfig.blockSizeVertical*7,
                                      margin: EdgeInsets.only(
                                          right: SizeConfig.safeBlockHorizontal*2
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          Navigator.of(context).pop(MaterialPageRoute(builder: (context)=>BeginScreen()));
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white ,
                                          size: SizeConfig.blockSizeVertical*4,
                                        ),
                                      )
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal* 60,
                                    height: SizeConfig.safeBlockVertical* 7,
                                    //color: Colors.green,
                                    margin: EdgeInsets.only(
                                      //bottom: SizeConfig.blockSizeVertical * 2,
                                      //right: SizeConfig.blockSizeVertical*20,
                                      left: SizeConfig.safeBlockHorizontal* 5,
                                    ),
                                    child: Text("Registrarme",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.blockSizeVertical * 5,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),

                          /////////////////////////////Campos de texto(colocar correo, nombre, contraseña)//////
                          Container(
                              height:SizeConfig.safeBlockHorizontal* 122,
                              margin: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeVertical*3,
                                left: SizeConfig.safeBlockHorizontal* 3,
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow (
                                        color:  Colors.black,
                                        blurRadius: 8.0,
                                        offset: Offset(0.0, 0.2)
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)
                                  )
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left:SizeConfig.safeBlockHorizontal* 3.5,
                                  right: SizeConfig.safeBlockHorizontal*3.5,
                                ),
                                decoration: BoxDecoration(
                                  //color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30)
                                    )
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: SizeConfig.safeBlockHorizontal* 23,
                                        margin: EdgeInsets.only(
                                          top: SizeConfig.blockSizeHorizontal*7,
                                        ),
                                        child: Theme(
                                            data: ThemeData(
                                              primaryColor:   Color(0xFF211551),
                                              hintColor:   Color(0xFF211551),
                                            ),
                                            child: Container(
                                              //color: Colors.green,
                                                height: SizeConfig.blockSizeHorizontal*15,
                                                child: TextFormField(
                                                  validator: (value){
                                                    if(value.isEmpty){
                                                      return "Ingresa unos nombres válidos";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>_userFirstName=input,
                                                  style: TextStyle(
                                                    color: Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Nombres",
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      )
                                                  ),
                                                )
                                            )
                                        )
                                    ),
                                    Container(
                                        height: SizeConfig.safeBlockHorizontal* 23,
                                        child: Theme(
                                            data: ThemeData(
                                              primaryColor:   Color(0xFF211551),
                                              hintColor:   Color(0xFF211551),
                                            ),
                                            child: Container(
                                              //color: Colors.green,
                                                height: SizeConfig.blockSizeHorizontal*15,
                                                child: TextFormField(
                                                  validator: (value){
                                                    if(value.isEmpty){
                                                      return "Ingresa unos apellidos válidos";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>_userLastName=input,
                                                  style: TextStyle(
                                                    color: Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Apellidos",
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      )
                                                  ),
                                                )
                                            )
                                        )
                                    ),
                                    Container(
                                      // color: Colors.lightGreenAccent,
                                        height: SizeConfig.safeBlockHorizontal* 23,
                                        child: Theme(
                                            data: ThemeData(
                                              primaryColor:   Color(0xFF211551),
                                              hintColor:   Color(0xFF211551),
                                            ),
                                            child: Container(
                                                height: SizeConfig.blockSizeHorizontal*15,
                                                child: TextFormField(
                                                  validator: (value){
                                                    if(value.isEmpty){
                                                      return "Correo invalido";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>_email=input,/////////////////////////
                                                  style: TextStyle(
                                                    color:  Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      filled: true,
                                                      labelText: "Correo electrónico",
                                                      fillColor: Colors.white12,
                                                      /*prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),*/
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      )
                                                  ),
                                                  obscureText: false,
                                                )
                                            )
                                        )
                                    ),
                                    Container(
                                        height: SizeConfig.safeBlockHorizontal* 23,
                                        //color: Colors.yellow,
                                        child: Theme(
                                            data: ThemeData(
                                              primaryColor:   Color(0xFF211551),
                                              hintColor:   Color(0xFF211551),
                                            ),
                                            child: Container(

                                                child: TextFormField(
                                                  validator: (value){
                                                    if(value.length<8){
                                                      return "Tu contraseña debe tener mínimo 8 caracteres";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>_password=input,
                                                  style: TextStyle(
                                                    color:  Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Contraseña",
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      )
                                                  ),
                                                  obscureText: true,
                                                )
                                            )
                                        )
                                    ),
                                    Container(
                                        height: SizeConfig.safeBlockHorizontal* 23,
                                        //color: Colors.yellow,
                                        child: Theme(
                                            data: ThemeData(
                                              primaryColor:   Color(0xFF211551),
                                              hintColor:   Color(0xFF211551),
                                            ),
                                            child: Container(

                                                child: TextFormField(
                                                  validator: (value){
                                                    if(value.length<8){
                                                      return "Tu contraseña debe tener mínimo 8 caracteres";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>_repeatPassword=input,
                                                  style: TextStyle(
                                                    color:  Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Contraseña",
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      ) ,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          borderSide: BorderSide(
                                                              color:  Color(0xFF211551),
                                                              width: 2
                                                          )
                                                      )
                                                  ),
                                                  obscureText: true,
                                                )
                                            )
                                        )
                                    ),
                                  ],
                                ),

                              )
                          ),
                          Container(
                            //color: Colors.amber,
                            height: SizeConfig.blockSizeVertical*11,
                            margin: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 2.8,
                              right: SizeConfig.safeBlockHorizontal * 2.8,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                      left: SizeConfig.safeBlockHorizontal*2.8,
                                      right: SizeConfig.safeBlockHorizontal*2.8,
                                      bottom: SizeConfig.blockSizeVertical*1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      //color:  Colors.orange,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow (
                                            color:  Colors.white,
                                            blurRadius: 8.0,
                                            offset: Offset(0.0, 0.2)
                                        )
                                      ],
                                    ),
                                    width: double.infinity,
                                    height:SizeConfig.safeBlockHorizontal*15,
                                    child: GenericButton(
                                      text: "Continuar",
                                      radius: 10,
                                      textSize:  SizeConfig.safeBlockHorizontal* 5,
                                      width: SizeConfig.safeBlockHorizontal*21 ,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      color: Colors.white,
                                      textColor: Color(0xFF42E695),
                                        onPressed: (){
                                          validaBaseDatos();
                                          //validaRegistro();
                                        }
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42E695)),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
        ],
      );

    }else {
    return  Stack(
      children: <Widget>[
        Container(
          color: Color(0xFF211551),
          child: Form(
            key: formKey ,
            child: SingleChildScrollView(
              child:Stack(
                children: <Widget>[
                  Container(
                    width: null,
                    height: SizeConfig.blockSizeVertical*95,
                    //color: Colors.red,
                    margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical*5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          //color: Colors.red,
                            margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical,
                            ),
                            width: double.infinity,
                            height: screenHeight/16,
                            child: Container(
                              //color: Colors.deepOrangeAccent,
                                width: SizeConfig.safeBlockHorizontal*2,
                                height: SizeConfig.blockSizeVertical*7,
                                margin: EdgeInsets.only(
                                    right: SizeConfig.safeBlockHorizontal*90
                                ),
                                child: InkWell(
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    Navigator.of(context).pop(MaterialPageRoute(builder: (context)=>BeginScreen()));
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white ,
                                    size: SizeConfig.blockSizeVertical*4,
                                  ),
                                )
                            )
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal* 100,
                          height: SizeConfig.safeBlockVertical* 10,
                          //color: Colors.green,
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 2,
                            //right: SizeConfig.blockSizeVertical*20,
                            left: SizeConfig.safeBlockHorizontal* 5,
                          ),
                          child: Text("Registrarme",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical * 5,
                            ),
                          ),
                        ),
                        /////////////////////////////Campos de texto(colocar correo, nombre, contraseña)//////
                        Container(
                            height:SizeConfig.safeBlockHorizontal* 122,
                            margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical*3,
                              left: SizeConfig.safeBlockHorizontal* 3,
                            ),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow (
                                      color:  Colors.black,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 0.2)
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)
                                )
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                left:SizeConfig.safeBlockHorizontal* 3.5,
                                right: SizeConfig.safeBlockHorizontal*3.5,
                              ),
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: SizeConfig.safeBlockHorizontal* 23,
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.blockSizeHorizontal*7,
                                      ),
                                      child: Theme(
                                          data: ThemeData(
                                            primaryColor:   Color(0xFF211551),
                                            hintColor:   Color(0xFF211551),
                                          ),
                                          child: Container(
                                            //color: Colors.green,
                                              height: SizeConfig.blockSizeHorizontal*15,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.isEmpty){
                                                    return "Ingresa unos nombres válidos";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (input)=>_userFirstName=input,
                                                style: TextStyle(
                                                  color: Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    labelText: "Nombres",
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    )
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      height: SizeConfig.safeBlockHorizontal* 23,
                                      child: Theme(
                                          data: ThemeData(
                                            primaryColor:   Color(0xFF211551),
                                            hintColor:   Color(0xFF211551),
                                          ),
                                          child: Container(
                                            //color: Colors.green,
                                              height: SizeConfig.blockSizeHorizontal*15,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.isEmpty){
                                                    return "Ingresa unos apellidos válidos";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (input)=>_userLastName=input,
                                                style: TextStyle(
                                                  color: Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    labelText: "Apellidos",
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    )
                                                ),
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                    // color: Colors.lightGreenAccent,
                                      height: SizeConfig.safeBlockHorizontal* 23,
                                      child: Theme(
                                          data: ThemeData(
                                            primaryColor:   Color(0xFF211551),
                                            hintColor:   Color(0xFF211551),
                                          ),
                                          child: Container(
                                              height: SizeConfig.blockSizeHorizontal*15,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.isEmpty){
                                                    return "Correo invalido";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (input)=>_email=input,
                                                style: TextStyle(
                                                  color:  Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    filled: true,
                                                    labelText: "Correo electrónico",
                                                    fillColor: Colors.white12,
                                                    /*prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),*/
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    )
                                                ),
                                                obscureText: false,
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      height: SizeConfig.safeBlockHorizontal* 23,
                                      //color: Colors.yellow,
                                      child: Theme(
                                          data: ThemeData(
                                            primaryColor:   Color(0xFF211551),
                                            hintColor:   Color(0xFF211551),
                                          ),
                                          child: Container(

                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.length<8){
                                                    return "Tu contraseña debe tener mínimo 8 caracteres";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (input)=>_password=input,
                                                style: TextStyle(
                                                  color:  Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    labelText: "Contraseña",
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    )
                                                ),
                                                obscureText: true,
                                              )
                                          )
                                      )
                                  ),
                                  Container(
                                      height: SizeConfig.safeBlockHorizontal* 23,
                                      //color: Colors.yellow,
                                      child: Theme(
                                          data: ThemeData(
                                            primaryColor:   Color(0xFF211551),
                                            hintColor:   Color(0xFF211551),
                                          ),
                                          child: Container(

                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.length<8){
                                                    return "Tu contraseña debe tener mínimo 8 caracteres";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (input)=>_repeatPassword=input,
                                                style: TextStyle(
                                                  color:  Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    labelText: "Confirmar contraseña",
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    ) ,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        borderSide: BorderSide(
                                                            color:  Color(0xFF211551),
                                                            width: 2
                                                        )
                                                    )
                                                ),
                                                obscureText: true,
                                              )
                                          )
                                      )
                                  ),
                                ],
                              ),

                            )
                        ),
                        Container(
                          //color: Colors.amber,
                          height: SizeConfig.blockSizeVertical*11,
                          margin: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 2.8,
                            right: SizeConfig.safeBlockHorizontal * 2.8,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                    left: SizeConfig.safeBlockHorizontal*2.8,
                                    right: SizeConfig.safeBlockHorizontal*2.8,
                                    bottom: SizeConfig.blockSizeVertical*1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    //color:  Colors.orange,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],
                                  ),
                                  width: double.infinity,
                                  height:SizeConfig.safeBlockHorizontal*15,
                                  child: GenericButton(
                                    text: "Continuar",
                                    radius: 10,
                                    textSize:  SizeConfig.safeBlockHorizontal* 5,
                                    width: SizeConfig.safeBlockHorizontal*21 ,
                                    height: SizeConfig.safeBlockHorizontal* 15,
                                    color: Colors.white,
                                    textColor: Color(0xFF42E695),
                                    onPressed: (){
                                      validaBaseDatos();
                                     //validaRegistro();
                                    }
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42E695)),
              ),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    );
    }
  }

  bool valida() {
    final formState= formKey.currentState;
    if(formState.validate()){
      formState.save();
      setState(() {
        isLoading=true;
      });
      return true;
    }else{
      return false;
    }

  }

  bool validaPassword(){
    if(valida()){
      print("FIRST PASSWORD: $_password");
      print("SECOND PASSWORD: $_repeatPassword");
      if(_password==_repeatPassword){
        print("SON IGUALES");
        return true;
      }else {
        setState(() {
          isLoading=false;
        });
        print("SON DIFERENTES");
        return false;
      }
    }else {
      return false;
    }
  }


  void validaBaseDatos() async{
    if (validaPassword()) {
      try {
        print("EL CORREO ES : $_email");
        var userQuery = Firestore.instance.collection('users').where(
            'email', isEqualTo: _email).limit(1);
        userQuery.getDocuments().then((data) {
          if (data.documents.length > 0) {
            setState(() {
              //print("Entrooooooo");
              exists=true;
            });
          }else{
            setState(() {
              exists=false;
            });
          }
        }).then((value){
          if(exists==true) {
            print("EL CORREO YA EXISTE");
            Fluttertoast.showToast(
                msg: "El correo ya está en uso",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.grey,
                timeInSecForIos: 2);
            setState(() {
              isLoading=false;
            });
          }else if(exists==false){
            print("EL CORREO NOOO EXISTE");
            Navigator.push(context,MaterialPageRoute(builder: (context)=>SignInExtraInfoScreen(userFirstName: _userFirstName,userLastName: _userLastName,userEmail: _email,userPassword: _password,)));
            setState(() {
              isLoading=false;
            });
          }
        });
      } catch (e) {
        print("Paila socito");
      }
    }else{
      setState(() {
        isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Las contraseñas no coinciden",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
    }
  }



  void alertDialog(BuildContext context){
    print("Contexto: ${context.toString()}");
    var alert= AlertDialog(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      content: Container(
        //color: Colors.red,
        height: SizeConfig.safeBlockVertical*20,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*9,
                  child: Center(
                    child: Text("UPSS, parece que el correo que digitaste ya está en uso",
                      style: TextStyle(
                          color:  Color(0xFF211551),
                          fontSize: SizeConfig.safeBlockVertical*2,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  //color: Colors.yellow,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*11,
                  child: Center(
                    child: Container(
                      height:  SizeConfig.safeBlockVertical*12,
                      child: Icon(
                        CustomIcons.cross_circle,
                        color: Colors.red,
                        size: SizeConfig.blockSizeVertical*3,
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context)=>alert
    );
  }
}
