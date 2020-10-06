import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/Gmail_button.dart';
import 'package:fluppyclient/LogIn_screen.dart';
import 'package:fluppyclient/begin_store_screen.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/extra_info_gmail.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';


class BeginProductInfo extends StatefulWidget {

  String image;
  String productName;
  int price;
  int currentUnits;
  String productDescription;
  Map<String, Product>userProducts;
  String provider;
  String productId;
  BeginProductInfo({Key key, this.image,this.price,this.productName,this.currentUnits,this.productDescription,this.userProducts,this.provider,this.productId});
  @override
  _BeginProductInfo createState() => _BeginProductInfo();
}

class _BeginProductInfo extends State<BeginProductInfo> {
  UserBloc userBloc;
  String name,description,price, units;
  String priceWithComa;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  var _controllerPrice;
  var _controllerUnits;
  var _controllerDescription;
  String image="assets/FluppyPro.png";
  File imageFile;
  bool changeImage;
  int currentProductUnits;
  int currentPrice;
  Widget returnedWidget;
  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.imageFile=image;
      this.image = image.path;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: ${this.image}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentPrice=widget.price;
      priceWithComa=this.currentPrice.toString().replaceAllMapped(reg, mathFunc);
      currentProductUnits=1;
    });
    changeImage=false;
    _controllerPrice = TextEditingController(text: "${widget.price}");
    _controllerUnits = TextEditingController(text: "${widget.currentUnits}");
    _controllerDescription = TextEditingController(text: "${widget.productDescription}");
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return _handleCurrenSession();

  }


  Future<bool> validaBasesDatos(String id) async{
    bool exists=false;
    final snapShot = await Firestore.instance .collection('users') .document(id).get();
    if (snapShot == null || !snapShot.exists) {
      return exists;
    }else{
      setState(() {
        exists=true;
      });
      return exists;
    }
  }

  Widget _handleCurrenSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot contiene nuestros datos, nuestro objeto user traido de firebase
        if (!snapshot.hasData ||
            snapshot.hasError) { // si el snapshot no tiene datos o un error
          return productInfo();
        }
        else {
          validaBasesDatos(snapshot.data.uid).then((value){
            if(value==true){
              //print("ENTRE EN EL VERDADERO");
              setState(() {
                returnedWidget= HomeScreen();
              });
            }else {
              //print("ENTRE EN EL FALSO");
              if( snapshot.data.email==null || snapshot.data.uid==null || snapshot.data.photoUrl==null || snapshot.data.displayName==null){
                setState(() {
                  returnedWidget= HomeScreen();
                });
              }else{
                setState(() {
                  returnedWidget= ExtraInfoGmail(email: snapshot.data.email,id: snapshot.data.uid,photoUrl: snapshot.data.photoUrl,name: snapshot.data.displayName);
                });
              }
            }
          });
          if(returnedWidget!=null){
            return returnedWidget;
          }else {
            return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }


  Widget productInfo(){
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100 ,
                    height: SizeConfig.blockSizeVertical*40,
                    decoration: BoxDecoration(
                        color: Color(0xFF53d2be),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight:Radius.circular(40),
                        )
                    ),
                    child: Container(
                      child: Column(
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
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            Navigator.pop(context, MaterialPageRoute(builder: (context)=>BeginStoreScreen()));
                                          },
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,//Colors.white,
                                            size: SizeConfig.blockSizeVertical * 4,
                                          ),
                                        )
                                    )
                                ),
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*2,
                              //left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            height: SizeConfig.blockSizeVertical * 28,
                            //color: Colors.redAccent,
                            child: Center(
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal* 50,
                                  height: SizeConfig.blockSizeVertical * 28,
                                  //color: Colors.orange,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.image,
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.orange,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: SizeConfig.safeBlockHorizontal*2,
                        right: SizeConfig.safeBlockHorizontal*2
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical*2
                            ),
                            // color: Colors.orange,
                            width: SizeConfig.safeBlockHorizontal*100,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text("\$${this.priceWithComa} COP",
                                    style: TextStyle(
                                      color: Color(0xFFf05b00),
                                      fontSize: SizeConfig.safeBlockVertical*3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical*1
                          ),
                          // color: Colors.orange,
                          width: double.infinity,
                          child: Text(widget.productName,
                            style: TextStyle(
                              color: Color(0xFF53d2be),
                              fontSize: SizeConfig.safeBlockVertical*2.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical*1
                          ),
                          //color: Colors.red,
                          width: double.infinity,
                          child: Text("Descripción del producto",
                            style: TextStyle(
                              color: Color(0xFF211551),
                              fontSize: SizeConfig.safeBlockVertical*2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical*1
                          ),
                          //color: Colors.red,
                          height: SizeConfig.safeBlockVertical*18,
                          width: double.infinity,
                          child: Text(widget.productDescription,
                            style: TextStyle(
                              color: Color(0xFF211551),
                              fontSize: SizeConfig.safeBlockVertical*1.8,
                            ),
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
                            boxShadow: <BoxShadow>[
                              BoxShadow (
                                  color:  Color(0xFF53d2be),
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 0.2)
                              )
                            ],
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
                              boxShadow: <BoxShadow>[
                                BoxShadow (
                                    color:  Colors.green,
                                    blurRadius: 8.0,
                                    offset: Offset(0.0, 0.2)
                                )
                              ],
                            ),
                            child: GenericButton(
                              text: "Continuar con correo",
                              radius: 10,
                              textSize: SizeConfig.safeBlockHorizontal* 5,
                              width: SizeConfig.safeBlockHorizontal*4,
                              height: SizeConfig.safeBlockHorizontal* 15,
                              color:  Color(0xFF42E695) ,
                              textColor: Colors.white,
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>LogInScreen()));
                              },
                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal*4,
                              right: SizeConfig.blockSizeHorizontal*4,
                            ),
                            width: SizeConfig.safeBlockHorizontal*95,
                            height: SizeConfig.safeBlockHorizontal* 15,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow (
                                    color:  Colors.red,
                                    blurRadius: 8.0,
                                    offset: Offset(0.0, 0.2)
                                )
                              ],
                            ),
                            child: GmailButton(
                                onPresed: () {
                                  userBloc.signIn().then((FirebaseUser user){
                                    print("El usuario es ${user.displayName}");
                                  });
                                }
                            )
                        ),
                      ],
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