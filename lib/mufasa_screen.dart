import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/business_product_info_screen.dart';
import 'package:fluppyclient/cart_screen.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/personalize_mandi_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/product_info_screen.dart';
import 'package:fluppyclient/scale_route.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/support.dart';
import 'package:fluppyclient/user_shop_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class MufasaScreen extends StatefulWidget {
  String clientId;
  Map<String, Product> userProducts;
  BuildContext mainContext;
  String businessId;
  String businessName;
  String type;
  MufasaScreen(this.clientId,this.userProducts,this.mainContext,this.businessId,this.businessName,this.type);

  @override
  _MufasaScreen createState() => _MufasaScreen();
}

class _MufasaScreen extends State<MufasaScreen> {
  String _description;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  double _stars = 3;
  final formKey = GlobalKey<FormState>();
  //List<SnapshotMetadata> queryResult= new List<SnapshotMetadata>();
  var temporalSearch=[];
  var queryResult=[];
  String productName="";
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  double screenWidth;
  double screenHeight;
  String businessName;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;

    if((screenHeight<650)){
      return handleStore(SizeConfig.safeBlockHorizontal*18.5);
    }else if((screenHeight>650 && screenHeight<700)){
      return handleStore(SizeConfig.safeBlockHorizontal*17);
    }else if(screenHeight<812){
      return  handleStore(SizeConfig.safeBlockHorizontal*15.5);
    }else if(screenHeight<850){
      return  handleStore(SizeConfig.safeBlockHorizontal*14);
    }else {
      return  handleStore(SizeConfig.safeBlockHorizontal*12);
    }
  }

  Widget handleStore(double cardHeight){
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,widget.userProducts);
      },
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child: Container(
              // height: SizeConfig.blockSizeVertical*200,
              child: Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100 ,
                    height: SizeConfig.blockSizeVertical*30,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow (
                            color: Colors.blueGrey,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 0.2)
                        )
                      ],
                    ),
                    child: Container(
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
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
                                                  Navigator.pop(context,widget.userProducts);
                                                },
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color: Color(0xFFfde9eb),//Colors.white,
                                                  size: SizeConfig.blockSizeVertical * 4,
                                                ),
                                              )
                                          )
                                      ),
                                    )
                                ),
                                Container(
                                  width: SizeConfig.blockSizeHorizontal*100 ,
                                  height: SizeConfig.blockSizeVertical*18,
                                  decoration: BoxDecoration(
                                    //color: Colors.blue,//Color(0xFFfde9eb),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: "https://static.wixstatic.com/media/07fea2_8c3c62fd036e4695af8555ee8e087f50~mv2.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),
                  Container(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                              width: SizeConfig.blockSizeHorizontal*95,
                              //color: Colors.amber,
                              child:  Column(
                                children: <Widget>[
                                  Container(
                                      width: SizeConfig.safeBlockHorizontal*95,
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockVertical*2,
                                        bottom: SizeConfig.safeBlockVertical*1,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: SizeConfig.safeBlockVertical*1
                                            ),
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Comedores",
                                                style: TextStyle(
                                                  color: Color(0xFF211551),
                                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                                  fontFamily: "RobotoRegular",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: SizeConfig.blockSizeHorizontal*95,
                                            height: SizeConfig.safeBlockVertical * 26,
                                            //color: Colors.orange,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  width: SizeConfig.blockSizeHorizontal*100 ,
                                                  height: SizeConfig.blockSizeVertical*25,
                                                  child: StreamBuilder(
                                                      stream: Firestore.instance.collection('businessesProducts').document(widget.businessId).collection("${widget.businessName}Comedores${widget.type}").snapshots(),
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
                                                          return Container(
                                                            width: SizeConfig.blockSizeHorizontal*95,
                                                            height: SizeConfig.safeBlockVertical * 25,
                                                            // color: Colors.blue,
                                                            child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: snapshot.data.documents.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  buildResultCard2(snapshot.data.documents[index].data["productName"],snapshot.data.documents[index].data["image"]
                                                                    ,snapshot.data.documents[index].data["price"],
                                                                    snapshot.data.documents[index].data["existingUnits"],
                                                                    snapshot.data.documents[index].data["description"],
                                                                    cardHeight,snapshot.data.documents[index].data["provider"],
                                                                    snapshot.data.documents[index].data["id"],snapshot.data.documents[index].data["productCost"],
                                                                    snapshot.data.documents[index].data["category"]
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      }
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),


                                  Container(
                                      width: SizeConfig.safeBlockHorizontal*95,
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockVertical*2,
                                        bottom: SizeConfig.safeBlockVertical*1,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: SizeConfig.safeBlockVertical*1
                                            ),
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Camas",
                                                style: TextStyle(
                                                  color: Color(0xFF211551),
                                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                                  fontFamily: "RobotoRegular",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: SizeConfig.blockSizeHorizontal*95,
                                            height: SizeConfig.safeBlockVertical * 26,
                                            //color: Colors.orange,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  width: SizeConfig.blockSizeHorizontal*100 ,
                                                  height: SizeConfig.blockSizeVertical*25,
                                                  child: StreamBuilder(
                                                      stream: Firestore.instance.collection('businessesProducts').document(widget.businessId).collection("${widget.businessName}Camas${widget.type}").snapshots(),
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
                                                          return Container(
                                                            width: SizeConfig.blockSizeHorizontal*95,
                                                            height: SizeConfig.safeBlockVertical * 25,
                                                            // color: Colors.blue,
                                                            child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              itemCount: snapshot.data.documents.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  buildResultCard2(snapshot.data.documents[index].data["productName"],snapshot.data.documents[index].data["image"]
                                                                    ,snapshot.data.documents[index].data["price"],
                                                                    snapshot.data.documents[index].data["existingUnits"],
                                                                    snapshot.data.documents[index].data["description"],
                                                                    cardHeight,snapshot.data.documents[index].data["provider"],
                                                                    snapshot.data.documents[index].data["id"],snapshot.data.documents[index].data["productCost"],
                                                                    snapshot.data.documents[index].data["category"]
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      }
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              )
                          ),
                        ),

                        Container(
                          width: SizeConfig.blockSizeHorizontal*95,
                          height: SizeConfig.blockSizeVertical*63,
                          child:   Align(
                            alignment: Alignment.bottomRight,
                            child:   Container(
                                width: SizeConfig.blockSizeHorizontal*15,
                                height: SizeConfig.blockSizeHorizontal*15,
                                decoration: BoxDecoration(
                                    color: Color(0xFFf05b00),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                                child: RaisedButton(
                                    onPressed: (){
                                      print("**********MI CARRO *******************************");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> CartScreen(
                                              userId: widget.clientId,userProduct: widget.userProducts,storeType: "perro",mainContext: widget.mainContext
                                          ))).then((userProductList) {
                                        setState(() {
                                          widget.userProducts=userProductList;
                                        });
                                      });

                                    },
                                    color: Color(0xFFf05b00),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: SizeConfig.safeBlockVertical*0.5
                                            ),
                                            width: SizeConfig.blockSizeHorizontal*95,
                                            height: SizeConfig.blockSizeVertical*2,
                                            //color: Colors.greenAccent,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                "${widget.userProducts.length}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig.safeBlockVertical*2
                                                ),
                                              ),
                                            )
                                        ),
                                        Container(
                                          width: SizeConfig.blockSizeHorizontal*95,
                                          height: SizeConfig.blockSizeVertical*4,
                                          //color: Colors.amber,
                                          child: Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                            size: SizeConfig.safeBlockVertical*4,
                                          ),
                                        )
                                      ],
                                    )
                                )
                            ),
                          ),
                        )


                      ],
                    )
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }


  Future <QuerySnapshot>getInitialDocuments(){
    return Firestore.instance.collection("concentrados").getDocuments();
  }


  Widget buildResultCard2(String productName, String image,int productPrice, int productUnits,
      String description, double cardHeight, String provider, String productId, int productCost,String category) {
    return Container(
      margin: EdgeInsets.only(
          right: SizeConfig.blockSizeHorizontal*5
      ),
      width: SizeConfig.blockSizeHorizontal*40,
      height: SizeConfig.blockSizeVertical*18,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: (productUnits==0)? Colors.grey : Colors.blueGrey,)
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: SizeConfig.blockSizeHorizontal*40,
            height: SizeConfig.blockSizeVertical*12.9,
            //color: Colors.red,
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal*40,
            height: SizeConfig.blockSizeVertical*5,
            //color: Colors.grey[300],
            child: Text(productName,
              style: TextStyle(
                  color:Color(0xFF211551),
                  fontSize: SizeConfig.blockSizeVertical*1.4,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: (productUnits==0)? Colors.grey : Colors.blueGrey,
              ),
              width: double.infinity,
              height: cardHeight,
              child:  ButtonTheme(
                minWidth: 50,
                height: 30,
                child: RaisedButton(
                    onPressed: (){
                      if(productUnits==0){
                        Fluttertoast.showToast(
                            msg: "Producto agotado",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.grey,
                            timeInSecForIos: 2);
                      }else{

                        Navigator.push(
                            context, ScaleRoute(page: BusinessProductInfo(userId: widget.clientId,
                          price: productPrice,currentUnits: productUnits,
                          productName: productName,
                          productDescription: description,image:image ,
                          userProducts: widget.userProducts,provider: provider,
                          providerId: widget.businessId,
                          productId: productId,productCost: productCost,category: category,productBackgroundColor:  Colors.blueGrey,
                        ))).then((userProductList) {
                          setState(() {
                            widget.userProducts=userProductList;
                          });
                        });
                        print("LO QUIERO");
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: (productUnits==0)? Colors.grey : Colors.blueGrey,
                    child: Center(
                        child: Container(
                            child: Container(
                                height: SizeConfig.safeBlockHorizontal*10,
                                //color: Colors.amber,
                                alignment: Alignment.center,
                                child:  (productUnits==0) ?
                                Text(
                                  "Agotado",
                                  style: TextStyle(
                                      fontFamily: "RobotoRegular",
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                )
                                    :
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                     productName.contains("Personalizado")?Container(): Text(
                                       "\$${productPrice.toString().replaceAllMapped(reg, mathFunc)}",
                                       style: TextStyle(
                                           fontFamily: "RobotoRegular",
                                           fontSize: 15,
                                           //fontWeight: FontWeight.bold,
                                           color: Colors.white
                                       ),
                                     ),
                                      productName.contains("Personalizado")?
                                      Text(
                                        "(ver)",
                                        style: TextStyle(
                                            fontFamily: "RobotoRegular",
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ):
                                      Text(
                                        "(ver)",
                                        style: TextStyle(
                                            fontFamily: "RobotoRegular",
                                            fontSize: 12,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            )
                        )
                    )
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget LargeoptionButton(String title, String image, Color background,VoidCallback onPressed){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*95,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child:  Material(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: background,
          child: InkWell(
            onTap: onPressed,
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal*95,
                height: SizeConfig.safeBlockVertical*20,
                child:  Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child:  Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal*95,
                        height: SizeConfig.safeBlockVertical*20,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*12,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*85,
                      height: SizeConfig.safeBlockVertical*5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  Widget ShortoptionButton(String title, String image, Color background,VoidCallback onPressed){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*45,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child:  Material(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: background,
          child: InkWell(
            onTap: onPressed,
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal*95,
                height: SizeConfig.safeBlockVertical*20,
                child:  Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child:  Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal*95,
                        height: SizeConfig.safeBlockVertical*20,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*12,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*85,
                      height: SizeConfig.safeBlockVertical*5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
