import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/confirmation_payment_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';


class UserShopRequests extends StatefulWidget {
  String userId;
  BuildContext mainContext;
  UserShopRequests({Key key, this.userId,this.mainContext});
  @override
  _UserShopRequests createState() => _UserShopRequests();
}

class _UserShopRequests extends State<UserShopRequests> {
  UserBloc userBloc;
  String name,description,price, units;
  var _controllerPrice;
  var _controllerUnits;
  var _controllerDescription;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  String image="assets/FluppyPro.png";
  File imageFile;
  bool changeImage;
  int total=0;
  bool continueAddingPrice=true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('usersProductsRequests').document(widget.userId).collection("PRODUCTS").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData || snapshot.data.documents.length==0){
              return Container(
                child: Column(
                children: <Widget>[
                  Container(
                    //color: Colors.pink,
                      margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical*4,
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
                              Navigator.of(context).pop(MaterialPageRoute(
                                  builder: (context) => StoreScreen(widget.userId,widget.mainContext)));
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF53d2be),
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                          )
                      )
                  ),
                  Container(
                    child:  Center(
                      child: Text("No hay solicitudes",
                        style: TextStyle(
                          color: Color(0xFFf05b00),
                          fontSize: SizeConfig.safeBlockVertical*2.5,
                        ),
                      ),
                    ),
                  )
                ],
                )
              );
            }else {
              return Container(
                //color: Colors.blueGrey,
                margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal*2,
                  right: SizeConfig.blockSizeHorizontal*2,
                ),
                width: SizeConfig.blockSizeHorizontal*100,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.pink,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*4,
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
                                  Navigator.of(context).pop(MaterialPageRoute(
                                      builder: (context) => StoreScreen(widget.userId,widget.mainContext)));
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF53d2be),
                                  size: SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical*2
                        ),
                        width: double.infinity,
                        height: SizeConfig.safeBlockVertical * 8,
                        //color: Colors.brown,
                        child: Text("Mis pedidos",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color:  Color(0xFF53d2be),
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: SizeConfig.safeBlockVertical * 45,
                          margin: EdgeInsets.only(
                              bottom: SizeConfig.safeBlockVertical*2
                          ),
                          // color: Colors.yellow,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF53d2be),width: SizeConfig.safeBlockHorizontal*1),
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, int index) {
                                return  productLayout( snapshot.data.documents[index].data['productName'], snapshot.data.documents[index].data['unitsRequested'],
                                    snapshot.data.documents[index].data['price'].toString(), snapshot.data.documents[index].data['image']);

                              }
                          )
                      ),
                      Container(
                        width: double.infinity,
                        height: SizeConfig.safeBlockVertical * 25,
                        //color: Colors.orange,
                        child: Column(
                          children: <Widget>[
                            handleTotalBill(widget.userId)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
      )


    );
  }




  Widget productLayout(String name, int units, String price, String image){
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.safeBlockHorizontal*2,
          right: SizeConfig.safeBlockHorizontal*2,
          bottom: SizeConfig.safeBlockVertical*2
      ),
      width: SizeConfig.safeBlockHorizontal*100,
      height: SizeConfig.safeBlockVertical * 13,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow (
              color:  Colors.black38,
              blurRadius: 8.0,
              offset: Offset(0.0, 0.2)
          )
        ],
        //border: Border.all(color: Colors.blueAccent),
        //borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      //color: Colors.green,
      child: Row(
        children: <Widget>[
         Container(
            width: SizeConfig.safeBlockHorizontal*20,
            height: SizeConfig.safeBlockVertical * 12,
            //color: Colors.red,
            child: CachedNetworkImage(imageUrl: image),
          ),
          VerticalDivider(
            width: SizeConfig.safeBlockHorizontal*1,
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal*42,
            height: SizeConfig.safeBlockVertical * 12,
            //color: Colors.cyan,
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.safeBlockHorizontal*47,
                  height: SizeConfig.safeBlockVertical * 9,
                  //color: Colors.blueGrey,
                  child: Text(name,
                    style: TextStyle(
                        color: Color(0xFF53d2be),
                        fontSize: SizeConfig.safeBlockVertical*1.8,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal*47,
                  height: SizeConfig.safeBlockVertical * 3,
                  //color: Colors.orange,
                  child: Text("Unidades: $units",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizeConfig.safeBlockVertical*1.8,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: SizeConfig.safeBlockHorizontal*26,
            height: SizeConfig.safeBlockVertical * 12,
            //color: Colors.deepPurple,
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.safeBlockHorizontal*39,
                  height: SizeConfig.safeBlockVertical * 4,
                  //color: Colors.cyan,
                  child: Text("\$${price.replaceAllMapped(reg, mathFunc)}",
                    style: TextStyle(
                        color: Color(0xFF53d2be),
                        fontSize: SizeConfig.safeBlockVertical*2,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget handleTotalBill(String userId){
    return StreamBuilder(
        stream: Firestore.instance.collection('usersProductsRequests').document(userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical * 13,
              //color: Colors.blue,
            );
          }else{
            return Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical * 20,
                //color: Colors.blue,
                //color: Colors.green,
                child:  Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 3,
                      //color: Colors.red,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.grey,
                            child: Text("Método de pago:",
                              style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*2,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.brown,
                            child: Text((snapshot.data["paymentMethod"]==0)? "Efectivo": "Datáfono",
                              style: TextStyle(
                                color: Color(0xFFf05b00),
                                fontSize: SizeConfig.safeBlockVertical*2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 4,
                      //color: Colors.brown,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.grey,
                            child: Text("Tiempo estimado:",
                              style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*2,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.brown,
                            child: Text("${snapshot.data["estimatedTime"]}",
                              style: TextStyle(
                                color: Color(0xFFf05b00),
                                fontSize: SizeConfig.safeBlockVertical*2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                          //////////////////////////////////////////////////////////////////////////////////////////////////
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 4,
                      //color: Colors.blue,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.grey,
                            child: Text("Total:",
                              style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*2,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal*48,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.brown,
                            child: Text("\$${snapshot.data["orderPrice"].toString().replaceAllMapped(reg, mathFunc)} COP",
                              style: TextStyle(
                                color: Color(0xFFf05b00),
                                fontSize: SizeConfig.safeBlockVertical*2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 6,
                      //color: Colors.brown,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal*25,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.grey,
                            child: Text("Dirección:",
                              style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*2,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal*71,
                            height: SizeConfig.safeBlockVertical * 12,
                            //color: Colors.brown,
                            child: Text("${snapshot.data["userAddres"]}",
                              style: TextStyle(
                                color: Color(0xFFf05b00),
                                fontSize: SizeConfig.safeBlockVertical*2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            );
          }
        }
    );
  }

}
