import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/product_info_screen.dart';
import 'package:fluppyclient/scale_route.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCardLayout extends StatefulWidget {
  String productName;
  String image;
  int productPrice;
  int productUnits;
  String description;
  double cardHeight;
  String provider;
  String productId;
  int productCost;
  String category;
  int discount;
  String clientId;
  Map<String,Product>userProducts;
  var data;
  ProductCardLayout({Key key ,this.productName,this.image,this.productPrice,this.productUnits,this.description,
      this.cardHeight,this.provider,this.productId,this.productCost,this.category,this.discount,this.clientId,this.userProducts,this.data});

  @override
  _ProductCardLayoutState createState() => _ProductCardLayoutState();
}

class _ProductCardLayoutState extends State<ProductCardLayout> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    return handleCard();
  }

  Widget handleCard(){
    if(widget.data==null){
      return buildCard(widget.productName, widget.image, widget.productPrice, widget.productUnits, widget.description,
          widget.cardHeight, widget.provider,widget.productId, widget.productCost,widget.category,
          widget.discount, widget.clientId, widget.userProducts);
    }else{
      return buildCardWithData(widget.data, widget.cardHeight, widget.clientId, widget.userProducts);
    }
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
                              )));
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
                              )));
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
