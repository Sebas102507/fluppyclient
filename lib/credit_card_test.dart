import 'dart:convert';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
class TestCreditCard extends StatefulWidget {
  @override
  _TestCreditCardState createState() => _TestCreditCardState();
}

class _TestCreditCardState extends State<TestCreditCard> {
  UserBloc userBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;

  void setError(dynamic error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }
  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_WyaFPAE5VT7Ba0YpuhDO08NC002kKFm8ab", merchantId: "Test", androidPayMode: 'test'));
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: RaisedButton(
            color: Colors.green,
            onPressed: () async{
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

          },child: Text("Añadir tarjeta"),
          ),
        )
      ),
    );
  }

}

class StripeTransactionsResponse{
  String message;
  bool success;
  StripeTransactionsResponse(this.message,this.success);
}


class StripeServices{
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

}