import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/support.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class CouponScreen extends StatefulWidget {
  User user;
  CouponScreen(this.user);
  @override
  _CouponScreen createState() => _CouponScreen();
}

class _CouponScreen extends State<CouponScreen> {
  String couponId;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  double _stars = 3;
  final formKey = GlobalKey<FormState>();


  Widget _handle() {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.user.id).snapshots(),
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
            return insertCoupon(snapshot.data["email"], snapshot.data["id"]);

          }
        }
    );
  }

  Widget insertCoupon(String email, String id){
    return Scaffold(
      body:  Container(
        //color:  Color(0xFF211551),
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 4
                      ),
                      // color: Colors.orange,
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 10,
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
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(

                                    Icons.arrow_back,
                                    color: Color(0xFF211551),//Colors.white,
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                )
                            )
                        ),
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical*2
                    ),
                    width: SizeConfig.safeBlockHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 38,
                    //color: Colors.green,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal * 50,
                            height: SizeConfig.blockSizeVertical * 28,
                            child: CachedNetworkImage(
                              imageUrl: "https://static.wixstatic.com/media/07fea2_b08a03fd10354ae594a8bee80ea2d3e9~mv2.png/v1/fill/w_342,h_204,al_c,usm_0.66_1.00_0.01/FluppyCupones.png",
                            ),
                          ),
                          Container(
                            // color: Colors.purple,
                            width: SizeConfig.safeBlockHorizontal * 70,
                            height: SizeConfig.blockSizeVertical * 9,
                            child: Text("Ingresa el código de tu cupón",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  color:  Color(0xFF211551),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      //top: SizeConfig.safeBlockVertical*5,
                      left: SizeConfig.safeBlockHorizontal * 10,
                      right: SizeConfig.safeBlockHorizontal * 10,
                    ),
                    height: SizeConfig.safeBlockHorizontal*16,
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
                        couponId = input;
                        print(couponId);
                      },
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: "Código",
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
                      top: SizeConfig.safeBlockVertical * 2,
                    ),
                    child: GenericButton(
                      text: "¡Lo quiero!",
                      radius: 10,
                      textSize: SizeConfig.blockSizeVertical * 2.5,
                      width: SizeConfig.safeBlockHorizontal * 55,
                      height: SizeConfig.safeBlockHorizontal* 15,
                      color: Color(0xFF211551),
                      textColor: Colors.white,
                      onPressed: () {
                        checkCoupon(_controllerSuggestion.text,widget.user);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void updateUserCoupon(String userId,String couponId)async{
    Firestore.instance.collection('users').document(userId).updateData({'couponId': couponId});
  }



  void addUserToCouponList(String couponId, User user){
    userBloc.updateUserToCoupon(couponId, user);
  }


  void updateUserCoins(User user, int couponCoins) async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection("users").document(user.id), {"points": couponCoins+user.userPoints});
    await batch.commit().then((value)async{
      print("SE ACTUALIZÓ EL TAMAÑO");
    }
    ).catchError((err){
      print("HUBO UN ERROR AL MOMENTO DE ACTUALIZAR LA DESCRIPCION");
    });
  }


  checkCoupon(String coupon,User user)async{ //mira si el cupon existe
    print("EL CUPÓN ES: $coupon");
    try{
      final couponSnapShot= await Firestore.instance.collection("coupons").document(coupon.toUpperCase()).get();
      if(couponSnapShot.exists){
        print("EL CUPÓN EXISTE");
        print("LOS PUNTOS DEL CUPON SONNNNNN: ${couponSnapShot.data["points"]}");
        _controllerSuggestion.clear();
        checkUserCouponAvailable(coupon, user,couponSnapShot.data["points"]);
      }else if(!couponSnapShot.exists){
        Fluttertoast.showToast(
            msg: "El código no es válido",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            timeInSecForIos: 5);
        print("EL CUPÓN NOOOO EXISTE");
      }
    }catch(e){
      Fluttertoast.showToast(
          msg: "El código no es válido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 5);
    }
  }


  checkUserCouponAvailable(String coupon,User user,int couponCoins)async{//mira si el usuario ya usó el cupon
    try{
      final couponSnapShot= await Firestore.instance.collection("coupons").document(coupon.toUpperCase()).collection("usersViculated").document(user.id).get();
      if(couponSnapShot.exists){
        print("EL USUARIO YA TIENE EL CUPON EXISTE");
        Fluttertoast.showToast(
            msg: "El código ya lo usaste",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            timeInSecForIos: 5);

      }else if(!couponSnapShot.exists){
        print("EL USUARIO NOOO TIENE EL CUPON EXISTE");
        Fluttertoast.showToast(
            msg: "Se cangeó con éxito",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            timeInSecForIos: 5);
        updateUserCoins(user,couponCoins);
        addUserToCouponList(coupon, user);
      }
    }catch(e){
      Fluttertoast.showToast(
          msg: "El código no es válido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 5);
    }
  }




  Future<void> erraseCoupon(String couponId){
    return Firestore.instance.collection('coupons').document(couponId).delete();
  }

  void alertDialog(BuildContext context){
    print("Contexto: ${context.toString()}");
    var alert= AlertDialog(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      content: Container(
        //color: Colors.red,
        height: SizeConfig.safeBlockVertical*20,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*9,
                  child: Center(
                    child: Text("Se envío tu mensaje, pronto te responderemos por correo",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.safeBlockVertical*2.3,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  //color: Colors.yellow,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*11,
                  child: Center(
                    child: Container(
                        height:  SizeConfig.safeBlockVertical*12,
                        child: Icon(
                          CustomIcons.checkmark_cicle,
                          color: Colors.green,
                          size: SizeConfig.blockSizeVertical*3,
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context)=>alert
    );
  }
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return _handle();
  }



}