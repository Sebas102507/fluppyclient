import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/trip_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'blocUser.dart';


class CheckRequestScreen extends StatefulWidget {

  ServiceRequest serviceRequest;
  User userInfo;
  CheckRequestScreen({Key key, this.serviceRequest,this.userInfo});

  @override
  _CheckRequestScreenState createState() => _CheckRequestScreenState();
}

class _CheckRequestScreenState extends State<CheckRequestScreen> {
  String extraInfo,changeAddress,address;
  bool requestAccepted=false;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  bool validate=true;
  Icon editIcon=Icon(Icons.edit,color: Color(0xFF211551),size: SizeConfig.blockSizeVertical * 4);
  final formKey = new GlobalKey<FormState>();
  double secondContainerHeight=0;
  bool addressCheck=false;

  @override
  void initState() {
    super.initState();
    print("ESTOY YA EN CHECK Y VALOR DEL ADDRESS ES DE : ${widget.serviceRequest.userAddress}");
    this.address=widget.serviceRequest.userAddress;
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate())
    {
      //print ('Form is valid');
      return true;
    }
    else
    {
      //print('form is invalid');
      return false;
    }
  }

  Widget addressLayout(bool modifyLayout){
    if(!modifyLayout){
      return Container(
          margin: EdgeInsets.only(
            top: SizeConfig.safeBlockHorizontal * 2,
          ),
          width: SizeConfig.safeBlockHorizontal * 65,
          height: SizeConfig.safeBlockHorizontal * 30,
          //color: Colors.greenAccent,
          child: Column(
            children: <Widget>[
              Container(
                  width: SizeConfig.safeBlockHorizontal * 70,
                  height: SizeConfig.safeBlockHorizontal * 4.5,
                  //color: Colors.blue,
                  child: Text(
                    "Dirección",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromRGBO(13, 8, 32, 0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RobotoRegular"
                    ),
                  )
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.only(
                      right: SizeConfig.safeBlockHorizontal * 15,
                    ),
                    width: SizeConfig.safeBlockHorizontal * 60,
                    height: SizeConfig.safeBlockHorizontal * 11,
                    //color: Colors.green,
                    child: Text(
                      address,
                      //"fdslfjlkasdvklanslkdnvlkasnfklvnas",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFF211551),
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                      ),
                    )
                ),
              )
            ],
          )
      );
    }else{
      return  Container(
          margin: EdgeInsets.only(
            top: SizeConfig.safeBlockHorizontal * 2,
          ),
          width: SizeConfig.safeBlockHorizontal * 65,
          height: SizeConfig.safeBlockHorizontal * 30,
          //color: Colors.red,
          child: Column(
            children: <Widget>[
              Container(
                  width: SizeConfig.safeBlockHorizontal * 70,
                  height: SizeConfig.safeBlockHorizontal * 4.5,
                  //color: Colors.blue,
                  child: Text(
                    "Dirección",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromRGBO(13, 8, 32, 0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RobotoRegular"
                    ),
                  )
              ),
              Center(
                child: Container(
                    margin: EdgeInsets.only(
                      right: SizeConfig.safeBlockHorizontal * 2,
                    ),
                    width: SizeConfig.safeBlockHorizontal * 65,
                    height: SizeConfig.safeBlockHorizontal * 10,
                    //color: Colors.green,
                    child: TextFormField(
                      cursorColor: Color(0xFF211551),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF211551))),
                        fillColor: Color(0xFF211551),
                      ),
                      initialValue:  widget.serviceRequest.userAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          print("vacío");
                          return "Debes llenar este campo";
                        }else{
                          setState(() {
                            print("VALOR QUE SE SUPONE SE GUARDA $value");
                            changeAddress=value;
                          });
                        }
                      },

                    )
                ),
              )
            ],
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    bigContainer = (screenHeight - (2 * (screenHeight / 28)));
    this.screenHeight>650 ? secondContainerHeight= SizeConfig.safeBlockVertical*30 :secondContainerHeight= SizeConfig.safeBlockVertical*43;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
              color: Colors.grey[200],
              child: Container(
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
                                    color: Color(0xFF211551),
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                )
                            )
                        ),
                        firstContainer(),
                        secondContainer()
                      ]
                  )
              )
          ),
        )
      )
    );
  }

  Widget firstContainer(){
    if((screenHeight<650)){
      return chooseFirstContainer(SizeConfig.safeBlockVertical*21,SizeConfig.safeBlockVertical*1);
    }else if((screenHeight>650 && screenHeight<700)){
      return chooseFirstContainer(SizeConfig.safeBlockVertical*20,SizeConfig.safeBlockVertical*5);
    }else if(screenHeight<812){
      return  chooseFirstContainer(SizeConfig.safeBlockVertical*26,SizeConfig.safeBlockVertical*5);
    }else {
      return  chooseFirstContainer(SizeConfig.safeBlockVertical*26,SizeConfig.safeBlockVertical*5);
    }
  }

  Widget secondContainer(){


    if((screenHeight<650)){
      return chooseSecondContainer(SizeConfig.safeBlockVertical*60,SizeConfig.safeBlockVertical);
    }else if((screenHeight>650 && screenHeight<700)){
      return chooseSecondContainer(SizeConfig.safeBlockVertical*62,SizeConfig.safeBlockVertical);
    }else if(screenHeight<812){
      return  chooseSecondContainer(SizeConfig.safeBlockVertical*58,SizeConfig.safeBlockVertical*3);
    }else {
      return  chooseSecondContainer(SizeConfig.safeBlockVertical*58,SizeConfig.safeBlockVertical*2);
    }
  }

  Widget chooseFirstContainer(double height, double margin){
    //SizeConfig.safeBlockVertical*5 margin
    //SizeConfig.safeBlockVertical*35, height
    return Container(
      //color: Colors.purple,
      width: double.infinity,
      height: height,
      child: Container(
          width: SizeConfig.safeBlockVertical*20,
          height: SizeConfig.safeBlockVertical*26,
          margin: EdgeInsets.only(
            top: margin,
            right: SizeConfig.safeBlockHorizontal *20,
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/requestDogDecoration.png")
              )
          )
      ),
    );
  }
  Widget chooseSecondContainer(double height, double margin){
    //SizeConfig.safeBlockVertical*5 margin
    //SizeConfig.safeBlockVertical*35, height
    return  Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  Colors.black38,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.2)
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      width: null,
      height: height ,
      child: Container(
        //color: Colors.redAccent,
        margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical*4,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.safeBlockHorizontal *20,
              margin: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 2,
                right: SizeConfig.safeBlockHorizontal * 2,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF211551),
                    width: SizeConfig.safeBlockHorizontal * 1,
                  ),
                 // color: Colors.pinkAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockHorizontal * 30,
                    //color: Colors.amber,
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF211551),
                      size: SizeConfig.safeBlockHorizontal * 10,
                    ),
                  ),
                  Container(
                    child: addressLayout(addressCheck),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.safeBlockHorizontal * 2,
                    ),
                    width: SizeConfig.safeBlockHorizontal * 13,
                    height: SizeConfig.safeBlockHorizontal * 30,
                    //color: Colors.brown,
                    child: InkWell(
                      onTap: () {
                        print("CAMBIAR DIRECCION");
                        setState(() {
                          if(!addressCheck){
                            addressCheck=true;
                            editIcon=Icon(Icons.check,color: Color(0xFF211551),size: SizeConfig.blockSizeVertical * 4);
                          }else{
                            addressCheck=false;
                            editIcon=Icon(Icons.edit,color: Color(0xFF211551),size: SizeConfig.blockSizeVertical * 4);
                            this.validateAndSave();
                            if(changeAddress!=null){
                              print("EXTRA INFO: $changeAddress");
                              address=changeAddress;
                            }
                          }
                        });
                      },
                      child: editIcon
                    )
                  )
                ],
              ),
            ),
            Divider(
              color: Color(0xFF211551),
              height: SizeConfig.safeBlockHorizontal *5,
            ),
            Container(
              height: SizeConfig.safeBlockHorizontal *27,
              margin: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 2,
                right: SizeConfig.safeBlockHorizontal * 2,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF211551),
                    width: SizeConfig.safeBlockHorizontal * 1,
                  ),
                  //color: Colors.pinkAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockHorizontal * 30,
                    //color: Colors.amber,
                    child: Icon(
                      Icons.home,
                      color: Color(0xFF211551),
                      size: SizeConfig.safeBlockHorizontal * 10,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockHorizontal * 2,
                      ),
                      width: SizeConfig.safeBlockHorizontal * 70,
                      height: SizeConfig.safeBlockHorizontal * 30,
                      //color: Colors.brown,
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: SizeConfig.safeBlockHorizontal * 70,
                              height: SizeConfig.safeBlockHorizontal * 4.5,
                              //color: Colors.blue,
                              child: Text(
                                "Residencia",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromRGBO(13, 8, 32, 0.6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoRegular"
                                ),
                              )
                          ),
                          Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                  right: SizeConfig.safeBlockHorizontal * 15,
                                ),
                                width: SizeConfig.safeBlockHorizontal * 60,
                                height: SizeConfig.safeBlockHorizontal * 18,
                                //color: Colors.green,
                                child: TextFormField(
                                  cursorColor: Color(0xFF211551),
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF211551))),
                                    fillColor: Color(0xFF211551),
                                    hintText: "Ej. Prado 1, torre 4,apt 1207",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      print("vacío");
                                      return "Debes llenar este campo";
                                    }else{
                                      setState(() {
                                        print("VALOR QUE SE SUPONE SE GUARDA $value");
                                        extraInfo=value;
                                      });
                                    }
                                  },

                                )
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xFF211551),
              height: SizeConfig.safeBlockHorizontal *5,
            ),
            Container(
              height: SizeConfig.safeBlockHorizontal *20,
              margin: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 2,
                right: SizeConfig.safeBlockHorizontal * 2,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF211551),
                    width: SizeConfig.safeBlockHorizontal * 1,
                  ),
                  //color: Colors.pinkAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 15,
                    height: SizeConfig.safeBlockHorizontal * 30,
                    //color: Colors.amber,
                    child: Icon(
                      Icons.monetization_on,
                      color: Color(0xFF211551),
                      size: SizeConfig.safeBlockHorizontal * 10,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockHorizontal * 2,
                      ),
                      width: SizeConfig.safeBlockHorizontal * 70,
                      height: SizeConfig.safeBlockHorizontal * 30,
                      //color: Colors.brown,
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: SizeConfig.safeBlockHorizontal * 70,
                              height: SizeConfig.safeBlockHorizontal * 5,
                              //color: Colors.blue,
                              child: Text(
                                "Medio de pago",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromRGBO(13, 8, 32, 0.6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoRegular"
                                ),
                              )
                          ),
                          Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                  right: SizeConfig.safeBlockHorizontal * 15,
                                ),
                                width: SizeConfig.safeBlockHorizontal * 60,
                                height: SizeConfig.safeBlockHorizontal * 11,
                                //color: Colors.green,
                                child: Text(
                                  "Efectivo",
                                  //"fdslfjlkasdvklanslkdnvlkasnfklvnas",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color(0xFF211551),
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                )
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  top: margin,
                  left: SizeConfig.safeBlockHorizontal * 2.8,
                  right: SizeConfig.safeBlockHorizontal * 2.8,
                ),
                //color: Colors.cyan,
                width: double.infinity,
                child: GenericButton(
                    text: "Confirmar",
                    radius: 10,
                    textSize:  SizeConfig.safeBlockHorizontal* 5,
                    width: SizeConfig.safeBlockHorizontal * 21,
                    height: SizeConfig.safeBlockHorizontal* 15,
                    color: Color(0xFF211551),
                    textColor: Colors.white,
                    onPressed: (){
                      try{
                        print("EXTRA INFO: $extraInfo");
                        this.validateAndSave();
                        if(extraInfo!=null){
                          setState(() {
                            address="$address, $extraInfo";
                            widget.serviceRequest.userAddress=address;
                          });
                          userBloc.updateServiceRequireData(widget.serviceRequest);
                          print("PASEAR: ${widget.serviceRequest.userAddress}");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> TripScreen(serviceType: widget.serviceRequest.serviceType,userInfo: widget.userInfo,reset: false,userAddress: address)));
                        }else{
                        }
                      }catch(e) {
                        Fluttertoast.showToast(
                            msg: "Primero activa tu ubicación",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1
                        );
                      }
                    })
            )
          ],
        ),
      ),
    );
  }
}
/*
*
* Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Center(
                                        child: Container(
                                          //color: Colors.greenAccent,
                                          width: SizeConfig.safeBlockHorizontal*90,
                                          height: SizeConfig.safeBlockVertical*30,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: SizeConfig.safeBlockHorizontal*90,
                                                height: SizeConfig.safeBlockVertical*20,
                                                decoration: BoxDecoration(
                                                    //color: Colors.red,
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/unableTrips.png")
                                                    )
                                                ),
                                              ),
                                              Container(
                                                width: SizeConfig.safeBlockHorizontal*70,
                                                child: Text("De momento no hay solicitudes",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xFF211551),
                                                      fontFamily: "RobotoRegular",
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          )
                                        )
                                      ),
                                    );
*
*
* */