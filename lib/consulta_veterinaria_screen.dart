import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
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
import 'package:http/http.dart' as http;

class ConsultaVetScreen extends StatefulWidget {
  String userId;
  String userPetType;
  String userPetName;
  ConsultaVetScreen({Key key, this.userId,this.userPetName,this.userPetType});
  @override
  _ConsultaVetScreen createState() => _ConsultaVetScreen();
}

class _ConsultaVetScreen extends State<ConsultaVetScreen> {
  String _description;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    /*StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_WyaFPAE5VT7Ba0YpuhDO08NC002kKFm8ab", merchantId: "Test", androidPayMode: 'test'));*/
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100 ,
                    height: SizeConfig.blockSizeVertical*35,
                    decoration: BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight:Radius.circular(20),
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
                                            Navigator.of(context).pop(MaterialPageRoute(
                                                builder: (context) => HomeScreen()));
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
                            height: SizeConfig.blockSizeVertical * 22,
                            //color: Colors.redAccent,
                            child: Center(
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal* 90,
                                  height: SizeConfig.blockSizeVertical * 22,
                                  //color: Colors.orange,
                                  child: CachedNetworkImage(
                                    imageUrl: "https://static.wixstatic.com/media/07fea2_2bf0edd07ac44ff7ae3daf9ed106d307~mv2.png",
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
                          width: SizeConfig.blockSizeHorizontal* 95,
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical*2
                          ),
                          //color: Colors.orange,
                          child: Text("Bienvenido al servicio online de veterinaria",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RobotoRegular",
                              color: Colors.blue[500],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal* 95,
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical*2
                          ),
                          //color: Colors.orange,
                          child: Text("Con el servicio de consulta veterinaria 24h de Fluppy podrás tener una consulta virtual con un profesional, Resuelve alguna duda que tengas, solicita ayuda o instrucciones en caso de que tu mascota presenta algún síntoma anormal, recibe sugerencias nutricionales, dermatológicas y de comportamiento.",
                            style: TextStyle(
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                              fontFamily: "RobotoRegular",
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*1,
                          ),
                          height: SizeConfig.safeBlockVertical * 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.deepPurple,
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
                            onSaved: (input) {
                              _description = input;
                              print(_description);
                            },
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                hintText: "¿Quieres agregar algo antes de tu consulta?",
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2
                                    )
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2
                                    )
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical*1,
                            //left: SizeConfig.safeBlockHorizontal * 2,
                          ),
                          width: SizeConfig.blockSizeHorizontal*100 ,
                          //color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: SizeConfig.blockSizeHorizontal*25,
                                height: SizeConfig.blockSizeVertical * 5,
                                child: RaisedButton(
                                    onPressed: () async{
                                      /*
                                      print(_controllerSuggestion.text);
                                      var response= await StripeServices.payWithNewCard("35000000","cop");
                                      if(response.success==true){
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }
                                      */

                                    },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Colors.blue[500],
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text("5 min",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "RobotoRegular",
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text("\$15,000",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "RobotoRegular",
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ),
                              ),
                              Container(
                                width: SizeConfig.blockSizeHorizontal*25,
                                height: SizeConfig.blockSizeVertical * 5,
                                child: RaisedButton(
                                    onPressed: () async{
                                      /*
                                      print(_controllerSuggestion.text);
                                      var response= await StripeServices.payWithNewCard("35000000","cop");
                                      if(response.success==true){
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }
                                      */
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: Colors.blue[500],
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text("10 min",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text("\$30,000",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Container(
                                width: SizeConfig.blockSizeHorizontal*25,
                                height: SizeConfig.blockSizeVertical * 5,
                                child: RaisedButton(
                                    onPressed: () async{
                                     /*
                                      print(_controllerSuggestion.text);
                                      var response= await StripeServices.payWithNewCard("35000000","cop");
                                      if(response.success==true){
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: response.message,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }*/
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: Colors.blue[500],
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text("15 min",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text("\$45,000",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ],
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

/*class StripeTransactionsResponse{
  String message;
  bool success;
  StripeTransactionsResponse(this.message,this.success);
}*/


/*class StripeServices{
  static String apiSecret="sk_test_gvvEaxgNv0Mp2zV1AIUUFcn300RBt4js8R";
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static Map<String,String> headers={
    'Authorization': 'Bearer ${StripeServices.apiSecret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Future<StripeTransactionsResponse> payWithNewCard(String amount,String currency) async{
    try{
      var paymentMethod= await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var paymentIntentMethod= await StripeServices.createPaymentIntent(amount, currency);
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
    }catch(e){
      return StripeTransactionsResponse(
          "FALLIDO",
          false
      );
    }
  }

  static Future<Map<String,dynamic>>createPaymentIntent(String amount, String currency) async{
    try{
      Map<String,dynamic> body= {
        "amount": amount,
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var response= await http.post(
          StripeServices.paymentApiUrl,
          body:body,
          headers: StripeServices.headers
      );
      return jsonDecode(response.body);
    }catch(e){
      print("OCURRIÓ UN ERROR $e");
    }
    return null;
  }

}*/