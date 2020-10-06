import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class PetInfoGmailScreen extends StatefulWidget {
  String email;
  String id;
  String photoUrl;
  String firstName;
  String lastName;
  String phoneNumber;
  PetInfoGmailScreen({Key key, this.email, this.id, this.photoUrl, this.firstName,this.lastName,this.phoneNumber});
  @override
  _PetInfoGmailScreenState createState() => _PetInfoGmailScreenState();
}

class _PetInfoGmailScreenState extends State<PetInfoGmailScreen> {
  UserBloc userBloc;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  String userPetType, userPetName;
  final formKey= new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return Scaffold(
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
                      top: SizeConfig.blockSizeVertical*10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockHorizontal* 100,
                          //color: Colors.greenAccent,
                          margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 4,
                            //right: SizeConfig.blockSizeVertical*20,
                            left: SizeConfig.safeBlockHorizontal* 5,
                          ),
                          child: Text("Sobre tu mascota",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical * 4,
                            ),
                          ),
                        ),
                        /////////////////////////////Campos de texto(colocar correo, nombre, contraseña)//////
                        Container(
                            height:SizeConfig.safeBlockHorizontal* 60,
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
                                            primaryColor:  Color(0xFF211551),
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
                                                },
                                                onSaved: (input)=>userPetName=input,
                                                style: TextStyle(
                                                  color: Color(0xFF211551),
                                                ),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    labelText: "Nombre",
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
                                      ),
                                  ),
                                ],
                              ),
                            )
                        ),
                        Container(
                          //color: Colors.red,
                          height: SizeConfig.blockSizeVertical*10,
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
                                    text: "¡Listo!",
                                    radius: 10,
                                    textSize:  SizeConfig.safeBlockHorizontal* 5,
                                    width: SizeConfig.safeBlockHorizontal*21 ,
                                    height: SizeConfig.safeBlockHorizontal* 15,
                                    color: Colors.white,
                                    textColor: Color(0xFF42E695),
                                    onPressed: (){
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        userBloc.updateUserData(new User(email: widget.email, id:widget.id,photoURl: widget.photoUrl,
                                        firstName: widget.firstName,lastName: widget.lastName,phone: widget.phoneNumber,
                                        serviceAccepted: false,walkerId: null,trips: 0,userPetName: userPetName,userPetType: userPetType));
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
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

    );
  }
}
