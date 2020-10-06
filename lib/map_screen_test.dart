import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/check_address_screen.dart';
import 'package:fluppyclient/check_pet_number.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/square_service_item.dart';
import 'package:fluppyclient/trip_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

//padding: EdgeInsets.only(bottom: 100, left: 15),

class MapScreen2 extends StatefulWidget {
  String userId;
  int petNumber;
  String userCoupon;
  MapScreen2({Key key, this.userId,this.petNumber,this.userCoupon});
  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  GoogleMapController mapController;
  Color iconColor=  Colors.grey;
  int option=0; // 0 is LITE , 1 is PRO
  Color colorLite= Color(0xFF211551);
  Color colorPro= Colors.grey;
  Color bottomColorLite= Colors.white;
  Color bottomColorPro= Colors.grey[200];
  double opacityLite=1;
  double opacityPro=0.5;
  double screenWidth;
  double screenHeight;
  UserBloc userBloc;
  String currentAddress="NA";
  String _mapStyle;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position userLocation;
  bool disableButton=true;
  double secondContainerHeight=0;
  int userTrips=0;
  FirebaseUser mCurrentUser;
  int price;
  void onMapCreated(controller){
    setState(() {
      mapController=controller;
    });
  }

  Widget chooseFirstContainer(double height, double margin){
    return  Container(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            //color: Colors.orange,
            width: SizeConfig.safeBlockHorizontal * 100,
            height: SizeConfig.blockSizeVertical*height,
            child: GoogleMap(
              padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal*60),
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
              //zoomGesturesEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition:  CameraPosition(target: LatLng(userLocation.latitude , userLocation.longitude), zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                disableButton=false;
                mapController=controller;
                mapController.setMapStyle(_mapStyle);
              },
            ),
          ),
          Container(
            //color: Colors.pink,
              margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical*5,
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
                      Navigator.of(context).pop(MaterialPageRoute(builder: (context) => CheckPetNumber(userId: widget.userId,)));
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF211551),
                      size: SizeConfig.blockSizeVertical * 4,
                    ),
                  )
              )
          ),
          Container(
              margin: EdgeInsets.only(
                  left:SizeConfig.safeBlockHorizontal*80,
                  top: SizeConfig.safeBlockHorizontal*6
              ),
              width: double.infinity,
              height: SizeConfig.blockSizeHorizontal*30,
              //color: Colors.green,
              child: Center(
                child: Container(
                  width:  SizeConfig.blockSizeHorizontal*15,
                  height:  SizeConfig.blockSizeHorizontal*15,
                  decoration: BoxDecoration(
                    color: Color(0xFF211551),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          iconColor=Colors.green;
                        });
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(userLocation.latitude, userLocation.longitude),
                                zoom: 15),
                          ),
                        );
                      }
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget chooseSecondContainer(double height, double margin,String userFirstName, String userLastName, String userPhoneNumber,
      String email,String photoUrl,String userPetName,String userPetType, String userId, int userTrips, double topMargin,String couponId){
    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.9),//Colors.grey[200],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            )
        ),
        height: height,
        width: SizeConfig.blockSizeHorizontal*100,
        margin: EdgeInsets.only(
            top: topMargin
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical*3,
                  bottom: SizeConfig.blockSizeVertical*2
                ),
                //color: Colors.green,
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.blockSizeHorizontal*36,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal*2
                          ),
                          width: SizeConfig.blockSizeHorizontal*47,
                          height: SizeConfig.blockSizeHorizontal*40,
                          //color: Colors.pink,
                          child:   SquareServiceItem(
                            alertMessage: "Fluppy lite te ofrece un servicio durante 45 min, donde el Walker estará con tus perros y los de otros dueños. El servicio incluye una sesión de ejercicio e interacción en base a la edad de tu perro, posteriormente se ofrece un espacio de hidratación y finalmente se realiza un proceso de relajación.",
                            title: "Fluppy",
                            title2: "Lite",
                            description: "Esto es una descripcion",
                            tamanoDescription: 5,
                            price: couponId==null ?(12900*widget.petNumber) : 0,
                            photoIndicator: "assets/FluppyLite.png",
                            onPressed: (){
                              setState(() {
                                if(couponId==null || couponId==""){
                                  setState(() {
                                    price= 12900*widget.petNumber;
                                  });
                                }else{
                                  setState(() {
                                    price=0;
                                  });
                                }
                                colorLite=Color(0xFF211551);
                                colorPro=Colors.grey;
                                opacityPro=0.5;
                                opacityLite=1;
                                option=0;
                                bottomColorLite = Colors.white;
                                bottomColorPro= Colors.grey[200];
                                print(option);
                              });
                            },
                            imageOpacity: opacityLite,
                            mainColor: colorLite,
                            bottomContainerColor: bottomColorLite,
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal*2,
                          height: SizeConfig.blockSizeHorizontal*40,
                          //color: Colors.black,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal*2
                          ),
                          width: SizeConfig.blockSizeHorizontal*47,
                          height: SizeConfig.blockSizeHorizontal*40,
                          //color: Colors.orange,
                          child: SquareServiceItem(
                            alertMessage: "Fluppy Pro te ofrece un servicio durante 45 min, donde tu(s) perros gozarán lo mejor de un servico personalizado y único, estando sólo con el Walker. El servicio incluye una sesión de ejercicio e interacción en base a la edad de tu perro, posteriormente se ofrece un espacio de hidratación y finalmente se realiza un proceso de relajación.",
                            title: "Fluppy",
                            title2: "Pro",
                            description: "Esto es una descripcion",
                            tamanoDescription: 5,
                            price: couponId==null ? (14900*widget.petNumber) : 0,
                            photoIndicator: "assets/FluppyPro.png",
                            onPressed: (){
                              setState(() {
                                if(couponId==null || couponId==""){
                                  setState(() {
                                    price= 14900*widget.petNumber;
                                  });
                                }else{
                                  setState(() {
                                    price=0;
                                  });
                                }
                                colorPro=Color(0xFF211551);
                                colorLite=Colors.grey;
                                opacityPro=1;
                                opacityLite=0.5;
                                option=1;
                                bottomColorLite = Colors.grey[200];
                                bottomColorPro= Colors.white;
                                print(option);
                              });
                            },
                            imageOpacity: opacityPro,
                            mainColor: colorPro,
                            bottomContainerColor: bottomColorPro,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 2.8,
                  right: SizeConfig.safeBlockHorizontal * 2.8,
                ),
                //color: Colors.cyan,
                width: double.infinity,
                child: GenericButton(
                  text: "Quiero un paseo",
                  radius: 10,
                  textSize:  SizeConfig.safeBlockHorizontal* 5,
                  width: SizeConfig.safeBlockHorizontal * 21,
                  height: SizeConfig.safeBlockHorizontal* 15,
                  color: Color(0xFF211551),
                  textColor: Colors.white,
                  onPressed: (){
                    disableButton==true ?  null :
                    print("ADDRESS : $currentAddress");
                    try{
                      print("PASEAR");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckAddressScreen(serviceRequest: new ServiceRequest(
                          userFirstName: userFirstName,
                          userLastName: userLastName,
                          userPhoneNumber: userPhoneNumber,
                          userEmail: email,
                          userId: userId,
                          userImage: photoUrl,
                          serviceType: option,
                          latitude: userLocation.latitude,
                          longitude: userLocation.longitude,
                          userAddress: currentAddress,
                          userPetName: userPetName,
                          userPetType: userPetType,
                          userTrips: userTrips,
                          petNumber: widget.petNumber,
                          price: price
                      ),
                        userInfo: new User(
                            email: email,
                            id: userId,
                            firstName: userFirstName,
                            lastName: userLastName,
                            phone: userPhoneNumber,
                            photoURl: photoUrl,
                            userPetName: userPetName,
                            userPetType: userPetType
                        ),
                      )));
                    }catch(e) {
                      Fluttertoast.showToast(
                          msg: "Primero activa tu ubicación",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1
                      );
                    }

                  },
                ),
              )
            ],
          ),
        )
    );
  }
  Widget loadingScreen(){
    return Scaffold(
      body: Container(
        child: Center(
            child: Container(
              //color: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal*80,
              height: SizeConfig.safeBlockVertical*25,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.safeBlockVertical*3,
                    ),
                    height: SizeConfig.safeBlockVertical*10,
                    child:  Icon(
                      CustomIcons.map,
                      size: SizeConfig.safeBlockVertical*10,
                    ),
                  ),
                  Text("Obteniendo tu posición...",
                    style: TextStyle(
                        color: Color(0xFF211551),
                        fontSize: SizeConfig.safeBlockVertical*2.5,
                        fontFamily: ("RobotoMedium")
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical*2,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
  Widget map(String userFirstName, String userLastName, String userPhoneNumber,
      String email,String photoUrl,String userPetName,String userPetType, String userId, int userTrips, double firstHeight, double secondHeight,double topMargin, String couponId){
    return Scaffold(
      body: Container(
          color: Color.fromRGBO(255, 255, 255, 0.9),
          height: SizeConfig.safeBlockVertical*100,
          child: Container(
            child: Stack(
              children: <Widget>[
                chooseFirstContainer(firstHeight,0),
                chooseSecondContainer(secondHeight,SizeConfig.safeBlockVertical*2,userFirstName,
                    userLastName,userPhoneNumber,email,photoUrl,userPetName,userPetType,userId,userTrips, topMargin,couponId),
              ],
            ),
          )
      ),
    );
  }

  Widget _firstHandle(double height){

    if((height<650)){
      return  _handle(SizeConfig.safeBlockVertical*95,SizeConfig.safeBlockVertical*48,SizeConfig.safeBlockVertical*58);
    }else if((height>650 && height<700)){
      return  _handle(SizeConfig.safeBlockVertical*95,SizeConfig.safeBlockVertical*50,SizeConfig.safeBlockVertical*57);
    }else if(height<812){
      return  _handle(SizeConfig.safeBlockVertical*95,SizeConfig.safeBlockVertical*37,SizeConfig.safeBlockVertical*66);
    }else {
      return  _handle(SizeConfig.safeBlockVertical*95,SizeConfig.safeBlockVertical*37,SizeConfig.safeBlockVertical*67);

    }
  }

  Future<Position> getCurrentPosition() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.userCoupon==null || widget.userCoupon=="" || widget.userCoupon==" "){
      setState(() {
        price= 12900*widget.petNumber;
      });
    }else{
      setState(() {
        price= 0;
      });
    }
    getCurrentPosition().then((value) {
      setState(() {
        userLocation = value;
        //print("LOCALIZACIÓN INIT STATE: $userLocation");
      });
    });
    setState(() {
      rootBundle.loadString('assets/mapStyle.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  Widget _handle(double firstHeight,double secondHeight, double topMargin) {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return loadingScreen();

          }else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text("ERROR"),
              ),
            );
          }else if(snapshot.data["serviceAcceptedType"]==-1 || snapshot.data["stillLinked"]==null || snapshot.data["stillLinked"]==" "|| snapshot.data["stillLinked"]==""){
            return Scaffold(
                body: map(snapshot.data["firstName"], snapshot.data["lastName"], snapshot.data["phoneNumber"], snapshot.data["email"],
                    snapshot.data["photoUrl"],snapshot.data["petName"],
                    snapshot.data["petType"], snapshot.data["id"],snapshot.data["trips"],firstHeight,secondHeight,topMargin,snapshot.data["couponId"])
            );
          }else{
            print("ENTRE EN EL QUE MIRO EL WALKER ID, YA ESTÁ VINCULADO A UN WALKER");
            return secondHandle(snapshot.data["walkerId"], snapshot.data["id"],
                snapshot.data["serviceAcceptedType"],snapshot.data["email"],snapshot.data["firstName"], snapshot.data["lastName"],snapshot.data["photoUrl"]);
          }
        }
    );
  }


  Widget secondHandle(String walkerId, String userId, int serviceType, String email, String firstName, String lastName, String image){
    return Container(
      child: Center(
        child: Container(
            width: SizeConfig.safeBlockHorizontal*50,
            height: SizeConfig.safeBlockVertical*10,
            child: GenericButton(
              text: "Continuar con mi paseo",
              radius: 10,
              textSize: SizeConfig.safeBlockHorizontal* 5,
              width: SizeConfig.safeBlockHorizontal*4,
              height: SizeConfig.safeBlockHorizontal* 15,
              color:  Color(0xFF42E695) ,
              textColor: Colors.white,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>TripScreen(serviceType:serviceType, userInfo: User(email: email, id: userId,lastName: lastName,firstName: firstName,photoURl: image),reset: true,)
                    )
                );
              },
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return userLocation==null?
    loadingScreen()
        :
    _firstHandle(screenHeight);
  }
}
