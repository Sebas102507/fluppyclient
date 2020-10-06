import 'dart:math';
import 'package:fluppyclient/confirmation_payment_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyD2CUSO8sXhTvG9AG3H2YSO3pNpEvZ8Wws";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class GetAddressGoogle extends StatefulWidget {
  String userId;
  Map<String, Product>userProduct;
  int total;
  int totalBeforePoints;
  int points;
  String storeType;
  BuildContext mainContext;
  String address;
  GetAddressGoogle({Key key,this.mainContext,this.storeType,this.userId,this.userProduct,this.total,this.address,this.totalBeforePoints,this.points});
  @override
  _GetAddressGoogle createState() => _GetAddressGoogle();
}

class _GetAddressGoogle extends State<GetAddressGoogle> {
  LocationResult _pickedLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.address="HOLA";
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchScaffold(widget.mainContext,widget.storeType,widget.userId,widget.userProduct,widget.total,context,widget.totalBeforePoints,widget.points);
  }
}

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  String userId;
  Map<String, Product>userProduct;
  int total;
  int totalBeforePoints;
  int points;
  String storeType;
  BuildContext mainContext;
  BuildContext currentContext;
  CustomSearchScaffold(this.mainContext,this.storeType,this.userId,this.userProduct,this.total,this.currentContext,this.totalBeforePoints,this.points)
      : super(
    apiKey: "AIzaSyD2CUSO8sXhTvG9AG3H2YSO3pNpEvZ8Wws",
    sessionToken: Uuid().generateV4(),
    components: [Component(Component.country, "co")],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState(mainContext,storeType,userId,userProduct,total,this.currentContext,this.totalBeforePoints,this.points);
}

/*Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}*/

Future<LatLng> getInfo(Prediction p) async{
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    return LatLng(lat, lng);
  }
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  String addressField;
  double latitude, longitude;
  String userId;
  Map<String, Product>userProduct;
  int total;
  int totalBeforePoints;
  int points;
  String storeType;
  BuildContext mainContext;
  BuildContext currentContext;
  _CustomSearchScaffoldState(this.mainContext,this.storeType,this.userId,this.userProduct,this.total,this.currentContext,this.totalBeforePoints,this.points);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField(),backgroundColor: Color(0xFF53d2be),);
    final body = PlacesAutocompleteResult(
        onTap: (p) {
          getInfo(p).then((LatLng coordinates){
            //print("DIR: ${p.description}");
            setState(() {
           this.addressField=p.description;
           this.latitude=coordinates.latitude;
           this.longitude=coordinates.longitude;
          });
            FocusScope.of(context).unfocus();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>CofirmPaymentScreen(userId: this.userId,userProduct: this.userProduct,
                  total:this.total,mainContext: this.mainContext,adrress: this.addressField,latitude:this.latitude,
                  longitude: this.longitude,storeType: this.storeType,points: this.points,totalBeforePoints: this.totalBeforePoints,)));

          });
        },

        logo: Container(
          height: SizeConfig.safeBlockVertical*40,
          width: SizeConfig.blockSizeHorizontal*100,
          //color: Colors.red,
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical*30,
                    width: SizeConfig.blockSizeHorizontal*100,
                    child: Center(
                      child: Container(
                        height: SizeConfig.safeBlockVertical*30,
                        width: SizeConfig.blockSizeHorizontal*80,
                        decoration: BoxDecoration(
                          //color: Colors.yellow,
                            image: DecorationImage(
                              image: AssetImage("assets/dogThinking.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }
}

class Uuid {
  final Random _random = Random();
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
