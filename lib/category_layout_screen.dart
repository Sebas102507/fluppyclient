import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/cart_screen.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/product_card_layout.dart';
import 'package:fluppyclient/product_info_screen.dart';
import 'package:fluppyclient/scale_route.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user_shop_requests.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'blocUser.dart';

class CategoryLayoutScreen extends StatefulWidget {

  String clientId;
  Map<String, Product> userProducts;
  BuildContext mainContext;
  String category;
  String storeType;
  CategoryLayoutScreen(this.clientId,this.userProducts,this.mainContext,this.category,this.storeType);

  @override
  _CategoryLayoutScreenState createState() => _CategoryLayoutScreenState();
}

class _CategoryLayoutScreenState extends State<CategoryLayoutScreen> {
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  var temporalSearch=[];
  var queryResult=[];
  int contador=0;
  String productName="";
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  double screenWidth;
  double screenHeight;
  @override
  void initState() {
    super.initState();
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
  Future <QuerySnapshot>getInitialDocuments(){
    return Firestore.instance.collection(widget.category).getDocuments();
  }
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    //SizeConfig.blockSizeVertical*18,
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
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context,widget.userProducts);
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
                                child: Text("¿Qué deseas para tu ${widget.storeType}?",
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
                  Container(
                    width: SizeConfig.blockSizeHorizontal*95,
                    height: SizeConfig.blockSizeVertical*68,
                    child:   StreamBuilder(
                        stream: Firestore.instance.collection(widget.category).snapshots(),
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
                            return Stack(
                              children: <Widget>[
                                GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,mainAxisSpacing: 15, crossAxisSpacing: 15,childAspectRatio: 0.85),
                                  itemCount: snapshot.data.documents.length,
                                  padding: EdgeInsets.all(2.0),
                                  itemBuilder: (BuildContext context, int index) {
                                    return this.buildCard(
                                      snapshot.data.documents[index].data["productName"],
                                      snapshot.data.documents[index].data["image"],
                                      snapshot.data.documents[index].data["price"],
                                      snapshot.data.documents[index].data["existingUnits"],
                                      snapshot.data.documents[index].data["description"],
                                      cardHeight,
                                      snapshot.data.documents[index].data["provider"],
                                      snapshot.data.documents[index].data["id"],
                                      snapshot.data.documents[index].data["productCost"],
                                      snapshot.data.documents[index].data["category"],
                                      snapshot.data.documents[index].data["discount"],
                                      widget.clientId,
                                      widget.userProducts,
                                    );
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
                                              print("TAMAÑO DEL CARRITO ES: ${widget.userProducts.length}");

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=> CartScreen(userId: widget.clientId,
                                                      userProduct: widget.userProducts,mainContext: widget.mainContext,
                                                      storeType: widget.storeType))).then((userProductList) {
                                                setState(() {
                                                  widget.userProducts=userProductList;
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
                            );
                          }
                        }
                    ),
                  )
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
                                return this.buildCardWithData(element, cardHeight, widget.clientId, widget.userProducts);
                                /*return ProductCardLayout(
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
                                  userProducts:widget.userProducts,
                                  data:element
                              );*/
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
                                                userProduct: widget.userProducts,mainContext: widget.mainContext,
                                                storeType: widget.storeType))).then((userProductList) {
                                          setState(() {
                                            widget.userProducts=userProductList;
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
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
  void mostrarProductos(){
    widget.userProducts.forEach((String key, Product product){
      print("${product.productName}");
      print("${product.price}");
      print("${product.units}");
      print("${product.image}");
    });
  }


  Widget buildCardWithData(data, double cardHeight,String clientId, Map<String,Product>userProducts){
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
                            (data["discount"]==0)?
                            Container(
                              width: SizeConfig.blockSizeHorizontal*10,
                              height: SizeConfig.blockSizeVertical*5,
                            ):
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
                                    fontSize: SizeConfig.blockSizeVertical*1.2,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
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
                                  context, ScaleRoute(page: ProductInfo(userId: clientId,
                                price: data["price"],currentUnits: data["existingUnits"],
                                productName: data["productName"],
                                productDescription: data["description"],image:data["image"] ,
                                userProducts: userProducts,provider: data["provider"],
                                productId: data["id"],productCost: data["productCost"],category: data["category"],
                                productBackgroundColor:  Color(0xFF53d2be),
                                discount: data["discount"],
                              ))).then((userProductList) {
                                setState(() {
                                  widget.userProducts=userProductList;
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
                                      (data["discount"]==0)?
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


  Widget buildCard(String productName, String image,int productPrice, int productUnits,
      String description, double cardHeight, String provider, String productId, int productCost,String category,int discount,String clientId, Map<String,Product>userProducts){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(color: (productUnits==0)? Colors.grey : Color(0xFF53d2be),)),
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
                                imageUrl: image,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            (discount==0)?
                            Container(
                              width: SizeConfig.blockSizeHorizontal*10,
                              height: SizeConfig.blockSizeVertical*5,
                            ):
                            Container(
                              width: SizeConfig.blockSizeHorizontal*10,
                              height: SizeConfig.blockSizeVertical*5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text("-$discount%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*1.4),),
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
                              child: Text(productName,
                                style: TextStyle(
                                    color:Color(0xFF211551),
                                    fontSize: SizeConfig.blockSizeVertical*1.2,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
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
                      color: (productUnits==0)? Colors.grey : Color(0xFF53d2be),
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
                                  context, ScaleRoute(page: ProductInfo(userId: clientId,
                                price: productPrice,currentUnits: productUnits,
                                productName: productName,productDescription: description,
                                image: image,userProducts: userProducts,
                                provider: provider,
                                productId: productId,
                                productCost: productCost,
                                category: category,
                                productBackgroundColor:  Color(0xFF53d2be),
                                discount: discount,
                              ))).then((userProductList) {
                                setState(() {
                                  widget.userProducts=userProductList;
                                });
                              });
                              print("LO QUIERO");
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: (productUnits==0)? Colors.grey : Color(0xFF53d2be),
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
                                      (discount==0)?
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${productPrice.toString().replaceAllMapped(reg, mathFunc)}",
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
                                      ):

                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${productPrice.toString().replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  decoration: TextDecoration.lineThrough
                                              ),
                                            ),
                                            Text(
                                              "\$${(productPrice*(1-(discount/100))).round().toString().replaceAllMapped(reg, mathFunc)}",
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


}
