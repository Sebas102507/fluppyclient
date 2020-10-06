import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/veterinarias_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ComoLlegarVetScreen extends StatefulWidget {
  String vetName;
  double vetLatitude;
  double vetLongitude;
  double userLatitude;
  double userLongitude;
  ComoLlegarVetScreen({Key key,this.vetName,this.userLatitude,this.userLongitude,this.vetLatitude,this.vetLongitude});
  @override
  _ComoLlegarVetScreenState createState() => _ComoLlegarVetScreenState();
}

class _ComoLlegarVetScreenState extends State<ComoLlegarVetScreen> {
  UserBloc userBloc;
  Set<Marker> _markers = new Set<Marker>();
  BitmapDescriptor markerIcon;
  GoogleMapController mapController;
  String _mapStyle;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  var location = new Location();
  CameraPosition initialCameraPosition;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  GoogleMapController _controller;
  GoogleMapPolyline _googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyBTMf58gBrCZUz6vDVjZoNDt4bOBpxggkw");
  int _polylineCount = 1;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinFluppyVet.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/fluppyVet.png');
  }

  void _add(LatLng userPosition, LatLng vetPosition) async{
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: userPosition,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: vetPosition,
          icon: destinationIcon));
    });
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
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

  _getPolylinesWithLocation(LatLng userPosition, LatLng vetPosition) async {
    List<LatLng> _coordinates;
    try{
      _coordinates =
      await _googleMapPolyline.getCoordinatesWithLocation(
          origin: userPosition,
          destination: vetPosition,
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();
    setState(() {
      rootBundle.loadString('assets/mapStyle.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    _add(LatLng (widget.userLatitude,widget.userLongitude), LatLng(widget.vetLatitude,widget.vetLongitude));
    _getPolylinesWithLocation(LatLng (widget.userLatitude,widget.userLongitude), LatLng(widget.vetLatitude,widget.vetLongitude));
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical * 5
                ),
                //color: Colors.orange,
                width: double.infinity,
                height: SizeConfig.safeBlockVertical * 5,
                child: Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal * 2,
                    right: SizeConfig.safeBlockHorizontal * 2,
                  ),
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical * 18,
                  child: Container(
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
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, MaterialPageRoute(builder: (
                                  context) => VeterinariasScreen()));
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                          )
                      )
                  ),
                )
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal * 100,
              //height: SizeConfig.safeBlockVertical* 10,
              //color: Colors.red,
              margin: EdgeInsets.only(
                bottom: SizeConfig.blockSizeVertical * 1,
                //right: SizeConfig.blockSizeVertical*20,
                left: SizeConfig.safeBlockHorizontal* 2,
              ),
              child: Text("Ruta para: ${widget.vetName}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockSizeVertical * 3,
                ),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.safeBlockVertical * 70,
              //color: Colors.blue,
              child: GoogleMap(
                //myLocationEnabled: true,
                markers: _markers,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                polylines: Set<Polyline>.of(_polylines.values),
                initialCameraPosition: CameraPosition(target: LatLng(widget.userLatitude , widget.userLongitude), zoom: 15),
                onMapCreated: (GoogleMapController controller) {
                  mapController=controller;
                  mapController.setMapStyle(_mapStyle);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
