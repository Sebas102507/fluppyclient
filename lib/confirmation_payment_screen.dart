import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/cart_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/get_address_google.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class CofirmPaymentScreen extends StatefulWidget {

  String userId;
  Map<String, Product>userProduct;
  int total;
  int totalBeforePoints;
  int points;
  String storeType;
  BuildContext mainContext;
  String adrress;
  double latitude, longitude;
  CofirmPaymentScreen({Key key, this.userId,this.userProduct,this.total,this.storeType,this.mainContext,this.adrress,this.longitude,this.latitude,this.points,this.totalBeforePoints});
  @override
  _CofirmPaymentScreen createState() => _CofirmPaymentScreen();
}

class _CofirmPaymentScreen extends State<CofirmPaymentScreen> {
  UserBloc userBloc;
  String residence;
  int group=-1;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  final formKey = new GlobalKey<FormState>();
  bool confirmationPayment=false;
  int contadorParaBusiness=0;
  double distance;
  bool isLoading=false;
  String valueOption;
  @override
  void initState() {
    super.initState();
    this.getDistance(4.7486975, -74.0385616, widget.latitude, widget.longitude).then((distance) {
      //print("La distancia es: ${distance/1000}");
      setState(() {
        this.distance=distance/1000;
      });
    });

//   pk_test_WyaFPAE5VT7Ba0YpuhDO08NC002kKFm8ab
//   pk_live_WEC9HzpbXfaiyO6z7s2TNWeM00eIKtwikY
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_live_WEC9HzpbXfaiyO6z7s2TNWeM00eIKtwikY", merchantId: "Live", androidPayMode: 'live'));
  }

  @override
  Widget build(BuildContext context) {
    //print("EL TIPO DE TIENDA: ${widget.storeType}");
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return handleProductsRequested();
  }

