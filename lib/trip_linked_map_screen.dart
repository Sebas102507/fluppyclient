import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';



class TripLinkedMapScreen extends StatefulWidget {
  String userId;
  String walkerId;
  double height;
  int serviceType;
  TripLinkedMapScreen({Key key, this.userId,this.walkerId,this.height,this.serviceType});
  @override
  _TripLinkedMapScreenState createState() => _TripLinkedMapScreenState();
}

class _TripLinkedMapScreenState extends State<TripLinkedMapScreen> {
  UserBloc userBloc;
  Set<Marker> _markers = new Set<Marker>();
  BitmapDescriptor markerIcon;
  GoogleMapController mapController;
  String _mapStyle;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  var location = new Location();
  LocationData currentLocation;
  CameraPosition initialCameraPosition;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  GoogleMapController _controller;
  GoogleMapPolyline _googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyBTMf58gBrCZUz6vDVjZoNDt4bOBpxggkw");
  int _polylineCount = 1;
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }


  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/IconoPaseador.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/IconoCasa.png');
  }


  void _add(LatLng walkerPosition) async{
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: walkerPosition,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          icon: destinationIcon));
    });
  }

 void playSound(){
    AudioCache player = new AudioCache();
    const alarmAudioPath = "dog_sms.mp3";
    player.play(alarmAudioPath);
  }

  _getPolylinesWithLocation(LatLng walkerPosition) async {
    List<LatLng> _coordinates;
    try{
      _coordinates =
      await _googleMapPolyline.getCoordinatesWithLocation(
          origin:walkerPosition,
          destination: LatLng(currentLocation.latitude, currentLocation.longitude),
          mode: RouteMode.driving);
    }catch(e){
      print("EL VALOR DE LA COORDENADAS ES: $_coordinates");
      print("AQUÍ FUE EL ERRORRRRRRRR");
    }
    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.greenAccent,
        points: _coordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();
    setInitialLocation();
    playSound();
    setState(() {
      rootBundle.loadString('assets/mapStyle.txt').then((string) {
        _mapStyle = string;
      });
    });
  }



  Widget linkedTrip(double walkerLatitude,double walkerLongitude,String walkerImage,String walkerFirstName,
      String walkerLastName,String walkerCedula,String walkerPhoneNumber, double infoMargin, int price){
    _getPolylinesWithLocation(LatLng(walkerLatitude, walkerLongitude));
    return Scaffold(
      body: Container(
        height: SizeConfig.safeBlockVertical*100,
        child: Stack(
          children: <Widget>[
            Container(
              height: SizeConfig.safeBlockVertical*100,
              child: GoogleMap(
                //myLocationEnabled: true,
                markers: _markers,
                //zoomGesturesEnabled: false,
                myLocationButtonEnabled: false,
                polylines: Set<Polyline>.of(_polylines.values),
                initialCameraPosition: CameraPosition(target: LatLng(walkerLatitude , walkerLongitude), zoom: 17),
                onMapCreated: (GoogleMapController controller) {
                  mapController=controller;
                  mapController.setMapStyle(_mapStyle);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    width: SizeConfig.safeBlockVertical/1.2,
                    color: Colors.white,
                    style: BorderStyle.solid
                ),
              ),
              margin: EdgeInsets.only(
                top: infoMargin-SizeConfig.blockSizeVertical*10,
                left:  SizeConfig.safeBlockHorizontal*3,
                right: SizeConfig.safeBlockHorizontal*3,
              ),
              height: SizeConfig.safeBlockVertical*8,
              width: SizeConfig.safeBlockHorizontal*98,
              child: Row(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical*8,
                    width: SizeConfig.safeBlockHorizontal*90,
                    //color: Colors.amber,
                    child: Center(
                      child: Container(
                        child: Text(
                          "\$${price} COP",
                          style: TextStyle(
                              color: Color(0xFF211551),
                              fontSize: SizeConfig.safeBlockVertical*3,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    width: SizeConfig.safeBlockVertical/1.2,
                    color: Colors.white,
                    style: BorderStyle.solid
                ),
              ),
              margin: EdgeInsets.only(
                top: infoMargin,
                left:  SizeConfig.safeBlockHorizontal*3,
                right: SizeConfig.safeBlockHorizontal*3,
              ),
              height: SizeConfig.safeBlockVertical*15,
              width: SizeConfig.safeBlockHorizontal*98,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.safeBlockHorizontal
                    ),
                    //color: Colors.yellow,
                    height: double.infinity,
                    width:  SizeConfig.safeBlockHorizontal*20,
                    child: Container(
                      height: SizeConfig.safeBlockVertical*30,
                      //color: Colors.green,
                      child: Center(
                        child: Container(
                            width: SizeConfig.safeBlockHorizontal*20,
                            height:SizeConfig.safeBlockHorizontal*20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: SizeConfig.safeBlockHorizontal*1.5,
                                  color: Color(0xFF211551), //Color(0xFF3BB2B8),//Color(0xFF42E695)
                                  style: BorderStyle.solid
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                child: FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage("assets/loading.gif"),
                                    image: CachedNetworkImageProvider( walkerImage )
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.brown,
                      height: double.infinity,
                      width:  SizeConfig.safeBlockHorizontal*50,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical,
                            left: SizeConfig.safeBlockHorizontal*3
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              //color: Colors.purple,
                              height: SizeConfig.safeBlockVertical*3.5,
                              width:  SizeConfig.safeBlockHorizontal*48,
                              child: Text(
                                walkerFirstName,
                                style: TextStyle(
                                    color: Color(0xFF211551),
                                    fontSize: SizeConfig.safeBlockVertical*2.5,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              //color: Colors.amber,
                              height: SizeConfig.safeBlockVertical*3.5,
                              width:  SizeConfig.safeBlockHorizontal*48,
                              child: Text(
                                walkerLastName,
                                style: TextStyle(
                                    color: Color(0xFF211551),
                                    fontSize: SizeConfig.safeBlockVertical*2.5,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              //color: Colors.redAccent,
                              height: SizeConfig.safeBlockVertical*2.5,
                              width:  SizeConfig.safeBlockHorizontal*48,
                              child: Text(
                                "C.c. $walkerCedula",
                                style: TextStyle(
                                    color: Color(0xFF211551),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              //color: Colors.green,
                              height: SizeConfig.safeBlockVertical*2.5,
                              width:  SizeConfig.safeBlockHorizontal*48,
                              child: Text(
                              widget.serviceType==0? "Fluppy Lite": "Fluppy Pro"
                              ,
                                style: TextStyle(
                                    color: Color(0xFF211551),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Container(
                    //color: Colors.lightGreenAccent,
                    height: double.infinity,
                    width:  SizeConfig.safeBlockHorizontal*14,
                    child: Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.phone,
                            color:  Color(0xFF53d2be),
                            size: SizeConfig.safeBlockVertical*5,
                          ),
                          onPressed: (){
                            print("LLAMAR");
                            _launchCaller(walkerPhoneNumber);
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _handleLinkedTrips() {
    print("CUANDO SE LINKEA EL VALOR DEL SERVICE TYPE ES: ${widget.serviceType}");
    //print("ID DEL USER PARA EL MAPA: ${widget.userId}");
    //print("ID DEL WALKER PARA EL MAPA: ${widget.walkerId}");
    Widget widgetReturned;
    try{
      widgetReturned= StreamBuilder(
          stream: widget.serviceType==0 ? Firestore.instance.collection('linkedService').document(widget.walkerId).collection("FluppyLiteLinked").document('${widget.walkerId}-${widget.userId}').snapshots():
          Firestore.instance.collection('linkedService').document('${widget.walkerId}-${widget.userId}').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            //print("UBICACION DEL WALKER LATITUDE: ${snapshot.data["walkerLatitude"]}");
            //print("UBICACION DEL WALKER LONGITUDE: ${snapshot.data["walketLongitude"]}");
            //print("SERÁ QUE EL ERRROR ES ACAASAAAAAA PORFOVAOR MIRARRRRRRRRRRRRRR");
            if(!snapshot.hasData || currentLocation==null){
              //print("ENTRE EN EL LINKEDDDDDDDDDDDDDDDDDDD");
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                  ),
                ),
              );
            } else if(snapshot.hasError){
              return Container(
                child: Center(
                  child: Text("ERROR"),
                ),
              );
            }else{
              try{
                _add(LatLng(snapshot.data["walkerLatitude"],snapshot.data["walketLongitude"]));
                /*double walkerLatitude,double walkerLongitude,String walkerImage,String walkerFirstName,
      String walkerLastName,String walkerCedula,String walkerPhoneNumber*/
                return linkedTrip(snapshot.data["walkerLatitude"], snapshot.data["walketLongitude"],snapshot.data["walkerPhotoUrl"],
                    snapshot.data["walkerFirstName"],snapshot.data["walkerLastName"],snapshot.data["walkerCedula"],snapshot.data["walkerPhone"],SizeConfig.safeBlockVertical*73,snapshot.data["tripPrice"]);
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
          }
      );
    }catch(e){
      //print("SE SUPONE QUE DEBO ENTRAR AL ERRORRRRRRRRRRRRRRRRR EL CUAL ES : $e");
      widgetReturned= Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
          ),
        ),
      );
    }
    return widgetReturned;
  }


  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return _handleLinkedTrips();
  }

  void onMapCreated(controller){
    setState(() {
      mapController=controller;
    });
  }
  _launchCaller(String walkerPhoneNumber) async {
    String url = "tel:$walkerPhoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
