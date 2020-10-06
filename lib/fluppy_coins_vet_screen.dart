import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FluppyCoinsVetScreen extends StatefulWidget {

  String userId;

  FluppyCoinsVetScreen(this.userId);

  @override
  _FluppyCoinsVetScreen createState() => _FluppyCoinsVetScreen();
}

class _FluppyCoinsVetScreen extends State<FluppyCoinsVetScreen> {
  final formKey = GlobalKey<FormState>();
  final _controllerUserEmail = TextEditingController();
  int currentPoints=0;
  int sizeNumber=1;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Color(0xFF211551)),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text("ERROR"),
              ),
            );
          } else {
            return Scaffold(
                body:  Stack(
                  children: [
                    Container(
                        color:  Color(0xFF0048cd),
                        width: SizeConfig.safeBlockHorizontal*100,
                        height: SizeConfig.safeBlockVertical * 160,
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
                                                  color: Colors.white,
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
                                  height: SizeConfig.blockSizeVertical * 40,
                                  //color: Colors.green,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal * 50,
                                          height: SizeConfig.blockSizeVertical * 28,
                                          child: CachedNetworkImage(
                                            imageUrl: "https://static.wixstatic.com/media/07fea2_86204f9a7a384ed290a02caa7d49f5a4~mv2.png",
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.purple,
                                          width: SizeConfig.safeBlockHorizontal * 80,
                                          height: SizeConfig.blockSizeVertical * 12,
                                          child: Text("Ingresa el id de tu Vet y elige la cantidad de coins que vas usar",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color:  Colors.white,
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
                                    //color: Colors.red,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _controllerUserEmail,
                                    maxLines: 12,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Campo inválido";
                                      }
                                      return null;
                                    },
                                    onSaved: (input) {

                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Id",
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
                                  // color: Colors.blueGrey,
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockVertical*2
                                    ),
                                    height: SizeConfig.safeBlockVertical*8,
                                    width: SizeConfig.safeBlockHorizontal*60,
                                    //color: Colors.deepPurpleAccent,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            //color: Colors.yellow,
                                              width: SizeConfig.blockSizeHorizontal*15,
                                              height: SizeConfig.blockSizeVertical * 7,
                                              //color: Colors.orange,
                                              child: Container(
                                                  child: IconButton(
                                                      icon: Icon(Icons.remove_circle_outline, color: Colors.white,size: SizeConfig.safeBlockVertical*6,),
                                                      onPressed: (){
                                                        if(this.currentPoints>1){
                                                          setState(() {
                                                            this.currentPoints=this.currentPoints-500;
                                                          });
                                                        }
                                                        if(this.currentPoints>0){
                                                          if( this.currentPoints<1000 || this.currentPoints==10000 || this.currentPoints==100000){
                                                            setState(() {
                                                              this.sizeNumber=this.sizeNumber-10;
                                                            });
                                                          }
                                                        }
                                                        print("RESTAR");
                                                      }
                                                  )
                                              )
                                          ),
                                          Container(
                                              width: SizeConfig.blockSizeHorizontal*30,
                                              height: SizeConfig.blockSizeVertical * 5,
                                              //color: Colors.red,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("${this.currentPoints}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.safeBlockVertical*4
                                                  ),
                                                ),
                                              )
                                          ),
                                          Container(
                                            //color: Colors.yellow,
                                              width: SizeConfig.blockSizeHorizontal*15,
                                              height: SizeConfig.blockSizeVertical * 7,
                                              //color: Colors.lightGreen,
                                              child: Container(
                                                  child: IconButton(
                                                      icon: Icon(Icons.add_circle_outline, color: Colors.white,size: SizeConfig.safeBlockVertical*6,),
                                                      onPressed: (){
                                                        if(this.currentPoints<snapshot.data["points"]){
                                                          setState(() {
                                                            this.currentPoints=this.currentPoints+500;
                                                          });
                                                          if(this.currentPoints<=1000 || this.currentPoints==10000 || this.currentPoints==100000){
                                                            setState(() {
                                                              this.sizeNumber=this.sizeNumber+10;
                                                            });
                                                          }
                                                        }
                                                        print("SUMAR");
                                                      }
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                ),



                                Container(
                                  margin: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical * 2,
                                  ),
                                  child: GenericButton(
                                    text: "Canjear Coins",
                                    radius: 10,
                                    textSize: SizeConfig.blockSizeVertical * 2.5,
                                    width: SizeConfig.safeBlockHorizontal * 55,
                                    height: SizeConfig.safeBlockHorizontal* 15,
                                    color: Colors.white,
                                    textColor: Color(0xFF0048cd),
                                    onPressed: () {
                                      if(this.currentPoints==0){
                                        Fluttertoast.showToast(
                                            msg: "Coins inválidos",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                      }else{
                                        setState(() {
                                          this.isLoading=true;
                                        });
                                        checkPoints(this._controllerUserEmail.text,snapshot.data["points"],this.currentPoints);

                                      }
                                    },
                                  ),
                                )
                              ],
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
    );

  }
  checkPoints(String vetNit, int userCoins, int coinsToUse) async{
    await Firestore.instance.collection('businesses').where(
        "nit",
        isEqualTo: vetNit
    ).getDocuments().then((event) {
      if (event.documents.isNotEmpty) {
        print("Síiiiii existe");
        Map<String, dynamic> documentData = event.documents.single.data;//if it is a single document
        print("Correo:${documentData["email"]} ");
        payWithCoins(documentData["id"], documentData["debt"], userCoins, coinsToUse);
      }else{
        print("No existeee: ");
        setState(() {
          this.isLoading=false;
        });
        Fluttertoast.showToast(
            msg: "Id inválido",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            timeInSecForIos: 2);
      }
    }).catchError((e){
      print("Hubo un error: $e");
      setState(() {
        this.isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Ocurrió un error, inténtalo más tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
    });
  }

  payWithCoins(String vetDocumentId,int vetDebt, int userCoins, int coinsToUse) async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection("users").document(widget.userId), {"points": userCoins-coinsToUse});
    batch.updateData(db.collection("businesses").document(vetDocumentId), {"debt": vetDebt+coinsToUse});
    // batch.updateData(db.collection('linkedService').document("${widget.walker.id}-${widget.client.id}"), {"walketLongitude": walkerLocation.longitude});
    await batch.commit().then((value){
      print("SE USARON CORRECTAMENTE LOS COINS");
      setState(() {
        this.isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "¡¡Listo!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
      Navigator.of(context).pop();
    }
    ).catchError((err){
      print("HUBO UN ERROR AL MOMENTO DE USAR LOS COINS: $err");
      setState(() {
        this.isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Ocurrió un error, inténtalo más tarde",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
    });
  }


}