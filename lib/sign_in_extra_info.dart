import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/take_user_picture.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'generic_button.dart';
class SignInExtraInfoScreen extends StatefulWidget{
  String userFirstName;
  String userLastName;
  String userEmail;
  String userPassword;
  SignInExtraInfoScreen({Key key,this.userFirstName,this.userLastName,this.userEmail,this.userPassword});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInExtraInfoScreen();
  }

}
class _SignInExtraInfoScreen extends State<SignInExtraInfoScreen> {
  UserBloc userBloc;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  String userPhoneNumber;
  String userPetName;
  String userPetType;
  File  photoPath;
  var firstCamera;
  final formKey= new GlobalKey<FormState>();

  Future<void> getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
     firstCamera= cameras.last;
  }

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  Widget build(BuildContext context) {
    userBloc= BlocProvider.of(context);
    SizeConfig().init(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 20)));
    return WillPopScope(
        onWillPop: () async=>false,
      child: Scaffold(
          body: Container(
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
                              )
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal* 100,
                            height: SizeConfig.safeBlockVertical* 10,
                            //color: Colors.red,
                            margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical * 2,
                              //right: SizeConfig.blockSizeVertical*20,
                              left: SizeConfig.safeBlockHorizontal* 5,
                            ),
                            child: Text("Falta poco...",
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
                              height:SizeConfig.safeBlockHorizontal* 80,
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
                                                  keyboardType: TextInputType.number,
                                                  validator: (value){
                                                    if(value.isEmpty){
                                                      return "Campo inválido";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>userPhoneNumber=input,
                                                  style: TextStyle(
                                                    color: Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Celular",
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
                                                      return "Campo inválido";
                                                    }
                                                  },
                                                  onSaved: (input)=>userPetName=input,
                                                  style: TextStyle(
                                                    color: Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Nombre de tu perro o gato",
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
                                                      return "Campo inválido";
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (input)=>userPetType=input,
                                                  style: TextStyle(
                                                    color: Color(0xFF211551),
                                                  ),
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white12,
                                                      labelText: "Raza",
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
                                  ],
                                ),

                              )
                          ),
                          Container(
                            //color: Colors.red,
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
                                      text: "Registrarme",
                                      radius: 10,
                                      textSize:  SizeConfig.safeBlockHorizontal* 5,
                                      width: SizeConfig.safeBlockHorizontal*21 ,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      color: Colors.white,
                                      textColor: Color(0xFF42E695),
                                      onPressed: (){
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          print('valid');
                                          print("PETNAME: $userPetName");
                                          print("PETTYPE: $userPetType");
                                          print("CELULAR: $userPhoneNumber");
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>TakePictureScreen(userFirstName: widget.userFirstName,
                                              userLastName: widget.userLastName,userEmail: widget.userEmail,userPassword: widget.userPassword
                                              ,userPhoneNumber: userPhoneNumber,userPetName: userPetName,userPetType: userPetType,camera: firstCamera,)));
                                        }
                                      },
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
          )
      )
    );
  }
  bool valida() {
    final formState= formKey.currentState;
    if(formState.validate()){
      formState.save();
      return true;
    }else{
      return false;
    }

  }

}