  Widget handleProductsRequested(){
    int currentUserBill=0;
    if(this.distance==null){
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
          ),
        ),
      );
    }else{
      if(this.distance>20.5){
        print("****************DISTANCIA ES: ${this.distance}");
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
                              FocusScope.of(context).requestFocus(new FocusNode());
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(userId: widget.userId,userProduct: widget.userProduct,)));

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
                      height: SizeConfig.safeBlockVertical * 70,
                      //color: Colors.brown,
                      child: Center(
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal*100,
                          height: SizeConfig.safeBlockVertical * 30,
                          //color: Colors.orange,
                          child: Column(
                            children: [
                              Container(
                                width: SizeConfig.blockSizeHorizontal*100,
                                height: SizeConfig.safeBlockVertical * 20,
                                decoration: BoxDecoration(
                                  //color: Colors.yellow,
                                    image: DecorationImage(
                                        image: AssetImage("assets/map.png")
                                    )
                                ),
                              ),
                              Text("Uppss, parece que la dirección se sale de nuestra cobertura. Disculpa las molestias.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:  Color(0xFF53d2be),
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),

                ],
              ),
            ),
          ),
        );
      }else{
        print("****************DISTANCIA ES: ${this.distance}");
        return   StreamBuilder(
            stream: Firestore.instance.collection('usersProductsRequests').document(widget.userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                currentUserBill=0;
              }else{
                try{
                  currentUserBill= snapshot.data["orderPrice"];
                }catch(e){
                  currentUserBill=0;
                }
              }
              return Scaffold(
                body: (!this.confirmationPayment)?
                StreamBuilder(
                    stream: Firestore.instance.collection('users').document(widget.userId).snapshots(),
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
                        return Scaffold(
                            body: Stack(
                              children: [
                                Form(
                                    key: formKey,
                                    child: Center(
                                      child: Container(
                                        //color: Colors.blueGrey,
                                        margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal * 2,
                                          right: SizeConfig.blockSizeHorizontal * 2,
                                        ),
                                        width: SizeConfig.blockSizeHorizontal * 100,
                                        child: SingleChildScrollView(

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                //color: Colors.pink,
                                                  margin: EdgeInsets.only(
                                                      top: SizeConfig.safeBlockVertical * 4,
                                                      bottom: SizeConfig.safeBlockVertical*2
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
                                                          Navigator.of(context).pop();
                                                          Navigator.of(context).pop(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CartScreen(userId: widget.userId,userProduct: widget.userProduct,)));
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
                                                width: SizeConfig.safeBlockHorizontal*90,
                                                height: SizeConfig.safeBlockVertical * 65,
                                                margin: EdgeInsets.only(
                                                    bottom: SizeConfig.safeBlockVertical * 2
                                                ),
                                                //color: Colors.yellow,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow (
                                                          color:  Colors.black45,
                                                          blurRadius: 8.0,
                                                          offset: Offset(0.0, 0.2)
                                                      )
                                                    ],
                                                    // border: Border.all(color: Color(0xFF53d2be), width: SizeConfig.safeBlockHorizontal * 1),
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Center(
                                                          child: Text("Mi orden",
                                                            style: TextStyle(
                                                                color: Color(0xFF53d2be),
                                                                fontSize: SizeConfig.safeBlockVertical*3,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          top: SizeConfig.safeBlockVertical*2,
                                                          bottom: SizeConfig.safeBlockVertical*6,
                                                        ),
                                                        child: Center(
                                                          child: Text("${snapshot.data["firstName"]} ${snapshot.data["lastName"]}",
                                                            style: TextStyle(
                                                              color: Color(0xFF53d2be),
                                                              fontSize: SizeConfig.safeBlockVertical*2.5,
                                                              //fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          //color: Colors.deepPurpleAccent,
                                                          child: Text("Residencia:",
                                                            style: TextStyle(
                                                                color: Color(0xFF53d2be),
                                                                fontSize: SizeConfig.safeBlockVertical*2,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                            left: SizeConfig.safeBlockHorizontal*2,
                                                            right: SizeConfig.safeBlockHorizontal*2,
                                                          ),
                                                          child: Theme(
                                                              data: ThemeData(
                                                                primaryColor:  Color(0xFF211551),
                                                                hintColor:   Colors.grey,
                                                              ),
                                                              child: Container(
                                                                //color: Colors.yellow,
                                                                  height: SizeConfig.safeBlockHorizontal* 22,
                                                                  child: TextFormField(
                                                                    validator: (value) {
                                                                      if (value.isEmpty) {
                                                                        return "Campo invalido";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onSaved: (input) => residence = input,
                                                                    style: TextStyle(
                                                                      color: Color(0xFF211551),
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      hintText: "Conjunto, torre-casa, apartamento-casa",
                                                                      filled: true,
                                                                      //labelText: "Residencia",
                                                                      fillColor: Colors.white12,
                                                                    ),
                                                                    obscureText: false,
                                                                  )
                                                              )
                                                          )
                                                      ),
                                                      Container(
                                                          width: SizeConfig.safeBlockHorizontal*100,
                                                          //color: Colors.yellow,
                                                          margin: EdgeInsets.only(
                                                              top: SizeConfig.safeBlockVertical*1
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: SizeConfig.safeBlockHorizontal*22,
                                                                //color: Colors.deepPurpleAccent,
                                                                child: Text("Dirección:",
                                                                  style: TextStyle(
                                                                      color: Color(0xFF53d2be),
                                                                      fontSize: SizeConfig.safeBlockVertical*2,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                //color: Colors.blue,
                                                                width: SizeConfig.safeBlockHorizontal*68,
                                                                child: Text("${widget.adrress}",
                                                                  style: TextStyle(
                                                                      color: Colors.grey[400],
                                                                      fontSize: SizeConfig.safeBlockVertical*2,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                      Container(
                                                          width: SizeConfig.safeBlockHorizontal*100,
                                                          margin: EdgeInsets.only(
                                                              top: SizeConfig.safeBlockVertical*2
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: SizeConfig.safeBlockHorizontal*40,
                                                                child: Text("Total:",
                                                                  style: TextStyle(
                                                                      color: Color(0xFF53d2be),
                                                                      fontSize: SizeConfig.safeBlockVertical*2,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: SizeConfig.safeBlockHorizontal*50,
                                                                child: Text("\$${widget.total.toString().replaceAllMapped(reg, mathFunc)}",
                                                                  style: TextStyle(
                                                                      color: Colors.grey[400],
                                                                      fontSize: SizeConfig.safeBlockVertical*2,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                      Container(
                                                          width: SizeConfig.safeBlockHorizontal*100,
                                                          margin: EdgeInsets.only(
                                                              top: SizeConfig.safeBlockVertical*2
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                //color: Colors.red,
                                                                width: SizeConfig.safeBlockHorizontal*40,
                                                                child: Text("Medio de pago:",
                                                                  style: TextStyle(
                                                                      color: Color(0xFF53d2be),
                                                                      fontSize: SizeConfig.safeBlockVertical*2,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                  width: SizeConfig.safeBlockHorizontal*50,
                                                                  //color: Colors.blue,
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: DropdownButton(
                                                                      items: [
                                                                        DropdownMenuItem<String>(
                                                                          value: "Efectivo",
                                                                          child: Text(
                                                                            "Efectivo",
                                                                            style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                        DropdownMenuItem<String>(
                                                                          value: "Datafono",
                                                                          child: Text(
                                                                            "Datáfono",
                                                                            style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                       /* DropdownMenuItem<String>(
                                                                          value: "Tarjeta",
                                                                          child: Text(
                                                                            "Tarjeta",
                                                                            style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),*/
                                                                      ],
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          //print("El nombre de la empresa es: ${widget.businessName}");
                                                                          valueOption = value;
                                                                          if(valueOption=="Efectivo"){
                                                                            group=0;
                                                                          }else if(valueOption=="Datafono"){
                                                                            group=1;
                                                                          }else if(valueOption=="Tarjeta"){
                                                                            group=2;
                                                                          }

                                                                          // print("EL NUEVO VALUE ES: $valueOption");
                                                                        });
                                                                      },
                                                                      value: valueOption,
                                                                      disabledHint: Text("Categoría",style: TextStyle(color: Colors.green)),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                            top: SizeConfig.safeBlockVertical*2,
                                                          ),
                                                          width: SizeConfig.safeBlockHorizontal*90,
                                                          height: SizeConfig.safeBlockVertical*13,
                                                          //color: Colors.red,
                                                          child: Align(
                                                            alignment: Alignment.bottomRight,
                                                            child:  Container(
                                                              width:SizeConfig.safeBlockVertical*13,
                                                              height: SizeConfig.safeBlockVertical*13,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: AssetImage("assets/fluppyImageBillPayment.jpg")
                                                                  )
                                                              ),
                                                            ),
                                                          )
                                                      )
                                                    ],
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
                                                  child: GenericButton(
                                                    text: "Confirmar",
                                                    radius: 10,
                                                    textSize: SizeConfig.safeBlockHorizontal* 5,
                                                    width: SizeConfig.safeBlockHorizontal*4,
                                                    height: SizeConfig.safeBlockHorizontal* 15,
                                                    color:  Color(0xFF53d2be),
                                                    textColor: Colors.white,
                                                    onPressed: () async {

                                                      if(widget.adrress=="Selecciona tu dirección"
                                                          ||widget.adrress==" " || widget.adrress=="" || widget.adrress==null ){
                                                        Fluttertoast.showToast(
                                                            msg: "Dirección inválida",
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            backgroundColor: Colors.grey,
                                                            timeInSecForIos: 2);
                                                      }else{
                                                        if(group==-1){
                                                          Fluttertoast.showToast(
                                                              msg: "Selecciona un medio de pago",
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              backgroundColor: Colors.grey,
                                                              timeInSecForIos: 2);
                                                        }else{
                                                          final formState = formKey.currentState;
                                                          try{
                                                            if (formState.validate()) {
                                                              formState.save();
                                                              //  print("ADDRESS: ${widget.adrress}");
                                                              // print("RESIDENCE: ${this.residence}");

                                                            }
                                                          }catch(e){
                                                            print(e);
                                                          }
                                                          if(this.residence==null || this.residence=="" || this.residence==" "){
                                                            Fluttertoast.showToast(
                                                                msg: "Residencia invalida",
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.CENTER,
                                                                backgroundColor: Colors.grey,
                                                                timeInSecForIos: 2);

                                                          }else{

                                                            setState(() {
                                                              this.isLoading=true;
                                                            });

                                                            if(group==2){
                                                              // var response= await StripeServices.payWithNewCard("${widget.total}00","cop");
                                                              StripeServices.payWithNewCard("${widget.total}00","cop").then((response) {
                                                                if(response.success==true){

                                                                  userBloc.updateUserProductsRequestedInfo(//manda la  info básica del pedido del pedido al admin
                                                                      User(email: " ", id: snapshot.data["id"],phone:snapshot.data["phoneNumber"],
                                                                          firstName: snapshot.data["firstName"],lastName: snapshot.data["lastName"],userPetName: snapshot.data["petName"]),
                                                                      "${widget.adrress}, $residence", widget.total+currentUserBill,widget.latitude,widget.longitude,group);

                                                                  if(widget.storeType=="perro"){

                                                                    widget.userProduct.forEach((key, product){
                                                                      //print("ID: ${product.id}");
                                                                      if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                        userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                        this.updateProductStockUnits(product.currentUnitsInStock-product.units, product.id);
                                                                        this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                                      }else{

                                                                        // print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                        //print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                        if(contadorParaBusiness==0){
                                                                          userBloc.updateUserProductsRequestedInfoBusiness(product.providerId,
                                                                              snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                              widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                          contadorParaBusiness=1;
                                                                        }

                                                                        if(product.image.contains("firebase")){
                                                                          userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                          userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                          this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                        }else{
                                                                          userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                            _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                              snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                                userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                                userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                              });
                                                                            });
                                                                          });
                                                                        }
                                                                      }
                                                                    });
                                                                  }else{
                                                                    widget.userProduct.forEach((key, product){
                                                                      // print("ID: ${product.id}");
                                                                      // print("CATEOGORIA DEL COSOS: ${product.category}");
                                                                      if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                        // print("ID: ${product.id}");
                                                                        userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                        this.updateProductStockUnitsCat(product.currentUnitsInStock-product.units, product.id);
                                                                        this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                                      }else{

                                                                        //print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                        //print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                        if(contadorParaBusiness==0){
                                                                          userBloc.updateUserProductsRequestedInfoBusiness(product.providerId, /////////sube la informacion basica de la compra
                                                                              snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                              widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                          contadorParaBusiness=1;
                                                                        }

                                                                        if(product.image.contains("firebase")){
                                                                          userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                          userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                          this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                        }else{
                                                                          userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                            _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                              snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                                userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                                userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                              });
                                                                            });
                                                                          });
                                                                        }
                                                                      }
                                                                    });
                                                                  }
                                                                  setState(() {
                                                                    this.isLoading=false;
                                                                    this.confirmationPayment=true;
                                                                  });
                                                                  widget.userProduct.clear();

                                                                  if(widget.points>=1){
                                                                    if(widget.points<widget.totalBeforePoints){
                                                                      //print("PUNTOS CUANDO ES MENOR:${0}");
                                                                      setState(() {
                                                                        this.isLoading=true;
                                                                      });
                                                                      updateUserPoints(0, widget.userId);
                                                                    }else if(widget.points>widget.totalBeforePoints){
                                                                      //print("PUNTOS CUANDO ES MAYOR:${widget.points-widget.totalBeforePoints}");
                                                                      setState(() {
                                                                        this.isLoading=true;
                                                                      });
                                                                      updateUserPoints(widget.points-widget.totalBeforePoints, widget.userId);
                                                                    }

                                                                  }

                                                                }else{
                                                                  Fluttertoast.showToast(
                                                                      msg: "Hubo un error,inténtalo de nuevo",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.CENTER,
                                                                      backgroundColor: Colors.grey,
                                                                      timeInSecForIos: 2);
                                                                  setState(() {
                                                                    this.confirmationPayment=false;
                                                                  });
                                                                }
                                                              });
                                                            }else{

                                                              userBloc.updateUserProductsRequestedInfo(//manda la  info básica del pedido del pedido al admin
                                                                  User(email: " ", id: snapshot.data["id"],phone:snapshot.data["phoneNumber"],
                                                                      firstName: snapshot.data["firstName"],lastName: snapshot.data["lastName"],userPetName: snapshot.data["petName"]),
                                                                  "${widget.adrress}, $residence", widget.total+currentUserBill,widget.latitude,widget.longitude,group);

                                                              if(widget.storeType=="perro"){
                                                                widget.userProduct.forEach((key, product){
                                                                  print("ID: ${product.id}");
                                                                  if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                    userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                    this.updateProductStockUnits(product.currentUnitsInStock-product.units, product.id);
                                                                    this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                                  }else{

                                                                    // print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                    //print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                    if(contadorParaBusiness==0){
                                                                      userBloc.updateUserProductsRequestedInfoBusiness(product.providerId,
                                                                          snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                          widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                      contadorParaBusiness=1;
                                                                    }

                                                                    if(product.image.contains("firebase")){
                                                                      userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                      userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                      this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                    }else{
                                                                      userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                        _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                          snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                            userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                            userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                          });
                                                                        });
                                                                      });
                                                                    }
                                                                  }
                                                                });
                                                              }else{
                                                                widget.userProduct.forEach((key, product){
                                                                  print("ID: ${product.id}");
                                                                  print("CATEOGORIA DEL COSOS: ${product.category}");
                                                                  if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                    print("ID: ${product.id}");
                                                                    userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                    this.updateProductStockUnitsCat(product.currentUnitsInStock-product.units, product.id);
                                                                    this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                                  }else{

                                                                    // print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                    //print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                    if(contadorParaBusiness==0){
                                                                      userBloc.updateUserProductsRequestedInfoBusiness(product.providerId, /////////sube la informacion basica de la compra
                                                                          snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                          widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                      contadorParaBusiness=1;
                                                                    }

                                                                    if(product.image.contains("firebase")){
                                                                      userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                      userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                      this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                    }else{
                                                                      userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                        _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                          snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                            userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                            userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                          });
                                                                        });
                                                                      });
                                                                    }
                                                                  }
                                                                });
                                                              }
                                                              setState(() {
                                                                this.isLoading=false;
                                                                this.confirmationPayment=true;
                                                              });
                                                              widget.userProduct.clear();

                                                              if(widget.points>=1){
                                                                if(widget.points<widget.totalBeforePoints){
                                                                  //print("PUNTOS CUANDO ES MENOR:${0}");
                                                                  setState(() {
                                                                    this.isLoading=true;
                                                                  });
                                                                  updateUserPoints(0, widget.userId);
                                                                }else if(widget.points>widget.totalBeforePoints){
                                                                  //print("PUNTOS CUANDO ES MAYOR:${widget.points-widget.totalBeforePoints}");
                                                                  setState(() {
                                                                    this.isLoading=true;
                                                                  });
                                                                  updateUserPoints(widget.points-widget.totalBeforePoints, widget.userId);
                                                                }

                                                              }
                                                            }

                                                            /*  userBloc.updateUserProductsRequestedInfo(//manda la  info básica del pedido del pedido al admin
                                                              User(email: " ", id: snapshot.data["id"],phone:snapshot.data["phoneNumber"],
                                                                  firstName: snapshot.data["firstName"],lastName: snapshot.data["lastName"],userPetName: snapshot.data["petName"]),
                                                              "${widget.adrress}, $residence", widget.total+currentUserBill,widget.latitude,widget.longitude,group);

                                                          if(widget.storeType=="perro"){
                                                            widget.userProduct.forEach((key, product){
                                                              print("ID: ${product.id}");
                                                              if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                this.updateProductStockUnits(product.currentUnitsInStock-product.units, product.id);
                                                                this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                              }else{

                                                                print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                if(contadorParaBusiness==0){
                                                                  userBloc.updateUserProductsRequestedInfoBusiness(product.providerId,
                                                                      snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                      widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                  contadorParaBusiness=1;
                                                                }

                                                                if(product.image.contains("firebase")){
                                                                  userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                  userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                  this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                }else{
                                                                  userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                    _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                      snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                        userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                        userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                      });
                                                                    });
                                                                  });
                                                                }
                                                              }
                                                            });
                                                          }else{
                                                            widget.userProduct.forEach((key, product){
                                                              print("ID: ${product.id}");
                                                              print("CATEOGORIA DEL COSOS: ${product.category}");
                                                              if(product.provider.toUpperCase()=="CERAGRO" || product.provider.toUpperCase()=="FARMASCOTAS"){ //producto ya existen el la tienda que es de fluppy
                                                                print("ID: ${product.id}");
                                                                userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);
                                                                this.updateProductStockUnitsCat(product.currentUnitsInStock-product.units, product.id);
                                                                this.updateProductStockUnitsCategory(product.currentUnitsInStock-product.units, product.id, product.category);
                                                              }else{

                                                                print("EL ID DEL USUIARIO: ${snapshot.data["id"]}");
                                                                print("EL ID DEL BUSINESS: ${product.providerId}");

                                                                if(contadorParaBusiness==0){
                                                                  userBloc.updateUserProductsRequestedInfoBusiness(product.providerId, /////////sube la informacion basica de la compra
                                                                      snapshot.data["id"], widget.adrress, widget.latitude, widget.longitude, group,
                                                                      widget.total+currentUserBill,snapshot.data["phoneNumber"],snapshot.data["petName"]);
                                                                  contadorParaBusiness=1;
                                                                }

                                                                if(product.image.contains("firebase")){
                                                                  userBloc.updateUserProductsRequested(snapshot.data["id"], product,product.image,group);//sube compra al usuario product ya existente
                                                                  userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,product.image,group);//sube compra a la empresa product ya existente
                                                                  this.updateProductStockUnitsBusiness(product.currentUnitsInStock-product.units, product.id, product.providerId, product.category);
                                                                }else{
                                                                  userBloc.uploadFile(product.image,File(product.image),false).then((StorageUploadTask _storageUploadTask){
                                                                    _storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshotImage){
                                                                      snapshotImage.ref.getDownloadURL().then((imageUrl){
                                                                        userBloc.updateUserProductsRequested(snapshot.data["id"], product,imageUrl,group);//sube compra al usuario product no existente
                                                                        userBloc.updateUserProductsRequestedBusiness(snapshot.data["id"], product.providerId, product,imageUrl,group);//sube compra a la empresa product no existente
                                                                      });
                                                                    });
                                                                  });
                                                                }
                                                              }
                                                            });

                                                          }

                                                          widget.userProduct.clear();*/
                                                          }
                                                        }
                                                      }
                                                    },
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                Positioned(
                                  child: isLoading
                                      ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42E695)),
                                      ),
                                    ),
                                    color: Colors.white.withOpacity(0.8),
                                  )
                                      : Container(),
                                ),
                              ],
                            )
                        );
                      }
                    }
                )
                    :
                Container(
                  child: Center(
                      child: Container(
                        // color: Colors.yellow,
                          width: SizeConfig.safeBlockHorizontal*100,
                          height: SizeConfig.safeBlockVertical*50,
                          child: Column(
                              children: <Widget>[
                                Container(
                                  //color: Colors.brown,
                                  width: SizeConfig.safeBlockHorizontal*100,
                                  height: SizeConfig.safeBlockVertical*25,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/checkPayment.png"),
                                      )
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: SizeConfig.safeBlockVertical*2
                                    ),
                                    width: SizeConfig.safeBlockHorizontal*100,
                                    child: Text("Se confirmó tu solicitud, puedes ver tus pedidos en la sección de MIS PEDIDOS",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: SizeConfig.safeBlockVertical*2.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.center,
                                    )
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
                                      text: "Volver",
                                      radius: 10,
                                      textSize: SizeConfig.safeBlockHorizontal* 5,
                                      width: SizeConfig.safeBlockHorizontal*4,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      color:  Color(0xFF53d2be),
                                      textColor: Colors.white,
                                      onPressed: (){
                                        Navigator.pop(context);
                                        Navigator.of(context).pop(MaterialPageRoute(
                                            builder: (context) => StoreScreen(widget.userId,widget.mainContext)));
                                      },
                                    )
                                ),
                              ]
                          )
                      )
                  ),
                ),
              );
            }
        );
      }
    }
  }
  void updateProductStockUnits(int newUnits, String productId)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection('productStore').document(productId), {"existingUnits": newUnits});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT UNITS EN STOCK PRODUCT STORE");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LAS UNITS EN STOCK EN FIREBASE EN PRODUCT STORE: $err");
    });
  }


  void updateProductStockUnitsBusiness(int newUnits, String productId,businessId, String category)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection('businessesProducts').document(businessId).collection("$category").document(productId), {"existingUnits": newUnits});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT UNITS EN STOCK BUSINESS");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LAS UNITS EN STOCK EN FIREBASE BUSINESS: $err");
    });
  }


  void updateProductStockUnitsBusinessCat(int newUnits, String productId,businessId, String businessName)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection('businessesProducts').document(businessId).collection("${businessName}Gato").document(productId), {"existingUnits": newUnits});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT UNITS EN STOCK BUSINESS CAT");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LAS UNITS EN STOCK EN FIREBASE BUSINESS CAT: $err");
    });
  }


  void updateProductStockUnitsCat(int newUnits, String productId)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection('productStoreCat').document(productId), {"existingUnits": newUnits});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT UNITS EN STOCK PRODUCT STORE CAT");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LAS UNITS EN STOCK EN FIREBASE STORE CAT: $err");
    });
  }


  void updateProductStockUnitsCategory(int newUnits, String productId, String category)async{
    print("Categoría: $category");
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection(category).document(productId), {"existingUnits": newUnits});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT UNITS EN STOCK CATEGORIA");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LAS UNITS EN STOCK EN FIREBASE EN LA CATEGORIA: $err");
    });
  }



  void updateUserPoints(int points, String userId)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection("users").document(userId), {"points": points});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ LAS CURRENT POINTS");
      setState(() {
        this.isLoading=false;
      });
    }
    ).catchError((err){
      print("HUBO UN ERROR AL ACTUALIZAR LOS POINTS EN FIREBASE: $err");
      setState(() {
        this.isLoading=false;
      });
    });
  }


