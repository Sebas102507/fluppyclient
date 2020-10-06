import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/cart_screen.dart';
import 'package:fluppyclient/category_layout_screen.dart';
import 'package:fluppyclient/deli_dog_screen.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/mufasa_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/product_card_layout.dart';
import 'package:fluppyclient/product_info_screen.dart';
import 'package:fluppyclient/pup_cakes_screen.dart';
import 'package:fluppyclient/scale_route.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user_shop_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';


class StoreScreen extends StatefulWidget {
  String clientId;
  BuildContext mainContext;
  StoreScreen(this.clientId,this.mainContext);

  @override
  _StoreScreen createState() => _StoreScreen();
}

class _StoreScreen extends State<StoreScreen> {
  String _description;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  double _stars = 3;
  final formKey = GlobalKey<FormState>();
  //List<SnapshotMetadata> queryResult= new List<SnapshotMetadata>();
  var temporalSearch=[];
  var queryResult=[];
  String productName="";
  Map<String, Product> userProducts;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  double screenWidth;
  double screenHeight;
  int option=-1;
  Position userLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProducts= new Map<String, Product>();
    });
  }
  searchProduct(value) {
    if (value.length == 0) {
      setState(() {
        temporalSearch=[];
        queryResult=[];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResult.length == 0 && value.length == 1) {
      getInitialDocuments().then((QuerySnapshot snapshot){
        for(int i=0; i< snapshot.documents.length;i++){
          print("EL TAMAÑO DEL SNAPSHOT: ${snapshot.documents.length}");
          // print("LA CLASE ES : ${snapshot.documents[i].metadata}");
          //queryResult.add("dfaes");
          queryResult.add(snapshot.documents[i].data);
        }
      });
    } else {
      temporalSearch= [];
      queryResult.forEach((element) {
        if ((element['productName'].toUpperCase()).contains(capitalizedValue.toUpperCase())) {
          setState(() {
            temporalSearch.add(element);
          });
        }
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    //SizeConfig.blockSizeVertical*18,
    return handlePetType();
  }

  Widget handleStore(double cardHeight){
    return Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*100 ,
                  height: SizeConfig.blockSizeVertical*30,
                  decoration: BoxDecoration(
                      color: Color(0xFF53d2be),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
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
                                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            //color: Colors.redAccent,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("¿Qué deseas para tu perro?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical*3,
                                    fontFamily: "RobotoRegular",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            height: SizeConfig.blockSizeVertical*6,
                            //color: Colors.blueGrey,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Busca lo que necesitas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        ),


                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal*75,
                                height: SizeConfig.safeBlockHorizontal*16,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  /* boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(-10.0, 1.0)
                                      )
                                    ],*/
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)
                                  ),
                                  //color: Colors.deepPurple,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*5,
                                    left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  height: SizeConfig.safeBlockVertical * 8,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(80)
                                    ),
                                    //color: Colors.deepPurple,
                                  ),
                                  child: TextFormField(
                                    controller: _controllerSuggestion,
                                    maxLines: 12,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Campo inválido";
                                      }
                                      return null;
                                    },
                                    onChanged: (productName){
                                      setState(() {
                                        this.productName=productName;
                                      });
                                      searchProduct(productName);
                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search,color: Color(0xFF53d2be),),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Buscar",
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                //color: Colors.blueGrey,
                                width: SizeConfig.blockSizeHorizontal*20,
                                height: SizeConfig.safeBlockHorizontal*16,
                                margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*2,
                                  right: SizeConfig.blockSizeHorizontal*2,
                                ),
                                decoration: BoxDecoration(
                                  /*boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],*/
                                ),
                                child: Center(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: SizeConfig.blockSizeHorizontal*18,
                                              height: SizeConfig.safeBlockHorizontal*16,
                                              child: RaisedButton(
                                                onPressed: (){

                                                 print("**********MIS PEDIDOS*******************************");
                                                  mostrarProductos();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context)=> UserShopRequests(userId: widget.clientId)));
                                                },
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                color: Colors.white,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text("Mis pedidos",
                                                      style: TextStyle(
                                                        color: Color(0xFF53d2be),
                                                        fontSize: SizeConfig.blockSizeVertical*1.2,
                                                        fontFamily: "RobotoRegular",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Icon(
                                                      Icons.check_circle_outline,
                                                      color: Color(0xFF53d2be),
                                                      size: SizeConfig.blockSizeVertical*3,
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                (this.productName==null || this.productName=="") ?
                storeBegin()
                    :
                Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical*68,
                    child: Stack(
                      children: <Widget>[
                        GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                            padding: EdgeInsets.all(2.0),
                            primary: false,
                            shrinkWrap: true,
                            children: temporalSearch.map((element) {
                              return ProductCardLayout(
                                  productName: null,
                                  image:null,
                                  productPrice: null,
                                  productUnits:null,
                                  description: null,
                                  cardHeight :cardHeight+SizeConfig.safeBlockVertical*1.5,
                                  provider:null,
                                  productId: null,
                                  productCost:null,
                                  category:null,
                                  discount:null,
                                  clientId:widget.clientId,
                                  userProducts: this.userProducts,
                                  data:element
                              );
                            }).toList()),
                        Container(
                          width: SizeConfig.blockSizeHorizontal*95,
                          height: SizeConfig.blockSizeVertical*60,
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
                                      mostrarProductos();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> CartScreen(
                                            userId: widget.clientId,userProduct: this.userProducts,mainContext: widget.mainContext,storeType: "perro",
                                          )))..then((userProductList) {
                                        setState(() {
                                          this.userProducts=userProductList;
                                        });
                                      });

                                    },
                                    color: this.userProducts.length==0 ?  Color(0xFFf05b00): Color(0xFFf05b00),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),
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
                                                "${this.userProducts.length}",
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
                        /*
                               * IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){

                               },
                                 color: Colors.deepPurpleAccent,
                               )
                               * */
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }

  Widget handleCatStore(double cardHeight){
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*100 ,
                  height: SizeConfig.blockSizeVertical*30,
                  decoration: BoxDecoration(
                      color: Color(0xFF53d2be),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
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
                                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            //color: Colors.redAccent,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("¿Qué deseas para tu gato?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical*3,
                                    fontFamily: "RobotoRegular",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            height: SizeConfig.blockSizeVertical*6,
                            //color: Colors.blueGrey,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Busca lo que necesitas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        ),


                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal*75,
                                height: SizeConfig.safeBlockHorizontal*16,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  /* boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(-10.0, 1.0)
                                      )
                                    ],*/
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)
                                  ),
                                  //color: Colors.deepPurple,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*5,
                                    left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  height: SizeConfig.safeBlockVertical * 8,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(80)
                                    ),
                                    //color: Colors.deepPurple,
                                  ),
                                  child: TextFormField(
                                    controller: _controllerSuggestion,
                                    maxLines: 12,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Campo inválido";
                                      }
                                      return null;
                                    },
                                    onChanged: (productName){
                                      setState(() {
                                        this.productName=productName;
                                      });
                                      searchProduct(productName);
                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search,color: Color(0xFF53d2be),),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Buscar",
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                //color: Colors.blueGrey,
                                width: SizeConfig.blockSizeHorizontal*20,
                                height: SizeConfig.safeBlockHorizontal*16,
                                margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*2,
                                  right: SizeConfig.blockSizeHorizontal*2,
                                ),
                                decoration: BoxDecoration(
                                  /*boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],*/
                                ),
                                child: Center(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: SizeConfig.blockSizeHorizontal*18,
                                              height: SizeConfig.safeBlockHorizontal*16,
                                              child: RaisedButton(
                                                onPressed: (){
                                                  print("**********MIS PEDIDOS*******************************");
                                                  mostrarProductos();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context)=> UserShopRequests(userId: widget.clientId)));
                                                },
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                color: Colors.white,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text("Mis pedidos",
                                                      style: TextStyle(
                                                        color: Color(0xFF53d2be),
                                                        fontSize: SizeConfig.blockSizeVertical*1.2,
                                                        fontFamily: "RobotoRegular",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Icon(
                                                      Icons.check_circle_outline,
                                                      color: Color(0xFF53d2be),
                                                      size: SizeConfig.blockSizeVertical*3,
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                (this.productName==null || this.productName=="") ?
                storeBeginCat()
                    :
                Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical*68,
                    child: Stack(
                      children: <Widget>[
                        GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                            padding: EdgeInsets.all(2.0),
                            primary: false,
                            shrinkWrap: true,
                            children: temporalSearch.map((element) {
                              return ProductCardLayout(
                                  productName: null,
                                  image:null,
                                  productPrice: null,
                                  productUnits:null,
                                  description: null,
                                  cardHeight :cardHeight+SizeConfig.safeBlockVertical*1.5,
                                  provider:null,
                                  productId: null,
                                  productCost:null,
                                  category:null,
                                  discount:null,
                                  clientId:widget.clientId,
                                  userProducts:this.userProducts,
                                  data:element
                              );
                            }).toList()),
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
                                      mostrarProductos();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context)=> CartScreen(userId: widget.clientId,
                                              userProduct: this.userProducts,storeType: "gato"
                                          ))).then((userProductList) {
                                        setState(() {
                                          this.userProducts=userProductList;
                                        });
                                      });

                                    },
                                    color: Color(0xFFf05b00),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),
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
                                                "${this.userProducts.length}",
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
                        /*
                               * IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){

                               },
                                 color: Colors.deepPurpleAccent,
                               )
                               * */
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }



  Future <QuerySnapshot>getInitialDocuments(){
    if(this.option==0){
      return Firestore.instance.collection("productStore").getDocuments();
    }else{
      return Firestore.instance.collection("productStoreCat").getDocuments();
    }
  }

  Widget buildResultCard(data, double cardHeight) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),)),
        elevation: 2.0,
        child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*48,
                  height: SizeConfig.blockSizeVertical*18,
                  //color: Colors.deepOrange,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal*45,
                              height: SizeConfig.blockSizeVertical*14,
                              child: CachedNetworkImage(
                                imageUrl: data["image"],
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            (data["discount"]==0 || data["discount"]==null )?
                            Container(
                              width: SizeConfig.blockSizeHorizontal*10,
                              height: SizeConfig.blockSizeVertical*5,
                            )
                                :
                            Container(
                              width: SizeConfig.blockSizeHorizontal*10,
                              height: SizeConfig.blockSizeVertical*5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text("-${data["discount"]}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*1.4),),
                              ),
                            )
                          ],
                        ),
                        Container(
                            width: SizeConfig.blockSizeHorizontal*48,
                            height: SizeConfig.blockSizeVertical*4,
                            color: Colors.grey[200],
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*1
                              ),
                              child: Text(data["productName"],
                                style: TextStyle(
                                    color:Color(0xFF211551),
                                    fontSize: SizeConfig.blockSizeVertical*1.3,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),
                    ),
                    width: double.infinity,
                    height: cardHeight,
                    child:  ButtonTheme(
                      minWidth: 50,
                      height: 30,
                      child: RaisedButton(
                          onPressed: (){
                            if(data["existingUnits"]==0){
                              Fluttertoast.showToast(
                                  msg: "Producto agotado",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.grey,
                                  timeInSecForIos: 2);
                            }else{
                              Navigator.push(
                                  context, ScaleRoute(page: ProductInfo(userId: widget.clientId,
                                price: data["price"],currentUnits: data["existingUnits"],
                                productName: data["productName"],
                                productDescription: data["description"],image:data["image"] ,
                                userProducts: this.userProducts,provider: data["provider"],
                                productId: data["id"],productCost: data["productCost"],category: data["category"],productBackgroundColor: Color(0xFF53d2be),discount: (data["discount"]==null)?0:data["discount"],
                              ))).then((userProductList) {
                                setState(() {
                                  this.userProducts=userProductList;
                                });
                              });
                              print("LO QUIERO");
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),
                          child: Center(
                              child: Container(
                                  child: Container(
                                      height: SizeConfig.safeBlockHorizontal*10,
                                      //color: Colors.amber,
                                      alignment: Alignment.center,
                                      child:  (data["existingUnits"]==0) ?
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
                                      (data["discount"]==0 || data["discount"]==null)?
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${data["price"].toString().replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                            Text(
                                              "(ver)",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 12,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      :
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${data["price"].toString().replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  decoration: TextDecoration.lineThrough
                                              ),
                                            ),
                                            Text(
                                              "\$${(data["price"]*(1-(data["discount"]/100))).round().toString().replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                fontFamily: "RobotoRegular",
                                                fontSize: 15,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
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
            )
        )
    );

  }

  void mostrarProductos(){
    this.userProducts.forEach((String key, Product product){
      print("${product.productName}");
      print("${product.price}");
      print("${product.units}");
      print("${product.image}");
    });
  }


  Widget LargeoptionButton(String title, String image, Color background,VoidCallback onPressed,Color textColor){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*95,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  background,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.2)
            )
          ],
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
                          top: SizeConfig.safeBlockVertical*10,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*40,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: textColor,
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

  Widget middleOptionButton(String title, String image, Color background,VoidCallback onPressed,Color textColor){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*75,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  background,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.2)
            )
          ],
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
                          top: SizeConfig.safeBlockVertical*10,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*40,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
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

  Widget newOptionButton(String title, String image, Color background,VoidCallback onPressed,Color textColor){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*80,
        height: SizeConfig.safeBlockVertical*22,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  background,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.2)
            )
          ],
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
                height: SizeConfig.safeBlockVertical*22,
                child:  Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child:  Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal*95,
                        height: SizeConfig.safeBlockVertical*22,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*10,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*40,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
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
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  background,
                blurRadius: 8.0,
                offset: Offset(0.0, 0.2)
            )
          ],
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
                     // color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*30,
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

  Widget storeBegin(){
    return Container(
        width: SizeConfig.blockSizeHorizontal*100,
        height: SizeConfig.blockSizeVertical*68,
        //color: Colors.black,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal*95,
                    margin: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical*2,
                      bottom: SizeConfig.safeBlockVertical*1,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Nuevo",
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
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical*22,
                    //color: Colors.red,
                    child: CarouselSlider(
                      options: CarouselOptions(
                       enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        initialPage: 0,
                        enableInfiniteScroll: true
                      ),
                      items: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockHorizontal*2,

                            ),
                            child:  newOptionButton("Pastelería y accesorios", "https://static.wixstatic.com/media/07fea2_30d128afb84045ff80d5f7abd80e3e29~mv2.png",Color(0xFF7cdde9),(){
                              print("Comedores");
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>PupCakeScreen(widget.clientId,this.userProducts,widget.mainContext,"9rEEQebs87VQ5WOEPsND02o7HN92","PupCakes","Perro"))).then((userProductList) {
                                setState(() {
                                  this.userProducts=userProductList;
                                });
                              });
                            }, Colors.white)
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockHorizontal*2,

                            ),
                            child:  newOptionButton("Comedores y camas", "https://static.wixstatic.com/media/07fea2_49bd4e1a9b8f4a0183a6830a7b9a13fc~mv2.png",Colors.blueGrey,(){
                              print("Comedores");
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>MufasaScreen(widget.clientId,this.userProducts,widget.mainContext,"fjxDO6u3cafsvVziyR9sbBcBpYj2","Mufasa","Perro"))).then((userProductList) {
                                setState(() {
                                  this.userProducts=userProductList;
                                });
                              });
                            }, Colors.white)
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockHorizontal*2,

                            ),
                            child:  newOptionButton("Boutique y pastelería", "https://static.wixstatic.com/media/07fea2_6f5c561c0d6a4935a51241131aebc087~mv2.png",Color(0xFFeba1ba),(){
                              print("Comedores");
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>DeliDogScreen(widget.clientId,this.userProducts,widget.mainContext,"ZlJQxlIrR5TrWGI1ggSW0HISXie2","DogDeli","Perro")))..then((userProductList) {
                                setState(() {
                                  this.userProducts=userProductList;
                                });
                              });
                            }, Colors.white)
                        ),

                        /*Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockHorizontal*2,
                              left: SizeConfig.blockSizeHorizontal*2,
                              right:  SizeConfig.blockSizeHorizontal*2,
                            ),
                            child:  middleOptionButton("Comedores personalizados", "https://static.wixstatic.com/media/07fea2_4e49bc2027114703ac8ac70f77b8877e~mv2.png",Color(0xFFfde9eb),(){
                              print("Comedores");
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>MandiScreen(widget.clientId,this.userProducts,widget.mainContext,"3I0SrbilrehbmbB4L2jJSnHaeVq1","Mandi","Perro")));
                            }, Colors.black)
                        ),*/

                      ],
                    )
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Alimentación",
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
                            width: SizeConfig.blockSizeHorizontal*100,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.red,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Concentrados","https://static.wixstatic.com/media/07fea2_81b9624eca4f48b491b77ebfeb944597~mv2.png",Colors.deepOrange,(){
                                        print("Concentrados");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"concentrados","perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Colors.white)
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Snacks", "https://static.wixstatic.com/media/07fea2_4489ad2f0f99463b83a0d1b5be02d76a~mv2.png",Colors.lightGreenAccent,(){
                                        print("Snacks");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"snacks","perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Color(0xFF211551),)
                                  ),
                                  Container(

                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Alimentos húmedos", "https://static.wixstatic.com/media/07fea2_354fd16b280e44a783d3af53cf7f41ef~mv2.png",Colors.redAccent,(){
                                        print("Comedores");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"alimentoHumedo","perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });


                                      }, Colors.white)
                                  ),

                                ],
                              ),
                            )
                        ),

                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Limpieza",
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
                          width: SizeConfig.safeBlockHorizontal*95,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockHorizontal*2,
                                ),
                                child:  middleOptionButton("Aseo y limpieza", "https://static.wixstatic.com/media/07fea2_2241f1b1314b41e6b11c08c63fbff98c~mv2.png",Color(0xFF53d2be),(){
                                  print("Aseo y cuidado");
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"aseo","perro"))).then((userProductList) {
                                    setState(() {
                                      this.userProducts=userProductList;
                                    });
                                  });
                                },Colors.white)
                            ),
                          ),
                        ),

                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Accesorios",
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
                            width: SizeConfig.blockSizeHorizontal*100,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.red,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child: middleOptionButton("Accesorios y juguetes", "https://static.wixstatic.com/media/07fea2_f8bb90130376465c81e4a067785aa3cc~mv2.png",Colors.amber,(){
                                        print("Tips");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"accesorios","perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      },Colors.white)
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child: newOptionButton("Comedores y camas", "https://static.wixstatic.com/media/07fea2_49bd4e1a9b8f4a0183a6830a7b9a13fc~mv2.png",Colors.blueGrey,(){
                                        print("Comedores");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>MufasaScreen(widget.clientId,this.userProducts,widget.mainContext,"fjxDO6u3cafsvVziyR9sbBcBpYj2","Mufasa","Perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Colors.white)
                                  ),

                                ],
                              ),
                            )
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Salud",
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
                          width: SizeConfig.safeBlockHorizontal*95,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockHorizontal*2,
                                ),
                                child:  middleOptionButton("Cuidado y salud", "https://static.wixstatic.com/media/07fea2_85d8b6819ac14a578bf153eb794c72d7~mv2.png",Colors.pinkAccent,(){
                                  print("Tips");
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"salud","perro"))).then((userProductList) {
                                    setState(() {
                                      this.userProducts=userProductList;
                                    });
                                  });
                                },Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          height: SizeConfig.safeBlockVertical*2,
                        ),
                      ],
                    ),
                  )
                ],
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
                          mostrarProductos();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> CartScreen(
                                userId: widget.clientId,userProduct: this.userProducts,storeType: "perro",mainContext: widget.mainContext
                              ))).then((userProductList) {
                            setState(() {
                              this.userProducts=userProductList;
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
                                    "${this.userProducts.length}",
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
    );
  }




  Widget storeBeginCat(){
    return Container(
        width: SizeConfig.blockSizeHorizontal*100,
        height: SizeConfig.blockSizeVertical*68,
        //color: Colors.amber,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal*95,
                    margin: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical*2,
                      bottom: SizeConfig.safeBlockVertical*1,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Nuevo",
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
                      width: SizeConfig.blockSizeHorizontal*100,
                      height: SizeConfig.blockSizeVertical*22,
                      //color: Colors.red,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                        ),
                        items: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockHorizontal*2,

                              ),
                              child:  newOptionButton("Pastelería y accesorios", "https://static.wixstatic.com/media/07fea2_30d128afb84045ff80d5f7abd80e3e29~mv2.png",Color(0xFF7cdde9),(){
                                print("Comedores");
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>PupCakeScreen(widget.clientId,this.userProducts,widget.mainContext,"9rEEQebs87VQ5WOEPsND02o7HN92","PupCakes","Gato"))).then((userProductList) {
                                  setState(() {
                                    this.userProducts=userProductList;
                                  });
                                });
                              }, Colors.white)
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockHorizontal*2,

                              ),
                              child:  newOptionButton("Comedores y camas", "https://static.wixstatic.com/media/07fea2_49bd4e1a9b8f4a0183a6830a7b9a13fc~mv2.png",Colors.blueGrey,(){
                                print("Comedores");
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>MufasaScreen(widget.clientId,this.userProducts,widget.mainContext,"fjxDO6u3cafsvVziyR9sbBcBpYj2","Mufasa","Perro"))).then((userProductList) {
                                  setState(() {
                                    this.userProducts=userProductList;
                                  });
                                });
                              }, Colors.white)
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockHorizontal*2,

                              ),
                              child:  newOptionButton("Boutique y pastelería", "https://static.wixstatic.com/media/07fea2_6f5c561c0d6a4935a51241131aebc087~mv2.png",Color(0xFFeba1ba),(){
                                print("Comedores");
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>DeliDogScreen(widget.clientId,this.userProducts,widget.mainContext,"ZlJQxlIrR5TrWGI1ggSW0HISXie2","DogDeli","Perro"))).then((userProductList) {
                                  setState(() {
                                    this.userProducts=userProductList;
                                  });
                                });
                              }, Colors.white)
                          ),

                          /*Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockHorizontal*2,
                              left: SizeConfig.blockSizeHorizontal*2,
                              right:  SizeConfig.blockSizeHorizontal*2,
                            ),
                            child:  middleOptionButton("Comedores personalizados", "https://static.wixstatic.com/media/07fea2_4e49bc2027114703ac8ac70f77b8877e~mv2.png",Color(0xFFfde9eb),(){
                              print("Comedores");
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>MandiScreen(widget.clientId,this.userProducts,widget.mainContext,"3I0SrbilrehbmbB4L2jJSnHaeVq1","Mandi","Perro")));
                            }, Colors.black)
                        ),*/

                        ],
                      )
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Alimentación",
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
                            width: SizeConfig.blockSizeHorizontal*100,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.red,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: PageController(viewportFraction: 0.8),
                              child: Row(
                                children: [
                                  Container(

                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Concentrados","https://static.wixstatic.com/media/07fea2_81b9624eca4f48b491b77ebfeb944597~mv2.png",Colors.deepOrange,(){
                                        print("Concentrados");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"concentradosCat","gato"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Colors.white)
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Snacks", "https://static.wixstatic.com/media/07fea2_4489ad2f0f99463b83a0d1b5be02d76a~mv2.png",Colors.lightGreenAccent,(){
                                        print("Snacks");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"snacksCat","gato"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Color(0xFF211551),)
                                  ),
                                  Container(

                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child:  middleOptionButton("Alimentos húmedos", "https://static.wixstatic.com/media/07fea2_354fd16b280e44a783d3af53cf7f41ef~mv2.png",Colors.redAccent,(){
                                        print("Comedores");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"alimentoHumedoCat","gato"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Colors.white)
                                  ),

                                ],
                              ),
                            )
                        ),

                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Limpieza",
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
                          width: SizeConfig.safeBlockHorizontal*95,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockHorizontal*2,
                                ),
                                child:  middleOptionButton("Aseo y limpieza", "https://static.wixstatic.com/media/07fea2_2241f1b1314b41e6b11c08c63fbff98c~mv2.png",Color(0xFF53d2be),(){
                                  print("Aseo y cuidado");
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"aseoCat","gato"))).then((userProductList) {
                                    setState(() {
                                      this.userProducts=userProductList;
                                    });
                                  });
                                },Colors.white)
                            ),
                          ),
                        ),

                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Accesorios",
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
                            width: SizeConfig.blockSizeHorizontal*100,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.red,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child: middleOptionButton("Accesorios y juguetes", "https://static.wixstatic.com/media/07fea2_f8bb90130376465c81e4a067785aa3cc~mv2.png",Colors.amber,(){
                                        print("Tips");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"accesoriosCat","gato"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      },Colors.white)
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockHorizontal*2,
                                        left: SizeConfig.blockSizeHorizontal*2,
                                        right:  SizeConfig.blockSizeHorizontal*2,
                                      ),
                                      child: newOptionButton("Comedores y camas", "https://static.wixstatic.com/media/07fea2_49bd4e1a9b8f4a0183a6830a7b9a13fc~mv2.png",Colors.blueGrey,(){
                                        print("Comedores");
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>MufasaScreen(widget.clientId,this.userProducts,widget.mainContext,"fjxDO6u3cafsvVziyR9sbBcBpYj2","Mufasa","Perro"))).then((userProductList) {
                                          setState(() {
                                            this.userProducts=userProductList;
                                          });
                                        });
                                      }, Colors.white)
                                  ),

                                ],
                              ),
                            )
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*3,
                            bottom: SizeConfig.safeBlockVertical*1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Salud",
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
                          width: SizeConfig.safeBlockHorizontal*95,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockHorizontal*2,
                              ),
                              child:  middleOptionButton("Cuidado y salud", "https://static.wixstatic.com/media/07fea2_85d8b6819ac14a578bf153eb794c72d7~mv2.png",Colors.pinkAccent,(){
                                print("Salud");
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>CategoryLayoutScreen(widget.clientId,this.userProducts,widget.mainContext,"saludCat","gato"))).then((userProductList) {
                                  setState(() {
                                    this.userProducts=userProductList;
                                  });
                                });
                              },Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal*95,
                          height: SizeConfig.safeBlockVertical*2,
                        ),
                      ],
                    ),
                  ),

                ],
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
                          mostrarProductos();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> CartScreen(
                                userId: widget.clientId,userProduct: this.userProducts,storeType: "gato",mainContext: widget.mainContext,
                              ))).then((userProductList) {
                            setState(() {
                              this.userProducts=userProductList;
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
                                    "${this.userProducts.length}",
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
            /*
                               * IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){

                               },
                                 color: Colors.deepPurpleAccent,
                               )
                               * */
          ],
        )
    );
  }



  Widget handlePetType(){
  if(this.option==0){
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

  }else if(this.option==1){
    if((screenHeight<650)){
      return handleCatStore(SizeConfig.safeBlockHorizontal*18.5);
    }else if((screenHeight>650 && screenHeight<700)){
      return handleCatStore(SizeConfig.safeBlockHorizontal*17);
    }else if(screenHeight<812){
      return  handleCatStore(SizeConfig.safeBlockHorizontal*15.5);
    }else if(screenHeight<850){
      return  handleCatStore(SizeConfig.safeBlockHorizontal*14);
    }else {
      return  handleCatStore(SizeConfig.safeBlockHorizontal*12);
    }

  }else{
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Container(
          //color: Colors.amber,
          child: Center(
              child: Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.blockSizeVertical*100,
                  margin: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal*2,
                      right: SizeConfig.blockSizeHorizontal*2
                  ),
                  //color: Colors.greenAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.pink,
                          margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical*5,
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
                                  Navigator.of(context).pop(MaterialPageRoute(builder: (context) => HomeScreen()));
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF211551),
                                  size: SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                          )
                      ),
                      Container(
                        height: SizeConfig.blockSizeVertical * 80,
                        child: Center(
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 30,
                            child: Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal*100,
                                  height: SizeConfig.blockSizeVertical*5,
                                  //color: Colors.grey,
                                  margin: EdgeInsets.only(
                                    bottom: SizeConfig.safeBlockVertical*2,
                                  ),
                                  child: Text("Elige el tipo de mascota",
                                    style: TextStyle(
                                      color: Color(0xFF53d2be),
                                      fontSize: SizeConfig.safeBlockVertical*3,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "RobotoRegular",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal*46,
                                      height: SizeConfig.blockSizeVertical*20,
                                      //color: Colors.red,
                                      child: RaisedButton(
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            bottom: 0,
                                            top: 0
                                        ),
                                        onPressed:(){
                                          print("Perro");
                                          setState(() {
                                            this.option=0;
                                          });
                                        },
                                        color: Colors.deepOrange,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),/*side: BorderSide(color: Color(0xFF53d2be),width: SizeConfig.blockSizeHorizontal*1)*/),
                                        child: Container(
                                          child: Stack(
                                            children: <Widget>[
                                              Opacity(
                                                opacity: 1,
                                                child:  Container(
                                                  //color: Colors.green,
                                                  width: SizeConfig.blockSizeHorizontal*46,
                                                  height: SizeConfig.blockSizeVertical*20,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://static.wixstatic.com/media/07fea2_dbdf58b8e919412c837cbcab32ad4c41~mv2.png",
                                                    alignment: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                //color: Colors.greenAccent,
                                                margin: EdgeInsets.only(
                                                    top: SizeConfig.safeBlockVertical*12
                                                ),
                                                width: SizeConfig.blockSizeHorizontal*46,
                                                child: Text("Perro",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig.safeBlockVertical*3,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "RobotoRegular",
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: SizeConfig.blockSizeHorizontal*4,
                                    ),
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal*46,
                                      height: SizeConfig.blockSizeVertical*20,
                                      //color: Colors.blue,
                                      child: RaisedButton(
                                        padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            bottom: 0,
                                            top: 0
                                        ),
                                        onPressed:(){
                                          print("Gato");
                                          setState(() {
                                            this.option=1;
                                          });
                                        },
                                        color: Colors.deepPurpleAccent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),/*side: BorderSide(color: Color(0xFF53d2be),width: SizeConfig.blockSizeHorizontal*1)*/),
                                        child: Container(
                                          child: Stack(
                                            children: <Widget>[
                                              Opacity(
                                                opacity: 1,
                                                child:  Container(
                                                  //color: Colors.green,
                                                  width: SizeConfig.blockSizeHorizontal*46,
                                                  height: SizeConfig.blockSizeVertical*20,
                                                  child: CachedNetworkImage(
                                                    imageUrl: "https://static.wixstatic.com/media/07fea2_5db9d2d5d0b64f4d8e14eaa44f627a68~mv2.png",
                                                    alignment: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                //color: Colors.greenAccent,
                                                margin: EdgeInsets.only(
                                                    top: SizeConfig.safeBlockVertical*12
                                                ),
                                                width: SizeConfig.blockSizeHorizontal*46,
                                                child: Text("Gato",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig.safeBlockVertical*3,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "RobotoRegular",
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      )
                    ],
                  )
              )
          ),
        ),
      ),
    );
  }
  }
}
