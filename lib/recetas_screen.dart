import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/como_llegar_veterinaria_screen.dart';
import 'package:fluppyclient/fluppy_icons_icons.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/receta_layout.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/size_route.dart';
import 'package:fluppyclient/veterinarias_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class RecetasScreen extends StatefulWidget {
  @override
  _RecetasScreen createState() => _RecetasScreen();
}

class _RecetasScreen extends State<RecetasScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        //color: Colors.red,
        child: Column(
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.safeBlockVertical * 25,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  )
              ),
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
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.safeBlockVertical * 15,
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Container(
                            width: SizeConfig.blockSizeHorizontal*20,
                            height: SizeConfig.safeBlockVertical * 5,
                            //color: Colors.yellow,
                            child: CachedNetworkImage(
                              imageUrl: "https://static.wixstatic.com/media/07fea2_a9773a483c5744de9a683361e954e9c3~mv2.png",
                              fit: BoxFit.fitHeight,
                            )
                        ),
                        Container(
                            width: SizeConfig.blockSizeHorizontal*75,
                            height: SizeConfig.safeBlockVertical * 8,
                            //color: Colors.brown,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text("Recetas",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*3.5),),
                                  Text("¡Cocina junto a tu peludo!",style: TextStyle(color: Colors.white,fontSize: SizeConfig.safeBlockVertical*2),textAlign: TextAlign.start,)
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            Container(
              width: SizeConfig.blockSizeHorizontal*95,
              height: SizeConfig.blockSizeVertical*68,
              child:   StreamBuilder(
                  stream: Firestore.instance.collection("recetas").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(!snapshot.hasData){
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
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,mainAxisSpacing: 20, crossAxisSpacing: 20,childAspectRatio: 1),
                        itemCount: snapshot.data.documents.length,
                        padding: EdgeInsets.all(3.0),
                        itemBuilder: (BuildContext context, int index) {
                          return this.recetaButton(
                            snapshot.data.documents[index].data["name"],
                            snapshot.data.documents[index].data["backgroundImage"],
                            snapshot.data.documents[index].data["image"],
                            snapshot.data.documents[index].data["type"],
                            snapshot.data.documents[index].data["description"],
                          );
//String name, String backgroundImage, String recetaImage, String type
                          /*return ProductCardLayout(
                                      productName:snapshot.data.documents[index].data["productName"],
                                      image:snapshot.data.documents[index].data["image"],
                                      productPrice: snapshot.data.documents[index].data["price"],
                                      productUnits: snapshot.data.documents[index].data["existingUnits"],
                                      description: snapshot.data.documents[index].data["description"],
                                      cardHeight :cardHeight,
                                      provider:snapshot.data.documents[index].data["provider"],
                                      productId: snapshot.data.documents[index].data["id"],
                                      productCost:snapshot.data.documents[index].data["productCost"],
                                      category:snapshot.data.documents[index].data["category"],
                                      discount:snapshot.data.documents[index].data["discount"],
                                      clientId:widget.clientId,
                                      userProducts:widget.userProducts,
                                      data:null
                                  );*/


                        },
                      );
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget optionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        margin: EdgeInsets.only(
            top: SizeConfig.safeBlockVertical*2
        ),
        width: SizeConfig.safeBlockHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Material(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: background,
          child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.purple,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: SizeConfig.safeBlockHorizontal * 100,
                    height: SizeConfig.safeBlockVertical * 15,
                    child: Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 1,
                          child: Container(
                            //color: Colors.green,
                            width: SizeConfig.safeBlockHorizontal * 100,
                            height: SizeConfig.safeBlockVertical * 8,
                            child: CachedNetworkImage(
                              imageUrl: image,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Container(
                          //color: Colors.green,
                            width: SizeConfig.safeBlockHorizontal * 85,
                            height: SizeConfig.safeBlockVertical * 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(title,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical*2.3,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        )
                      ],
                    )
                ),
              )
          ),
        )
    );
  }

  Widget recetaButton(String name, String backgroundImage, String recetaImage, String type,String description){
    return Container(
      //color: Colors.green,
      child: RaisedButton(
        color: Colors.deepOrange,
        padding: EdgeInsets.all(0),
        child: Stack(
          children: [
            Container(
              width: SizeConfig.safeBlockHorizontal *100,
              height: SizeConfig.safeBlockVertical * 25,
              //color: Colors.orange,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      backgroundImage
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect( // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal*50,
              height: SizeConfig.safeBlockVertical*4,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    )
                ),
              margin: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal*30
              ),
              child: type.toLowerCase()=="perro"? Icon(FluppyIcons.dogcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*3,)
                  : type.toLowerCase()=="gato"? Icon(FluppyIcons.catcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*3,)
                  : Align(
                alignment: Alignment.center,
                child: Container(
                  width: SizeConfig.safeBlockHorizontal*12,
                  child: Row(
                    children: [
                      Icon(FluppyIcons.dogcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*3,),
                      Icon(FluppyIcons.catcoin, color: Colors.white,size: SizeConfig.safeBlockVertical*3,)
                    ],
                  ),
                )
              )
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal*40,
              height: SizeConfig.safeBlockVertical*5,
              margin: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical*16
              ),
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  )
              ),
              child: Text(name,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical*1.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "RobotoRegular",
                ),
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
        onPressed: (){
          Navigator.push(
              context, SizeRoute(page: RecetaLayout(name: name,backgroundImage: backgroundImage,recetaImage: recetaImage,description: description,type: type,)
          ));
        },
      )
    );
  }
}