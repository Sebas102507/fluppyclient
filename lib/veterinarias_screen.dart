import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/como_llegar_veterinaria_screen.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class VeterinariasScreen extends StatefulWidget {
  @override
  _VeterinariasScreenState createState() => _VeterinariasScreenState();
}

class _VeterinariasScreenState extends State<VeterinariasScreen> {

  Position userLocation;
  UserBloc userBloc;
  double distance;
  var temporalSearch = [];
  var queryResult = [];
  bool continueAdding=true;
  int contador=0;
  int contadorQuery=0;
  var now = new DateTime.now();
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

  Future<double> getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distance;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = new DateTime.now();
    print("LA HORA ACTUALLLLLL: ${now.hour}");
    setState(() {
      temporalSearch = [];
      queryResult = [];
    });
    getCurrentPosition().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: handleCurrentLocation(),
    );
  }


  Widget handleCurrentLocation() {
    if (userLocation == null) {
      return Container(
        child: Center(
            child: Container(
                width: SizeConfig.blockSizeHorizontal*50,
                height:SizeConfig.safeBlockVertical * 20,
                child: Center(
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal*50,
                    height: SizeConfig.safeBlockVertical * 20,
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*4
                          ),
                          child: Text("Buscando tus Vets más cercanas",
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontFamily: "RobotoRegular",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ),
                )
            )
        ),
      );
    } else {
      print("LAT ACTUAL: ${this.userLocation.latitude}");
      print("LON ACTUAL: ${this.userLocation.longitude}");
      if(this.continueAdding){
        this.getVeterinarias();
      }
      return handleVeterianarias();
    }
  }


  Widget handleVeterianarias() {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: SizeConfig.safeBlockVertical * 20,
            color: Colors.blue,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 5
                    ),
                    color: Colors.blue,
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
                                      context) => HomeScreen()));
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
                  color: Colors.blue,
                  margin: EdgeInsets.only(
                    //bottom: SizeConfig.blockSizeVertical * 6.5,
                    //right: SizeConfig.blockSizeVertical*20,
                    //left: SizeConfig.safeBlockHorizontal* 2,
                  ),
                  child: Text("Vets cercanas",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          (this.temporalSearch.length==0)?
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical*4
                ),
                child: Center(
                  child: Text("Pronto encontrarás tu veterinaria más cercana",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 2,
                    ),
                  ),
                ),
              )
              :
          Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.safeBlockVertical * 68,

            //color: Colors.blue,
            child: StreamBuilder(
              stream: Firestore.instance.collection("veterinarias2").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView(
                      children: temporalSearch.map((vet) {
                        return veterinariaCard(vet.name,vet.lat ,vet.long,vet.num, vet.distance,vet.image,vet.description,vet.openHour,vet.closeHour);
                      }).toList());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget veterinariaCard(String name,double latitude, double longitude, String number,double distance,String image,String description, int openHour, int closeHour) {
    if((this.now.hour>=openHour && this.now.hour<closeHour) || (openHour==24 && closeHour==24 )){
      print("ABIERTOODOOOOO");
      return  Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 26,
        margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical*1,
        ),
        child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.safeBlockVertical * 10,
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: <BoxShadow>[
                BoxShadow (
                    color:  Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0.0, 0.2)
                )
              ],
            ),
            child:Column(
              children: [
                Container(
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.safeBlockVertical * 16,
                    //color: Colors.yellow,
                    child: Stack(
                      children: [
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.safeBlockVertical * 16,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.safeBlockVertical * 16,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2,
                                fontFamily: "RobotoRegular",
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ),
                      ],
                    )
                ),

                Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.safeBlockVertical * 9,
                  //color: Colors.green,
                  child:  Row(
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 68,
                        height: SizeConfig.safeBlockVertical * 9,
                        //color: Colors.orange,
                        child: Column(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 65,
                              //height: SizeConfig.safeBlockVertical * 1.5,
                              //color: Colors.purple,
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.safeBlockVertical*1
                              ),
                              child: Text("$description",style: TextStyle(color: Colors.white,fontFamily: "RobotoRegular",fontSize: SizeConfig.safeBlockVertical*1.5),),
                            ),
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 65,
                              // height: SizeConfig.safeBlockVertical * 6,
                              //color: Colors.purple,
                              child: Row(
                                children: [
                                  Text("Estás a: ${distance.toStringAsFixed(2)} km",style: TextStyle(color: Colors.grey[200],fontSize: SizeConfig.safeBlockVertical*1.5,fontWeight: FontWeight.bold,fontFamily: "RobotoRegular",),),
                                  (openHour==24 && closeHour==24)?
                                  Text(
                                    " / 24 horas",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockVertical*1.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[200],
                                      fontFamily: "RobotoRegular",
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                  :
                                  Text(
                                    " / ${openHour}:00${this.getTimeState(openHour)}-${closeHour}:00${this.getTimeState(closeHour)}",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockVertical*1.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[200],
                                      fontFamily: "RobotoRegular",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 16,
                        height: SizeConfig.safeBlockVertical * 12,
                        //color: Colors.yellow,
                        child: FlatButton(
                          color: Colors.blue,
                          onPressed: (){
                            print("LA HORA ES: ${now.hour} : ${now.minute}");
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ComoLlegarVetScreen(vetName: name,vetLatitude: latitude ,
                              vetLongitude: longitude ,userLatitude: userLocation.latitude ,userLongitude: userLocation.longitude,)));
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 16,
                            height: SizeConfig.safeBlockVertical * 12,
                            child: Center(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 16,
                                height: SizeConfig.safeBlockVertical * 8,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Cómo llegar",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "RobotoRegular",
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 16,
                        height: SizeConfig.safeBlockVertical * 10,
                        //color: Colors.pinkAccent,
                        child: FlatButton(
                          color: Colors.blue,
                          onPressed: (){
                            _launchCaller(number);
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 16,
                            height: SizeConfig.safeBlockVertical * 10,
                            child: Center(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 16,
                                height: SizeConfig.safeBlockVertical * 8,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Llamar",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "RobotoRegular",
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            )
        ),
      );
    }else{
      print("CERRADOOOOO");
      return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 26,
        margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical*1,
        ),
        child: Stack(
          children: [
            Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                height: SizeConfig.safeBlockVertical * 26,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: <BoxShadow>[
                    BoxShadow (
                        color:  Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0.0, 0.2)
                    )
                  ],
                ),
                child:Column(
                  children: [
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.safeBlockVertical * 16,
                        //color: Colors.yellow,
                        child: Stack(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 100,
                              height: SizeConfig.safeBlockVertical * 16,
                              child: CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Container(
                                width: SizeConfig.blockSizeHorizontal * 100,
                                height: SizeConfig.safeBlockVertical * 16,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.blockSizeVertical*2,
                                      fontFamily: "RobotoRegular",
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                )
                            ),
                          ],
                        )
                    ),

                    Container(
                      width: SizeConfig.blockSizeHorizontal * 100,
                      height: SizeConfig.safeBlockVertical * 9,
                      //color: Colors.green,
                      child:  Row(
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 68,
                            height: SizeConfig.safeBlockVertical * 9,
                            //color: Colors.orange,
                            child: Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 65,
                                  //height: SizeConfig.safeBlockVertical * 1.5,
                                  //color: Colors.purple,
                                  margin: EdgeInsets.only(
                                      bottom: SizeConfig.safeBlockVertical*1
                                  ),
                                  child: Text("$description",style: TextStyle(color: Colors.white,fontFamily: "RobotoRegular",fontSize: SizeConfig.safeBlockVertical*1.5),),
                                ),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 65,
                                  // height: SizeConfig.safeBlockVertical * 6,
                                  //color: Colors.purple,
                                  child: Text("Estás a: ${distance.toStringAsFixed(2)} km",style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.bold,fontFamily: "RobotoRegular",),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 16,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.yellow,
                            child: FlatButton(
                              color: Colors.blue,
                              onPressed: (){
                                print("LA HORA ES: ${now.hour} : ${now.minute}");
                                Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ComoLlegarVetScreen(vetName: name,vetLatitude: latitude ,
                              vetLongitude: longitude ,userLatitude: userLocation.latitude ,userLongitude: userLocation.longitude,)));
                              },
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 16,
                                height: SizeConfig.safeBlockVertical * 12,
                                child: Center(
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 16,
                                    height: SizeConfig.safeBlockVertical * 8,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Cómo llegar",
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "RobotoRegular",
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 16,
                            height: SizeConfig.safeBlockVertical * 10,
                            //color: Colors.pinkAccent,
                            child: FlatButton(
                              color: Colors.blue,
                              onPressed: (){
                                _launchCaller(number);
                              },
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 16,
                                height: SizeConfig.safeBlockVertical * 10,
                                child: Center(
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 16,
                                    height: SizeConfig.safeBlockVertical * 8,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Llamar",
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "RobotoRegular",
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                )
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.safeBlockVertical * 26,
              color: Colors.white70,
              child: Center(
                child: Text(
                  "Cerrado \n horario: ${openHour}:00${this.getTimeState(openHour)}-${closeHour}:00${this.getTimeState(closeHour)}",
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontFamily: "RobotoRegular",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
      );
    }
  }

  getVeterinarias() {

    print("HOLAAAAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaaaaa");

    if (queryResult.length == 0 && this.continueAdding) {
      getInitialDocuments().then((QuerySnapshot snapshot) {
        for (int i = 0; i < snapshot.documents.length; i++) {
          print("*****************EL TAMAÑO DEL SNAPSHOT: ${snapshot.documents.length}");
          // print("LA CLASE ES : ${snapshot.documents[i].metadata}");
          //queryResult.add("dfaes");
          setState(() {
            contadorQuery=contadorQuery+1;
          });
          if(contadorQuery<=snapshot.documents.length){

            queryResult.add(snapshot.documents[i].data);
          }
        }
      });

    }else {
      if(this.continueAdding && contador<queryResult.length){
        temporalSearch = [];
        queryResult.forEach((element) {
          // print("SE SUPONE QUE ENTRE AQUI PARA EL QUERY DE LAS VETERINAIAS¡");
          //print("LAT DE LA VETERINARIA : ${element["latitude"]}");
          //print("LON DE LA VETERINARIA : ${element["longitude"]}");
          this.getDistance(this.userLocation.latitude, this.userLocation.longitude, element["latitude"], element["longitude"]).then((distance){
            print("ESTOY CUANDO MIRO LA DIFERNCIA DE DISTANCIAS");
            print("DIFERENCIA DE DISTANCIAS ${distance/1000}");
            print("DISTANCIAS EN METROS $distance");
            if((distance/1000)<4){
              print("¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡SE AGREGO LA VETERIANARIA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
              print("CONTADOR: ${this.contador}  QUERYLENGTH : ${this.queryResult.length}");
              if(contador<queryResult.length){
                setState(() {
                  this.continueAdding=false;
                  contador=contador+1;
                  temporalSearch.add(Veterinary(element["nombre"], element["latitude"], element["longitude"],
                      element["numero"],(distance/1000),element["image"],element["description"],element["openHour"],element["closeHour"]));
                });
              }
            }
          });
        });
      }
    }

  }
  Future <QuerySnapshot>getInitialDocuments(){
    return Firestore.instance.collection("veterinarias2").getDocuments();
  }

  _launchCaller(String walkerPhoneNumber) async {

    String url = "tel:$walkerPhoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getTimeState(int hour){
    if(hour>=12){
      return "pm";
    }else if(hour<12){
      return "am";
    }
  }

}

class Veterinary{
  String name;
  double lat;
  double long;
  String num;
  double distance;
  String image;
  String description;
  int openHour;
  int closeHour;
  Veterinary(this.name, this.lat,this.long, this.num,this.distance,this.image,this.description,this.openHour,this.closeHour);
}
