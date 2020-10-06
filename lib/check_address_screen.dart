import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/check_request_screen.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/service_request.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'blocUser.dart';

class CheckAddressScreen extends StatefulWidget {

  ServiceRequest serviceRequest;
  User userInfo;
  CheckAddressScreen({Key key, this.serviceRequest,this.userInfo});

  @override
  _CheckAddressScreenState createState() => _CheckAddressScreenState();
}

class _CheckAddressScreenState extends State<CheckAddressScreen> {
  bool requestAccepted=false;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  double screenWidth;
  double screenHeight;
  UserBloc userBloc;
  bool validate=true;
  final formKey = new GlobalKey<FormState>();
  String currentAddress="";
  String subAddress="";
  String alternativeAddress;

  Future<Placemark> _getAddressFromLatLng() async {
    print("LATIDUDE: ${widget.serviceRequest.latitude}");
    print("LONGITUDE: ${widget.serviceRequest.longitude}");

    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(widget.serviceRequest.latitude,widget.serviceRequest.longitude);
    Placemark place = placemark[0];
    print("${place.name}");
    print("${place.thoroughfare}");
    print("${place.subThoroughfare}");
    return place;
  }
  Future<Address> yourFunction() async {
    final coordinates = new Coordinates(widget.serviceRequest.latitude,widget.serviceRequest.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = addresses.first;
    print("HOLA ESTO ES DEL GEOCODER${first.featureName}");
    print("HOLA ESTO ES DEL GEOCODER${first.thoroughfare}");
    print("HOLA ESTO ES DEL GEOCODER${first.subThoroughfare}");
    print("HOLA ESTO ES DEL GEOCODER${first.locality}");
    print("HOLA ESTO ES DEL GEOCODER${first.addressLine}");
    return first;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   yourFunction().then((address){
     alternativeAddress=address.addressLine;
   });
    print("LATIDUDE EN EL INIT: ${widget.serviceRequest.latitude}");
    print("LONGITUDE EN EL INIT: ${widget.serviceRequest.longitude}");
    _getAddressFromLatLng().then((place){
      print("EL NAME DEL PLACE: ${place.name}");
      setState(() {
        subAddress=place.thoroughfare;
        currentAddress="${place.thoroughfare} ${place.subThoroughfare},${place.locality},${place.country}";
      });
    });
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
                  Text("Obteniendo tu dirección...",
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


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if(currentAddress=="NA" || currentAddress==" " || currentAddress==null){
      return Scaffold(
          body: loadingScreen()
      );
    }else{
      return goCheckRequestScreen();
    }
  }
//", Bogotá, Colombia"
  Widget goCheckRequestScreen(){
    if(subAddress==null || subAddress=="" || subAddress==" "){
      setState(() {
        widget.serviceRequest.userAddress=alternativeAddress;
      });
    }else{
      setState(() {
        widget.serviceRequest.userAddress=currentAddress;
      });
    }
    if(widget.serviceRequest.userAddress==null || widget.serviceRequest.userAddress==""){
      print("TODAVÍA NO ");
      return loadingScreen();
    }else{
      print("SE SUPONE QUE YA ");
      return CheckRequestScreen(serviceRequest: widget.serviceRequest,userInfo: widget.userInfo);
    }
    }

}