Future<double> getDistance( double startLatitude, double startLongitude, double endLatitude, double endLongitude) async{
  double distance = await Geolocator().distanceBetween( startLatitude, startLongitude, endLatitude, endLongitude);
  return distance;
}

}
class StripeTransactionsResponse{
  String message;
  bool success;
  StripeTransactionsResponse(this.message,this.success);
}


class StripeServices {
  //sk_live_2lgflIqKWXtkRAuCsin2q8fU00VyeEiiNB
  // sk_test_gvvEaxgNv0Mp2zV1AIUUFcn300RBt4js8R
  static String apiSecret = "sk_live_2lgflIqKWXtkRAuCsin2q8fU00VyeEiiNB";
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeServices.apiSecret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<StripeTransactionsResponse> payWithNewCard(String amount,
      String currency) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntentMethod = await StripeServices.createPaymentIntent(
          amount, currency);
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntentMethod['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return StripeTransactionsResponse(
            "EXISTOSO",
            true
        );
      } else {
        return StripeTransactionsResponse(
            "FALLIDO",
            false
        );
      }
    } catch (e) {
      return StripeTransactionsResponse(
          "FALLIDO",
          false
      );
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var response = await http.post(
          StripeServices.paymentApiUrl,
          body: body,
          headers: StripeServices.headers
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("******************************************************************OCURRIÓ UN ERROR $e");
    }
    return null;
  }


}
