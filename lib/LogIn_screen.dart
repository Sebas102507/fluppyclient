import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/reset_password_screen.dart';
import 'package:fluppyclient/sign_in_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'blocUser.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
class LogInScreen extends StatefulWidget {
 State<StatefulWidget> createState() => _LogInScreen();
  }
  enum FormType{
  login,
    register
  }
class _LogInScreen extends State<LogInScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  String _email, _password, name;
  FirebaseUser user, currentUser;
  bool exists=false;
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool isLoading=false;
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 28)));
    return _handleCurrenSession();
  }

  Widget _handleCurrenSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot contiene nuestros datos, nuestro objeto user traido de firebase
        if (!snapshot.hasData || snapshot.hasError) { // si el snapshot no tiene datos o un error
          return SignInUI();
        }
        else {
            return HomeScreen();
        }
      },
    );
  }
  Widget SignInUI() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Form(
              child: Container(
                color: Color(0xFF211551),
                child: Form(
                  key: formKey,
                  child: Container(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: SizeConfig.blockSizeVertical*100,
                                decoration: BoxDecoration(
                                  color: Color(0xFF211551),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.none,
                                  alignment: Alignment(8, -0.8),
                                  child: Container(
                                    width: SizeConfig.blockSizeVertical*50,
                                    height: SizeConfig.blockSizeVertical*50,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(100, 90, 130, 0.2),
                                      borderRadius: BorderRadius.circular(screenHeight / 2),
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              width: null,
                              height: bigContainer,
                              //color: Colors.red,
                              margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 5,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      //color: Colors.pink,
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
                                    width: SizeConfig.safeBlockHorizontal* 100,
                                    height: SizeConfig.safeBlockVertical* 10,
                                    //color: Colors.red,
                                    margin: EdgeInsets.only(
                                      bottom: SizeConfig.blockSizeVertical * 6.5,
                                      //right: SizeConfig.blockSizeVertical*20,
                                      left: SizeConfig.safeBlockHorizontal* 5,
                                    ),
                                    child: Text("Iniciar sesión",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.blockSizeVertical * 5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:SizeConfig.safeBlockHorizontal* 60,
                                    margin: EdgeInsets.only(
                                      bottom: SizeConfig.blockSizeVertical*5,
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
                                        top: SizeConfig.blockSizeVertical/1.2,
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
                                            //color: Colors.red,
                                              height: SizeConfig.safeBlockHorizontal* 23,
                                              margin: EdgeInsets.only(
                                                top:SizeConfig.safeBlockHorizontal* 6,
                                              ),
                                              child: Theme(
                                                  data: ThemeData(
                                                    primaryColor:  Color(0xFF211551),
                                                    hintColor:   Color(0xFF211551),
                                                  ),
                                                  child: Container(
                                                      height: SizeConfig.safeBlockHorizontal* 30,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "Correo invalido";
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (input) => _email = input,
                                                        style: TextStyle(
                                                          color: Color(0xFF211551),
                                                        ),
                                                        decoration: InputDecoration(
                                                            errorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            filled: true,
                                                            labelText: "Correo electrónico",
                                                            fillColor: Colors.white12,
                                                            /*prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.white,
                                            ),*/
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
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
                                              margin: EdgeInsets.only(
                                                top:SizeConfig.safeBlockHorizontal* 6,
                                              ),
                                              child: Theme(
                                                  data: ThemeData(
                                                    primaryColor: Color(0xFF211551),
                                                    hintColor:   Color(0xFF211551),
                                                  ),
                                                  child: Container(
                                                      height: SizeConfig.safeBlockHorizontal* 30,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.length < 8) {
                                                            return "Tu contraseña debe tener mínimo 8 caracteres";
                                                          }
                                                        },
                                                        onSaved: (input) => _password = input,
                                                        style: TextStyle(
                                                          color: Color(0xFF211551),
                                                        ),
                                                        decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: Colors.white12,
                                                            labelText: "Contraseña",
                                                            errorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
                                                                    width: 2
                                                                )
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(10)),
                                                                borderSide: BorderSide(
                                                                    color: Color(0xFF211551),
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
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                //color: Colors.indigo,
                                                //height: SizeConfig.blockSizeVertical * 24,
                                                width: null,
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      //color: Colors.orange,
                                                        margin: EdgeInsets.only(
                                                          left: SizeConfig.safeBlockHorizontal * 2.8,
                                                          right: SizeConfig.safeBlockHorizontal * 2.8,
                                                          bottom: SizeConfig.blockSizeVertical * 1,
                                                        ),
                                                        width: double.infinity,
                                                        child: GenericButton(
                                                          text: "Iniciar sesión",
                                                          radius: 10,
                                                          textSize:  SizeConfig.safeBlockHorizontal* 5,
                                                          width: SizeConfig.safeBlockHorizontal * 21,
                                                          height: SizeConfig.safeBlockHorizontal* 15,
                                                          color: Color(0xFF42E695),
                                                          textColor: Colors.white,
                                                          onPressed: validaBaseDatos,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow (
                                                                color:  Colors.green,
                                                                blurRadius: 8.0,
                                                                offset: Offset(0.0, 0.2)
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: SizeConfig.safeBlockHorizontal *
                                                            33.5,
                                                        right: SizeConfig.safeBlockHorizontal * 33.5,
                                                        bottom: SizeConfig.blockSizeVertical ,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                              color: Colors.white,
                                                              width: SizeConfig.safeBlockHorizontal * 13,
                                                              height: SizeConfig.blockSizeVertical / 4
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                bottom: 0
                                                            ),
                                                            child: Center(
                                                              child: Text("O",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: SizeConfig.blockSizeVertical * 1.5,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            height: SizeConfig.blockSizeVertical * 2,
                                                            width: SizeConfig.blockSizeVertical * 2,
                                                          ),
                                                          Container(
                                                            color: Colors.white,
                                                            width: SizeConfig.safeBlockHorizontal * 13,
                                                            height: SizeConfig.blockSizeVertical / 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                          left: SizeConfig.safeBlockHorizontal * 2.8,
                                                          right: SizeConfig.safeBlockHorizontal * 2.8,
                                                          bottom: SizeConfig.blockSizeVertical * 1,
                                                        ),
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          //color: Colors.orange,
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow (
                                                                color:  Colors.white,
                                                                blurRadius: 8.0,
                                                                offset: Offset(0.0, 0.2)
                                                            )
                                                          ],
                                                        ),
                                                        child: GenericButton(
                                                          text: "Registrarme",
                                                          radius: 10,
                                                          textSize:  SizeConfig.safeBlockHorizontal* 5,
                                                          width: SizeConfig.safeBlockHorizontal * 21,
                                                          height: SizeConfig.safeBlockHorizontal* 15,
                                                          color: Colors.white,
                                                          textColor: Color(0xFF42E695),
                                                          onPressed: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                                                          },
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: GestureDetector(
                                                    child: Text("Olvidé mi contraseña", style: TextStyle(decoration: TextDecoration.underline, color: Colors.white,)),
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                                                    }
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  ),
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
      )
    );
  }

  bool iniciarSesion() {
    final formState = formKey.currentState;
    if (formState.validate()) {
      setState(() {
        isLoading=true;
      });
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  void validaRegistra() async {
    print("EMAIL A VALIDAR EL REGISTRO $_email");
    setState(() {
      exists=false;
    });
    if (iniciarSesion()) {
      try {
        //print("DESPUÉS DE VERIFICAR LA DATE BASE, EL CORREO EXISTE EN LOS WALKERS");
        user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email, password: _password)).user;
        setState(() {
          isLoading=false;
        });

      } catch (e) {
        print("Paila socito en la autenticación");
        setState(() {
          isLoading=false;
        });
        Fluttertoast.showToast(
            msg: "Correo o contraseña invalido",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            timeInSecForIos: 2);
      }
    }
  }

  void validaBaseDatos() async{
    if (iniciarSesion()) {
      try {
        //print("CORREO PRUEBA CUANDO CIERRA $_email");
        var userQuery = Firestore.instance.collection('users').where(
            'email', isEqualTo: _email).limit(1);
        userQuery.getDocuments().then((data) {
          if (data.documents.length > 0) {
            setState(() {
              //print("Entrooooooo");
              exists=true;
            });
          }
        }).then((value){
          if(exists==true) {
            validaRegistra();
          }else if(exists==false){
            setState(() {
              isLoading=false;
            });
            Fluttertoast.showToast(
                msg: "Correo o contraseña invalido",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.grey,
                timeInSecForIos: 2);
          }
        });
      } catch (e) {
        print("Paila socito en la base de datos");
      }
    }

  }





}