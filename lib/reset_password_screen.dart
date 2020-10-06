import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  String _email;
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 28)));
    return Scaffold(
        body: Form(
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
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          Navigator.of(context).pop();
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
                                height: SizeConfig.safeBlockVertical* 15,
                                //color: Colors.red,
                                margin: EdgeInsets.only(
                                  bottom: SizeConfig.blockSizeVertical * 4,
                                  //right: SizeConfig.blockSizeVertical*20,
                                  left: SizeConfig.safeBlockHorizontal* 5,
                                ),
                                child: Text("Recuperar Contraseña",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.blockSizeVertical * 5,
                                  ),
                                ),
                              ),
                              Container(
                                height:SizeConfig.safeBlockHorizontal* 35,
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
                                            height: SizeConfig.blockSizeVertical * 24,
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
                                                    decoration: BoxDecoration(
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow (
                                                            color:  Colors.white,
                                                            blurRadius: 8.0,
                                                            offset: Offset(0.0, 0.2)
                                                        )
                                                      ],
                                                    ),
                                                    child: GenericButton(
                                                      text: "Recuperar",
                                                      radius: 10,
                                                      textSize:  SizeConfig.safeBlockHorizontal* 5,
                                                      width: SizeConfig.safeBlockHorizontal * 21,
                                                      height: SizeConfig.safeBlockHorizontal* 15,
                                                      color: Colors.white,
                                                      textColor: Color(0xFF42E695),
                                                      onPressed: (){
                                                        if (formKey.currentState.validate()) {
                                                          formKey.currentState.save();
                                                          print("EL EMAIL ES: $_email");
                                                          resetPassword(_email).then((value){
                                                            alertDialog(context);
                                                          });
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
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
          ),
        )
    );
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
                    child: Text("Te enviamos un email, para recuperar tu contraseña",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.safeBlockVertical*2.2,
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
                        CustomIcons.checkmark_cicle,
                        color: Colors.green,
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
