import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/service_feedback_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/trip_linked_map_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class TripScreen extends StatefulWidget {
  bool reset;
  int serviceType;
  User userInfo;
  String userAddress;
  TripScreen ({Key key, this.serviceType,this.userInfo,this.reset,this.userAddress});

  @override
  _TripScreen  createState() => _TripScreen ();
}
class _TripScreen  extends State<TripScreen > {
  String userId;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  UserBloc userBloc;
  BitmapDescriptor markericon;
  final Set<Marker> _markers = {};
  Position userLocation;
  LatLng userPosition;
  GoogleMapController mapController;
  double screenWidth;
  double screenHeight;
  bool playOneTime=true;
  _getCurrentUserId () async {
    mCurrentUser = await _auth.currentUser();
    setState(() {
      this.userId=mCurrentUser.uid;
    });
  }

  Future<void> erraseRequestDocument(String documentId){
    return Firestore.instance.collection('service_request').document(documentId).delete();
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUserId();
   // print("ID DEL USUARIOOOOOOOO: $userId");
  }

  Widget trip(String userId,String walkerId){
   return  Scaffold(
        body:
        Container(
            child: Center(
                child: Container(
                    child:
                    this.screenHeight>650?
                    TripLinkedMapScreen(walkerId: walkerId ,userId: userId,height: 76,serviceType: widget.serviceType,)
                        :
                    TripLinkedMapScreen(walkerId: walkerId ,userId: userId,height: 70, serviceType: widget.serviceType,)

                )
            )
        )
    );
  }

  Widget _handle() {
    try{
      return StreamBuilder(
          stream: Firestore.instance.collection('users').document(userId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData || snapshot.data["linked"]==null){
              print("NO HAY DATA");
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                  ),
                ),
              );
            }
            else if(snapshot.data["linked"]=="posLinked"){
              return FeedBackScreen(userInfo: widget.userInfo,reset: widget.reset,);

            }else if(snapshot.data["serviceAcceptedType"]== null || snapshot.data["walkerId"]==" " || snapshot.data["serviceAccepted"]==false){
              print("ENTRE EN EL TRIPPPPPPPP");
              return findingWalker(snapshot.data["id"]);
            }
            else if(snapshot.hasError){
              return Container(
                child: Center(
                  child: Text("ERROR"),
                ),
              );
            }else{
              return trip(snapshot.data["id"],snapshot.data["walkerId"]);
            }
          }
      );
    }catch(e){
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return _handle();
  }

  Widget findingWalker(String userId){
    return Scaffold(
        body: Container(
            child: Center(
                child: Container(
                  //color: Colors.amber,
                  width: SizeConfig.safeBlockHorizontal*90,
                  height: SizeConfig.safeBlockVertical*50,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical*2
                        ),
                        width: SizeConfig.safeBlockHorizontal*60,
                        height: SizeConfig.safeBlockVertical*20,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: SizeConfig.safeBlockHorizontal*60,
                              height: SizeConfig.safeBlockVertical*20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/map.png")
                                  )
                              ),
                            ),
                            Container(
                              width: SizeConfig.safeBlockHorizontal*60,
                              height: SizeConfig.safeBlockVertical*20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/search.gif")
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical*1
                        ),
                        //color: Colors.blue,
                        width: SizeConfig.safeBlockHorizontal*90,
                        height: SizeConfig.safeBlockVertical*5,
                        child: Text("Buscando un paseador...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockVertical*3,
                              color: Color(0xFF211551)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical*3.5
                        ),
                        //color: Colors.blue,
                        width: SizeConfig.safeBlockHorizontal*90,
                        child: Text("Dir: ${widget.userAddress}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockVertical*2,
                              color: Colors.grey
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal*4,
                              right: SizeConfig.blockSizeHorizontal*4,
                              bottom:  SizeConfig.safeBlockVertical*2
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            //color: Colors.blue,
                            boxShadow: <BoxShadow>[
                              BoxShadow (
                                  color:  Colors.red,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 0.2)
                              )
                            ],
                          ),
                          child: GenericButton(
                            text: "Cancelar",
                            radius: 10,
                            textSize: SizeConfig.safeBlockHorizontal* 5,
                            width: SizeConfig.safeBlockHorizontal*4,
                            height: SizeConfig.safeBlockHorizontal* 15,
                            color:  Colors.red ,
                            textColor: Colors.white,
                            onPressed: (){
                              this.erraseRequestDocument(userId);
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                              //SystemChannels.textInput.invokeMethod('TextInput.hide');
                              Navigator.pop(context);
                            },
                          )
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }

  void onMapCreated(controller){
    setState(() {
      mapController=controller;
    });
  }
}