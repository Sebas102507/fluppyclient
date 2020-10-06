import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/Gmail_button.dart';
import 'package:fluppyclient/LogIn_screen.dart';
import 'package:fluppyclient/app_info_screen.dart';
import 'package:fluppyclient/begin_store_screen.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/credit_card_test.dart';
import 'package:fluppyclient/extra_info_gmail.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'dart:io' show Platform;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class BeginScreen extends StatefulWidget {
  @override
  _BeginScreenState createState() => _BeginScreenState();
}

class _BeginScreenState extends State<BeginScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  Widget returnedWidget;
  final formKey = new GlobalKey<FormState>();
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Widget build(BuildContext context) {
   userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    bigContainer=(screenHeight-(2*(screenHeight/20)));
    //return BeginUI();
    return _handleCurrenSession();
  }


  Future<bool> validaBasesDatos(String id) async{
    bool exists=false;
    final snapShot = await Firestore.instance .collection('users') .document(id).get();
    if (snapShot == null || !snapShot.exists) {
      return exists;
    }else{
      setState(() {
        exists=true;
      });
      return exists;
    }
  }
  Widget _handleCurrenSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot contiene nuestros datos, nuestro objeto user traido de firebase
        if (!snapshot.hasData ||
            snapshot.hasError) { // si el snapshot no tiene datos o un error
          return BeginUI();
        }
        else {
         // print("EL ID DEL USUARIO ES: ${snapshot.data.uid}");
          //print("EL EMAIL DEL USUARIO ES: ${snapshot.data.email}");
          //print("EL NOMBRE DEL USUARIO ES: ${snapshot.data.displayName}");
          //print("LA FOTO DEL USUARIO ES: ${snapshot.data.photoUrl}");

          validaBasesDatos(snapshot.data.uid).then((value){
            if(value==true){
              //print("ENTRE EN EL VERDADERO");
              setState(() {
                returnedWidget= HomeScreen();//TestCreditCard();
              });
            }else {

              setState(() {
                //print("ENTRE EN EL EXTRA EMAIL");
                returnedWidget= ExtraInfoGmail(email: snapshot.data.email,id: snapshot.data.uid,photoUrl: snapshot.data.photoUrl,name: snapshot.data.displayName);
              });

              //print("ENTRE EN EL FALSO");
              /*if( snapshot.data.email==null || snapshot.data.uid==null || snapshot.data.photoUrl==null || snapshot.data.displayName==null){
                setState(() {
                  returnedWidget= HomeScreen();//TestCreditCard();
                  print("ENTRE EN EL HOME ");
                })
              }else{

              }*/
            }
          });
          if(returnedWidget!=null){
            return returnedWidget;
          }else {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget BeginUI(){
    return WillPopScope(
      onWillPop: () async=>false,
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: SizeConfig.blockSizeVertical*100,
                  decoration: BoxDecoration(
                    color: Color(0xFF211551),
                  ),
                  child: FittedBox(
                    fit: BoxFit.none,
                    alignment: Alignment(SizeConfig.blockSizeHorizontal*-1, -0.8),
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
              Center(
                child: Container(
                  width: SizeConfig.blockSizeVertical*80,
                  height: SizeConfig.blockSizeVertical*98,
                 //color: Colors.pinkAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              top:  SizeConfig.blockSizeVertical*6
                          ),
                          width: SizeConfig.blockSizeVertical*20,
                          height: SizeConfig.blockSizeVertical*20,
                          //color: Colors.yellow,
                          child:  Container(
                            width: SizeConfig.blockSizeVertical*10,
                            height: SizeConfig.blockSizeVertical*10,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/fluppyLogoNom.png"),
                                  //image: NetworkImage(widget.profileImage)// traer una foto desde una URL
                                )
                            ),
                          )
                      ),

                      Container(
                        width: double.infinity,
                        height: SizeConfig.blockSizeVertical*72,
                        //color: Colors.green,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: SizeConfig.blockSizeHorizontal*70,
                              height: SizeConfig.blockSizeVertical*8,
                              //color: Colors.purple,
                              child: Text("La aplicación que se encarga de tu mejor amigo.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(255,255, 255, 0.9),
                                  fontSize: SizeConfig.blockSizeHorizontal*4,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical*2,
                              ),
                              width: double.infinity,
                              height: SizeConfig.blockSizeVertical*32,
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                image: DecorationImage(
                                  image: AssetImage("assets/fondoInicio2.png")
                                )
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height:  SizeConfig.blockSizeHorizontal*58,
                             // color: Colors.orange,
                              margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical*0.5,
                              ),
                              child: Column(
                                children: <Widget>[

                                 /* Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal*4,
                                          right: SizeConfig.blockSizeHorizontal*4,
                                          bottom:  SizeConfig.safeBlockVertical*2
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow (
                                              color:  Colors.green,
                                              blurRadius: 8.0,
                                              offset: Offset(0.0, 0.2)
                                          )
                                        ],
                                      ),
                                      child: GenericButton(
                                        text: "Fluppy shop",
                                        radius: 10,
                                        textSize: SizeConfig.safeBlockHorizontal* 5,
                                        width: SizeConfig.safeBlockHorizontal*4,
                                        height: SizeConfig.safeBlockHorizontal* 15,
                                        color:  Color(0xFF53d2be),
                                        textColor: Colors.white,
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context)=>BeginStoreScreen()));
                                        },
                                      )
                                  ),*/
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal*4,
                                          right: SizeConfig.blockSizeHorizontal*4,
                                          bottom:  SizeConfig.safeBlockVertical*2
                                      ),
                                      width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow (
                                      color:  Colors.green,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 0.2)
                                  )
                                ],
                              ),
                                      child: GenericButton(
                                        text: "Continuar con correo",
                                        radius: 10,
                                        textSize: SizeConfig.safeBlockHorizontal* 5,
                                        width: SizeConfig.safeBlockHorizontal*4,
                                        height: SizeConfig.safeBlockHorizontal* 15,
                                        color:  Color(0xFF42E695) ,
                                        textColor: Colors.white,
                                        onPressed: (){
                                         Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context)=>LogInScreen()));
                                        },
                                      )
                                  ),

                                  Container(
                                      margin: EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal*4,
                                        right: SizeConfig.blockSizeHorizontal*4,
                                          bottom:  SizeConfig.safeBlockVertical*2
                                      ),
                                      width: SizeConfig.safeBlockHorizontal*95,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow (
                                              color:  Colors.red,
                                              blurRadius: 8.0,
                                              offset: Offset(0.0, 0.2)
                                          )
                                        ],
                                      ),
                                      child: GmailButton(
                                          onPresed: () {
                                            userBloc.signIn().then((FirebaseUser user){
                                              print("El usuario es ${user.displayName}");
                                            });
                                          }
                                      )
                                  ),

                                  (Platform.isIOS)?

                                  Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal*4,
                                          right: SizeConfig.blockSizeHorizontal*4,
                                          bottom:  SizeConfig.safeBlockVertical*2
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow (
                                              color:  Colors.white,
                                              blurRadius: 8.0,
                                              offset: Offset(0.0, 0.2)
                                          )
                                        ],
                                      ),
                                      child: AppleSignInButton(
                                        onPressed: (){
                                          print("Ingresar con Apple");
                                          this.signWithApple();
                                        },
                                      )
                                  ):
                                      Container()

                                ],
                              ),
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )

            ],
          )
      )//color: Colors.white
    );
  }

  signWithApple()async{
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final credential = oAuthProvider.getCredential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    print(credential);
  }




}