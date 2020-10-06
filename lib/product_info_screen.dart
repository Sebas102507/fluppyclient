import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/category_layout_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';


class ProductInfo extends StatefulWidget {
  String image;
  String productName;
  int price;
  int currentUnits;
  String productDescription;
  String userId;
  Map<String, Product>userProducts;
  String provider;
  String productId;
  int productCost;
  String category;
  BuildContext mainContext;
  Color productBackgroundColor;
  String providerId;
  int discount;

  ProductInfo({Key key, this.image,this.price,this.productName,this.currentUnits,
    this.productDescription,this.userId,this.userProducts,
    this.provider,this.productId,this.productCost,this.category,this.mainContext,this.productBackgroundColor,this.providerId,this.discount});
  @override
  _ProductInfo createState() => _ProductInfo();
}

class _ProductInfo extends State<ProductInfo> {
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
    print("EL PROVIDER ES: ${widget.provider}");
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
    print("A FLUPPY LE CUESTA: ${widget.productCost}");
    FocusScope.of(context).unfocus();
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,widget.userProducts);
      },
      child: Scaffold(
          body: ListView(
            children: <Widget>[
              Container(
                height: SizeConfig.safeBlockVertical*135,
                color: widget.productBackgroundColor,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal*100 ,
                      height: SizeConfig.blockSizeVertical*40,
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                                              FocusScope.of(context).unfocus();
                                              Navigator.pop(context, MaterialPageRoute(builder: (context)=>StoreScreen(widget.userId,widget.mainContext)));
                                            },
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: widget.productBackgroundColor,//Colors.white,//Colors.white,
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
                                child: Stack(
                                  children: [
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
                                    (widget.discount==0)?
                                    Container(
                                      width: SizeConfig.blockSizeHorizontal*90,
                                      height: SizeConfig.blockSizeVertical * 8,
                                    )
                                        :
                                    Container(
                                      margin: EdgeInsets.only(
                                        //top: SizeConfig.safeBlockVertical*2,
                                        //left: SizeConfig.safeBlockHorizontal * 2,
                                      ),
                                      width: SizeConfig.blockSizeHorizontal*90,
                                      height: SizeConfig.blockSizeVertical * 8,
                                      //color: Colors.orange,
                                      child: Align(
                                        child: Container(
                                          width: SizeConfig.blockSizeVertical * 8,
                                          height: SizeConfig.blockSizeVertical * 8,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(100))
                                          ),
                                          child: Center(
                                            child: Text("-${widget.discount}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*2),),
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                                  ],
                                )
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
                                top: SizeConfig.safeBlockVertical*2,
                              ),
                              // color: Colors.orange,
                              width: SizeConfig.safeBlockHorizontal*100,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    //color: Colors.yellow,
                                    width: SizeConfig.safeBlockHorizontal*65,
                                    child: Row(
                                      children: <Widget>[
                                        (widget.discount==0)?
                                        Container(
                                          child: Text("\$${this.priceWithComa}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: SizeConfig.safeBlockVertical*2.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                            ),
                                          ),
                                        )
                                            :
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Text("\$${this.priceWithComa}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.safeBlockVertical*1.6,
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.lineThrough
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child:  Text(
                                                  "\$${(this.currentPrice*(1-(widget.discount/100))).round().toString().replaceAllMapped(reg, mathFunc)}",
                                                  style: TextStyle(
                                                    fontFamily: "RobotoRegular",
                                                    color: Colors.white,
                                                    fontSize: SizeConfig.safeBlockVertical*2.5,
                                                    fontWeight: FontWeight.bold,

                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.blueGrey,
                                          width: SizeConfig.safeBlockHorizontal*30,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                //color: Colors.yellow,
                                                  width: SizeConfig.blockSizeHorizontal*12,
                                                  height: SizeConfig.blockSizeVertical * 5,
                                                  child: Container(
                                                      child: IconButton(
                                                          icon: Icon(Icons.remove_circle_outline, color: Colors.white,size: SizeConfig.safeBlockVertical*4,),
                                                          onPressed: (){
                                                            if(this.currentProductUnits>1){
                                                              setState(() {
                                                                this.currentProductUnits--;
                                                                this.currentPrice=widget.price*this.currentProductUnits;
                                                                priceWithComa=this.currentPrice.toString().replaceAllMapped(reg, mathFunc);
                                                              });
                                                            }
                                                            print("RESTAR");
                                                          }
                                                      )
                                                  )
                                              ),
                                              Container(
                                                child: Text("${this.currentProductUnits}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.safeBlockVertical*2
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                //color: Colors.yellow,
                                                  width: SizeConfig.blockSizeHorizontal*12,
                                                  height: SizeConfig.blockSizeVertical * 5,
                                                  child: Container(
                                                      child: IconButton(
                                                          icon: Icon(Icons.add_circle_outline, color: Colors.white,size: SizeConfig.safeBlockVertical*4,),
                                                          onPressed: (){
                                                            if(this.currentProductUnits<widget.currentUnits){
                                                              setState(() {
                                                                this.currentProductUnits++;
                                                                this.currentPrice=widget.price*this.currentProductUnits;
                                                                priceWithComa=this.currentPrice.toString().replaceAllMapped(reg, mathFunc);
                                                              });
                                                            }
                                                            print("SUMAR");
                                                          }
                                                      )
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal*0.5
                                    ),
                                    width: SizeConfig.blockSizeHorizontal*25,
                                    height: SizeConfig.blockSizeVertical * 5,
                                    // color: Colors.amber,
                                    child: RaisedButton(
                                      // padding: EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        color: Colors.white,
                                        onPressed: (){
                                          print("EL CATEGORY: ${widget.category}");
                                          print("AGREGAR AL CARRITO");
                                          print("PRECIO A PAGAR: ${this.currentPrice}");
                                          setState(() {
                                            widget.userProducts.putIfAbsent(widget.productName, () =>
                                                Product(productName: widget.productName,price: (widget.discount==0)?this.currentPrice:(this.currentPrice*(1-(widget.discount/100))).round(),
                                                    units: this.currentProductUnits,image: widget.image,
                                                    description: widget.productDescription,
                                                    currentUnitsInStock: widget.currentUnits,
                                                    provider: widget.provider,
                                                    id: widget.productId,
                                                    productCost: widget.productCost,
                                                    category: widget.category,
                                                    providerId: widget.providerId
                                                ));
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Se agregó al carrito",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.grey,
                                              timeInSecForIos: 2);

                                          Navigator.pop(context,widget.userProducts);
                                        },
                                        child: Center(
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add_shopping_cart,
                                                  color: widget.productBackgroundColor,
                                                  size: SizeConfig.safeBlockVertical*1.7,
                                                ),
                                                Text("añadir",
                                                  style: TextStyle(
                                                    color: widget.productBackgroundColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "RobotoRegular",
                                                    fontSize: SizeConfig.safeBlockVertical*1.7,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  )

                                ],
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical*3
                            ),
                            //color: Colors.orange,
                            width: double.infinity,
                            child: Text("${widget.productName} ${widget.userProducts.length}",
                              style: TextStyle(
                                color:Colors.white,
                                fontSize: SizeConfig.safeBlockVertical*2.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RobotoRegular",
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
                                color: Colors.grey[200],
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
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Text(widget.productDescription,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.safeBlockVertical*1.8,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
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
      ),
    );
  }
}