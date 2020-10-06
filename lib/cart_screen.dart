import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/confirmation_payment_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/get_address_google.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';


class CartScreen extends StatefulWidget {
  String userId;
  Map<String, Product>userProduct;
  String storeType;
  BuildContext mainContext;
  CartScreen({Key key, this.userId,this.userProduct,this.storeType,this.mainContext});
  @override
  _CartScreen createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  UserBloc userBloc;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  String image="assets/FluppyPro.png";
  File imageFile;
  bool changeImage;
  bool usePoints=false;
  int total=0;
  int points=0;
  bool continueAddingPrice=true;
  Map<String, Product> copyUserProducts= Map<String, Product> ();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      copyUserProducts=widget.userProduct;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,widget.userProduct);
      },
      child: handle(),
    );
  }


  Widget productLayout(String name, int units, String price, String image,String provider,String description){
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
         handleImage(image),
          VerticalDivider(
            width: SizeConfig.safeBlockHorizontal*1,
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal*42,
            height: SizeConfig.safeBlockVertical * 12,
            //color: Colors.cyan,
            child:  (provider.toUpperCase()=="CERAGRO" || provider.toUpperCase()=="FARMASCOTAS" )? Column(
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
            )
                :
            Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.safeBlockHorizontal*47,
                  height: SizeConfig.safeBlockVertical * 5,
                  //color: Colors.blueGrey,
                  child: Text(name,
                    style: TextStyle(
                        color: Color(0xFF53d2be),
                        fontSize: SizeConfig.safeBlockVertical*1.3,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal*47,
                  height: SizeConfig.safeBlockVertical * 4,
                  //color: Colors.green,
                  child: Text(description,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizeConfig.safeBlockVertical*1,
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
                        fontSize: SizeConfig.safeBlockVertical*1.5,
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
                  height: SizeConfig.safeBlockVertical * 8,
                  //color: Colors.blueGrey,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.red,size: SizeConfig.safeBlockVertical*4,),
                        onPressed: (){
                          print("ELIMINAR");
                          try{
                           setState(() {
                             this.copyUserProducts.remove(name);
                             widget.userProduct.remove(name);
                             print("SE BORRÓ");
                           });
                          }catch(e){
                            print("OCURRIÓ UN ERRORrrrrrrrrrrrrrrr: $e");
                          }
                        }
                        ),
                  ),
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal*39,
                  height: SizeConfig.safeBlockVertical * 4,
                  //color: Colors.cyan,
                  child: Text("\$$price",
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
          )
        ],
      ),
    );
  }
  int getTotalCheckDelivery(){
    int total=0;
    int contador=0;
   this.copyUserProducts.forEach((key, product){
      //print("EL PRECIO: ${product.price}");
      //print("Provider: ${product.provider}");
      //print("ProviderId: ${product.providerId}");
      total=total+product.price;
      //print("COntiene la palabra ${product.provider.toUpperCase()}: ${!product.provider.toUpperCase().contains("CERAGRO")}");
      if(!product.provider.toUpperCase().contains("CERAGRO") && !product.provider.toUpperCase().contains("FARMASCOTAS")   && contador==0){
        //print("ENTREÉ CUANDO SE SUPONE QUE NO");
        total=total+2000;
        contador=1;
      }
    });
    //print("EL TOTAL CUANDO SE MIRA EL DELIVERY: $total");
    return total;
  }

  int getTotalWithoutDelivery(){
    int total=0;
    this.copyUserProducts.forEach((key, product){
      total=total+product.price;
    });
    //print("EL TOTAL CUANDO NOOOO EL DELIVERY: $total");
    return total;
  }


  Widget handle(){
    int deliveryCost=0;
    return StreamBuilder(
        stream: Firestore.instance.collection('deliveryPrice').document("GBvof5PawC6RZmApWa9t").snapshots(),
        builder: (BuildContext context, AsyncSnapshot deliverySnapshot){
          if(!deliverySnapshot.hasData){
              deliveryCost=0;
          }else{
              deliveryCost=deliverySnapshot.data["price"];
          }
          return StreamBuilder(
            stream: Firestore.instance.collection("users").document(widget.userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot userSnapshot){
              if(!userSnapshot.hasData){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xFF211551)),
                    ),
                  ),
                );
              }else{
                return Scaffold(
                  body: Container(
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
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context,widget.userProduct);
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
                            //color: Colors.brown,
                            child: Text("Mi carrito",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color:  Color(0xFF53d2be),
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical * 3,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: SizeConfig.safeBlockVertical * 50,
                            margin: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical*2
                            ),
                            //color: Colors.yellow,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF53d2be),width: SizeConfig.safeBlockHorizontal*1),
                            ),
                            child: (widget.userProduct.length==0 || widget.userProduct.length==null || this.copyUserProducts.length==0 || this.copyUserProducts.length==null)  ?
                            Container(
                              child: Center(
                                child: Text("No tienes productos",
                                  style: TextStyle(
                                      color: Color(0xFF53d2be),
                                      fontSize: SizeConfig.safeBlockVertical*2.5,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            )
                                :
                            ListView.builder(
                                itemCount: this.copyUserProducts.length,
                                itemBuilder: (_, int index) {
                                  String key = this.copyUserProducts.keys.elementAt(index);

                                  return productLayout(this.copyUserProducts[key].productName,
                                      this.copyUserProducts[key].units,
                                      this.copyUserProducts[key].price.toString().replaceAllMapped(reg, mathFunc), this.copyUserProducts[key].image,this.copyUserProducts[key].provider,this.copyUserProducts[key].description);

                                }
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: SizeConfig.safeBlockVertical * 15,
                            //color: Colors.orange,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: SizeConfig.safeBlockVertical * 5,
                                  //color: Colors.red,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*48,
                                        height: SizeConfig.safeBlockVertical * 12,
                                        //color: Colors.grey,
                                        child: Text("Envío:",
                                          style: TextStyle(
                                              color: Color(0xFF53d2be),
                                              fontSize: SizeConfig.safeBlockVertical*2.5,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*48,
                                        height: SizeConfig.safeBlockVertical * 12,
                                        //color: Colors.brown,
                                        child: Text("\$${((getTotalCheckDelivery()-getTotalWithoutDelivery())+deliveryCost).toString().replaceAllMapped(reg, mathFunc)}",
                                          style: TextStyle(
                                            color: Color(0xFF53d2be),
                                            fontSize: SizeConfig.safeBlockVertical*2.5,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: SizeConfig.safeBlockVertical * 5,
                                  //color: Colors.red,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*20,
                                        height: SizeConfig.safeBlockVertical * 10,
                                        //color: Colors.grey,
                                        child: Text("Coins:",
                                          style: TextStyle(
                                              color: Color(0xFF53d2be),
                                              fontSize: SizeConfig.safeBlockVertical*2.5,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: SizeConfig.safeBlockHorizontal*20,
                                          height: SizeConfig.safeBlockVertical * 12,
                                          //color: Colors.yellow,
                                          child: RaisedButton(
                                              onPressed:(){
                                                if(this.usePoints){
                                                  setState(() {
                                                    this.usePoints=false;
                                                    this.points=0;
                                                  });
                                                }else{
                                                  setState(() {
                                                    this.usePoints=true;
                                                    this.points=userSnapshot.data["points"];
                                                  });
                                                }
                                              },
                                              shape:RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              color: Color(0xFF53d2be),
                                              child: Column(
                                                children: [
                                                  Text("${userSnapshot.data["points"].toString().replaceAllMapped(reg, mathFunc)}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig.safeBlockVertical*1.3,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Text(this.usePoints ? "Quitar":"Usar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig.safeBlockVertical*1.3,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*56,
                                        height: SizeConfig.safeBlockVertical * 12,
                                        // color: Colors.brown,
                                        child: Text(this.usePoints ? "${userSnapshot.data["points"].toString().replaceAllMapped(reg, mathFunc)}":"0",
                                          style: TextStyle(
                                            color: Color(0xFF53d2be),
                                            fontSize: SizeConfig.safeBlockVertical*2.5,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: SizeConfig.safeBlockVertical * 5,
                                  //color: Colors.green,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*48,
                                        height: SizeConfig.safeBlockVertical * 12,
                                        // color: Colors.black,
                                        child: Text("Total: ",
                                          style: TextStyle(
                                              color: Color(0xFF53d2be),
                                              fontSize: SizeConfig.safeBlockVertical*2.5,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: SizeConfig.safeBlockHorizontal*48,
                                        height: SizeConfig.safeBlockVertical * 12,
                                        // color: Colors.grey,
                                        child: Text( (getTotalCheckDelivery()+deliveryCost-this.points)<=0 ? "\$0":"\$${(getTotalCheckDelivery()+deliveryCost-this.points).toString().replaceAllMapped(reg, mathFunc)}",
                                          style: TextStyle(
                                            color: Color(0xFF53d2be),
                                            fontSize: SizeConfig.safeBlockVertical*2.5,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
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
                                      color:  Color(0xFF53d2be),
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 0.2)
                                  )
                                ],
                              ),
                              child: GenericButton(
                                text: "Continuar",
                                radius: 10,
                                textSize: SizeConfig.safeBlockHorizontal* 5,
                                width: SizeConfig.safeBlockHorizontal*4,
                                height: SizeConfig.safeBlockHorizontal* 15,
                                color:  Color(0xFF53d2be),
                                textColor: Colors.white,
                                onPressed: (){

                                 print("TAMAÑO DEL CARRO: ${this.copyUserProducts.length}");
                                 print("STORETYPE: ${widget.storeType}");
                                 //getTotal();
                                 if(widget.userProduct.length==0 || widget.userProduct.length==null || this.copyUserProducts.length==0 || this.copyUserProducts.length==null){
                                   Fluttertoast.showToast(
                                       msg: "Tienes tu carrito vacío :(",
                                       toastLength: Toast.LENGTH_SHORT,
                                       gravity: ToastGravity.CENTER,
                                       backgroundColor: Colors.grey,
                                       timeInSecForIos: 2);
                                 }else{
                                   //print("LO VOY A COMPRAR***************");
                                   //print("EL TOTAL DE MI COMPRA ES DE: ${getTotal()}");
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context)=>GetAddressGoogle(userId: widget.userId,
                                         userProduct:this.copyUserProducts,
                                         total: ((getTotalCheckDelivery()+deliveryCost)-this.points) ,
                                         totalBeforePoints:(getTotalCheckDelivery()+deliveryCost),
                                         points: this.points,mainContext: widget.mainContext,
                                         storeType: widget.storeType,)));
                                 }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
    );
  }
  Widget handleImage(String image){
    if(image.contains("firebase")){
      return Container(
        width: SizeConfig.safeBlockHorizontal*20,
        height: SizeConfig.safeBlockVertical * 12,
        //color: Colors.red,
        child: CachedNetworkImage(imageUrl: image),
      );
    }else{
      return Container(
        width: SizeConfig.safeBlockHorizontal*20,
        height: SizeConfig.safeBlockVertical * 12,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(image))
            )
        ),
      );
    }
  }
}
