import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
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


class PersonalizeMandi extends StatefulWidget {
  String userId;
  Map<String, Product>userProducts;
  String provider;
  String businessId;
  BuildContext mainContext;
  Color productBackgroundColor;
  String type;
  PersonalizeMandi({Key key,this.userId,this.userProducts,
    this.provider,this.businessId,this.mainContext,this.productBackgroundColor,this.type});
  @override
  _PersonalizeMandi createState() => _PersonalizeMandi();
}

class _PersonalizeMandi extends State<PersonalizeMandi> {
  UserBloc userBloc;
  String name;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final _controllerPetName = TextEditingController();
  Function mathFunc = (Match match) => '${match[1]},';
  int cantPlatosGroup=-1;
  int tamanosPlatosGroup=-1;
  int alturaComedorGroup=-1;
  int colorComedorGroup=-1;
  int figuraDecorativaComedorGroup=-1;

  int tamanosPlatosPrice=0;
  ///////textoOpciones
  String cantPlatosNombre;
  String tamanosPlatosNombre;
  String alturaComedorNombre;
  String colorComedorNombre;
  String figuraDecorativaComedorNombre;

  String image;
  File imageFile;
  int total=0;
  final formKey = new GlobalKey<FormState>();

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.imageFile=image;
      this.image = image.path;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: ${this.image}");
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

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
    print("PROVIDER:${widget.provider}");
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal*100 ,
                      height: SizeConfig.blockSizeVertical*40,
                      decoration: BoxDecoration(
                          color: widget.productBackgroundColor,
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
                              height: SizeConfig.blockSizeVertical * 28,
                              //color: Colors.redAccent,
                              child: Center(
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal* 50,
                                    height: SizeConfig.blockSizeVertical * 28,
                                    //color: Colors.orange,
                                    /*child: CachedNetworkImage(
                                    //imageUrl: widget.image,
                                  ),*/
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
                          imageHandle(),
                          cantPlatos(),
                          tamPlatos(),
                          alturaComedor(),
                          colorComedor(),
                          figuraComedor()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget cantPlatos(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical*1
            ),
            //color: Colors.red,
            width: double.infinity,
            child: Text("Cantidad de platos",
              style: TextStyle(
                color:  Color(0xFFe74b64),
                fontSize: SizeConfig.safeBlockVertical*2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 0,
                  groupValue:cantPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      cantPlatosGroup=value;
                      this.cantPlatosNombre="Sencillo";

                    });
                  }
              ),
              Text("Sencillo",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 1,
                  groupValue:cantPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      cantPlatosGroup=value;
                      this.cantPlatosNombre="Doble";
                    });
                  }
              ),
              Text("Doble",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 2,
                  groupValue:cantPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      cantPlatosGroup=value;
                      this.cantPlatosNombre="Triple";

                    });
                  }
              ),
              Text("Triple",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
        ],
      ),
    );
  }
  Widget tamPlatos(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical*1
            ),
            //color: Colors.red,
            width: double.infinity,
            child: Text("Tamaños de los platos",
              style: TextStyle(
                color:  Color(0xFFe74b64),
                fontSize: SizeConfig.safeBlockVertical*2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 0,
                  groupValue:tamanosPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      tamanosPlatosGroup=value;
                      this.tamanosPlatosPrice=148000;
                      this.tamanosPlatosNombre="S";
                    });
                  }
              ),
              Text("S",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 1,
                  groupValue:tamanosPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      tamanosPlatosGroup=value;
                      this.tamanosPlatosPrice=168000;
                      this.tamanosPlatosNombre="M";
                    });
                  }
              ),
              Text("M",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 2,
                  groupValue:tamanosPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      tamanosPlatosGroup=value;
                      this.tamanosPlatosPrice=188000;
                      this.tamanosPlatosNombre="L";
                    });
                  }
              ),
              Text("L",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 3,
                  groupValue:tamanosPlatosGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      tamanosPlatosGroup=value;
                      this.tamanosPlatosPrice=208000;
                      this.tamanosPlatosNombre="XL";
                    });
                  }
              ),
              Text("XL",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
        ],
      ),
    );
  }
  Widget alturaComedor(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical*1
            ),
            //color: Colors.red,
            width: double.infinity,
            child: Text("Altura del comedor",
              style: TextStyle(
                color:  Color(0xFFe74b64),
                fontSize: SizeConfig.safeBlockVertical*2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 0,
                  groupValue:alturaComedorGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      alturaComedorGroup=value;
                      this.alturaComedorNombre="12cm";
                    });
                  }
              ),
              Text("12 cm",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 1,
                  groupValue:alturaComedorGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      alturaComedorGroup=value;
                      this.alturaComedorNombre="20cm";
                    });
                  }
              ),
              Text("20 cm",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 2,
                  groupValue:alturaComedorGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      alturaComedorGroup=value;
                      this.alturaComedorNombre="28cm";
                    });
                  }
              ),
              Text("28 cm",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                  focusColor: Color(0xFFe74b64),
                  value: 3,
                  groupValue:alturaComedorGroup,
                  onChanged: (value){
                    print("VALUE: $value");
                    setState(() {
                      print("Cambio");
                      alturaComedorGroup=value;
                      this.alturaComedorNombre="38cm";
                    });
                  }
              ),
              Text("38 cm",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
            ],
          ),
        ],
      ),
    );
  }

  Widget colorComedor(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical*1
            ),
            //color: Colors.red,
            width: double.infinity,
            child: Text("Color del comedor",
              style: TextStyle(
                color:  Color(0xFFe74b64),
                fontSize: SizeConfig.safeBlockVertical*2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
             Container(
               width: SizeConfig.blockSizeHorizontal*50,

               //color: Colors.amber,
               child:  Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 0,
                           groupValue:colorComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               colorComedorGroup=value;
                               this.colorComedorNombre="Rosado Coral";
                             });
                           }
                       ),

                       Text("Rosado Coral",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         margin: EdgeInsets.only(
                             left: SizeConfig.blockSizeHorizontal*2
                         ),
                         width: SizeConfig.blockSizeVertical*2,
                         height: SizeConfig.blockSizeVertical*2,
                         decoration: BoxDecoration(
                             color: Color(0xFFe57a72),
                             borderRadius: BorderRadius.all(Radius.circular(100))
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 1,
                           groupValue:colorComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               colorComedorGroup=value;
                               this.colorComedorNombre="Fucsia Romántico";
                             });
                           }
                       ),
                       Text("Fucsia Romántico",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
                       ,
                       Container(
                         margin: EdgeInsets.only(
                             left: SizeConfig.blockSizeHorizontal*2
                         ),
                         width: SizeConfig.blockSizeVertical*2,
                         height: SizeConfig.blockSizeVertical*2,
                         decoration: BoxDecoration(
                             color: Color(0xFFc24b71),
                             borderRadius: BorderRadius.all(Radius.circular(100))
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 2,
                           groupValue:colorComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               colorComedorGroup=value;
                               this.colorComedorNombre="Sendero de lilas";
                             });
                           }
                       ),
                       Text("Sendero de lilas",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
                       ,
                       Container(
                         margin: EdgeInsets.only(
                             left: SizeConfig.blockSizeHorizontal*2
                         ),
                         width: SizeConfig.blockSizeVertical*2,
                         height: SizeConfig.blockSizeVertical*2,
                         decoration: BoxDecoration(
                             color: Color(0xFFb4a9c9),
                             borderRadius: BorderRadius.all(Radius.circular(100))
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 3,
                           groupValue:colorComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               colorComedorGroup=value;
                               this.colorComedorNombre="Sensación púrpura";
                             });
                           }
                       ),
                       Text("Sensación púrpura",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         margin: EdgeInsets.only(
                             left: SizeConfig.blockSizeHorizontal*2
                         ),
                         width: SizeConfig.blockSizeVertical*2,
                         height: SizeConfig.blockSizeVertical*2,
                         decoration: BoxDecoration(
                             color: Color(0xFF7a5483),
                             borderRadius: BorderRadius.all(Radius.circular(100))
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 4,
                           groupValue:colorComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               colorComedorGroup=value;
                               this.colorComedorNombre="Verde Herbál";
                             });
                           }
                       ),
                       Text("Verde Herbál",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         margin: EdgeInsets.only(
                             left: SizeConfig.blockSizeHorizontal*2
                         ),
                         width: SizeConfig.blockSizeVertical*2,
                         height: SizeConfig.blockSizeVertical*2,
                         decoration: BoxDecoration(
                             color: Color(0xFF96d4bb),
                             borderRadius: BorderRadius.all(Radius.circular(100))
                         ),
                       )
                     ],
                   ),
                 ],
               ),
             ),
            Container(
              width: SizeConfig.blockSizeHorizontal*50,
              //color: Colors.greenAccent,
              child:   Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Radio(
                          focusColor: Color(0xFFe74b64),
                          value: 5,
                          groupValue:colorComedorGroup,
                          onChanged: (value){
                            print("VALUE: $value");
                            setState(() {
                              print("Cambio");
                              colorComedorGroup=value;
                              this.colorComedorNombre="Uva verde";
                            });
                          }
                      ),
                      Text("Uva verde",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2
                        ),
                        width: SizeConfig.blockSizeVertical*2,
                        height: SizeConfig.blockSizeVertical*2,
                        decoration: BoxDecoration(
                            color: Color(0xFFb0cd61),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                          focusColor: Color(0xFFe74b64),
                          value: 6,
                          groupValue:colorComedorGroup,
                          onChanged: (value){
                            print("VALUE: $value");
                            setState(() {
                              print("Cambio");
                              colorComedorGroup=value;
                              this.colorComedorNombre="Azul caribe";
                            });
                          }
                      ),
                      Text("Azul caribe",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2
                        ),
                        width: SizeConfig.blockSizeVertical*2,
                        height: SizeConfig.blockSizeVertical*2,
                        decoration: BoxDecoration(
                            color: Color(0xFF11a9aa),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                          focusColor: Color(0xFFe74b64),
                          value: 7,
                          groupValue:colorComedorGroup,
                          onChanged: (value){
                            print("VALUE: $value");
                            setState(() {
                              print("Cambio");
                              colorComedorGroup=value;
                              this.colorComedorNombre="Azul pacífico";
                            });
                          }
                      ),
                      Text("Azul pacífico",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2
                        ),
                        width: SizeConfig.blockSizeVertical*2,
                        height: SizeConfig.blockSizeVertical*2,
                        decoration: BoxDecoration(
                            color: Color(0xFF136884),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                          focusColor: Color(0xFFe74b64),
                          value: 8,
                          groupValue:colorComedorGroup,
                          onChanged: (value){
                            print("VALUE: $value");
                            setState(() {
                              print("Cambio");
                              colorComedorGroup=value;
                              this.colorComedorNombre="Rojo amoroso";
                            });
                          }
                      ),
                      Text("Rojo amoroso",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2
                        ),
                        width: SizeConfig.blockSizeVertical*2,
                        height: SizeConfig.blockSizeVertical*2,
                        decoration: BoxDecoration(
                            color: Color(0xFFc02918),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                          focusColor: Color(0xFFe74b64),
                          value: 9,
                          groupValue:colorComedorGroup,
                          onChanged: (value){
                            print("VALUE: $value");
                            setState(() {
                              print("Cambio");
                              colorComedorGroup=value;
                              this.colorComedorNombre="Negro azabache";
                            });
                          }
                      ),
                      Text("Negro azabache",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*2
                        ),
                        width: SizeConfig.blockSizeVertical*2,
                        height: SizeConfig.blockSizeVertical*2,
                        decoration: BoxDecoration(
                            color: Color(0xFF030406),
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
            ],
          )
        )
        ],
      ),
    );
  }



  Widget figuraComedor(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical*1
            ),
            //color: Colors.red,
            width: double.infinity,
            child: Text("Figura decorativa",
              style: TextStyle(
                color:  Color(0xFFe74b64),
                fontSize: SizeConfig.safeBlockVertical*2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
         Row(
           children: <Widget>[
             Container(
               width: SizeConfig.blockSizeHorizontal*50,
               //color: Colors.amber,
               child: Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 0,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Huesos";
                             });
                           }
                       ),
                       Text("Huesos",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_d5db09ac70154a83b598f22d34bb336f~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 1,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Peces";
                             });
                           }
                       ),
                       Text("Peces",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_291b0c6da96b4655a88b52f2c7416d3e~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 2,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Corazones";
                             });
                           }
                       ),
                       Text("Corazones",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_7566d9d02d1d42ce8379501c1a558507~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 3,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Coronas";
                             });
                           }
                       ),
                       Text("Coronas",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_13dcd3bc9a734aa5a4a04277a51ce054~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 4,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Galletas";
                             });
                           }
                       ),
                       Text("Galletas",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_38b78bfe7c9a47c195f3da25c7b1319b~mv2.png",
                         ),
                       )
                     ],
                   ),
                 ],
               ),
             ),
             Container(
               width: SizeConfig.blockSizeHorizontal*45,
               //color: Colors.greenAccent,
               child: Column(
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 5,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Balones";
                             });
                           }
                       ),
                       Text("Balones",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_0faac5b8dd4f47e0bd742a493bc12c86~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 6,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Sandías";
                             });
                           }
                       ),
                       Text("Sandías",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_b87b8ad834e7409797388131a32781bb~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 7,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Superman";
                             });
                           }
                       ),
                       Text("Superman",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_3293b290695c4683ad984a074d8136f2~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 8,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Arcoiris";
                             });
                           }
                       ),
                       Text("Arcoiris",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),),
                       Container(
                         width: SizeConfig.blockSizeVertical*3,
                         height: SizeConfig.blockSizeVertical*3,
                         child: CachedNetworkImage(
                           imageUrl: "https://static.wixstatic.com/media/07fea2_ded76ce2e30e4c4c8bebb7770b7b4b21~mv2.png",
                         ),
                       )
                     ],
                   ),
                   Row(
                     children: <Widget>[
                       Radio(
                           focusColor: Color(0xFFe74b64),
                           value: 9,
                           groupValue:figuraDecorativaComedorGroup,
                           onChanged: (value){
                             print("VALUE: $value");
                             setState(() {
                               print("Cambio");
                               figuraDecorativaComedorGroup=value;
                               this.figuraDecorativaComedorNombre="Ninguno";
                             });
                           }
                       ),
                       Text("Ninguno",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*1.5),)
                     ],
                   ),
                 ],
               ),
             )
           ],
         ),
          Container(
              margin: EdgeInsets.only(
                  bottom:  SizeConfig.safeBlockVertical*2
              ),
              width: SizeConfig.blockSizeHorizontal*100,
            height: SizeConfig.safeBlockVertical*10,
            //color: Colors.amber,
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal*55,
                      height: SizeConfig.safeBlockVertical*10,
                      child: Row(
                        children: <Widget>[
                          Text("Total: \$",style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*3),),
                          Text((this.tamanosPlatosPrice).toString().replaceAllMapped(reg, mathFunc),style: TextStyle(color: Color(0xFFe74b64),fontSize: SizeConfig.safeBlockVertical*3),),

                        ],
                      ),
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal*40,
                      height: SizeConfig.safeBlockVertical*7,
                      child:      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal*0.5
                        ),
                        width: SizeConfig.blockSizeHorizontal*25,
                        height: SizeConfig.blockSizeVertical * 5,
                        // color: Colors.amber,
                        child: RaisedButton(
                          // padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: (this.figuraDecorativaComedorGroup==-1 ||
                                this.colorComedorGroup==-1 ||
                                this.alturaComedorGroup==-1||
                                this.tamanosPlatosGroup==-1||
                                this.cantPlatosGroup==-1 || this.image==null ) ? Colors.grey : widget.productBackgroundColor,
                            onPressed: (){

                              if(this.figuraDecorativaComedorGroup==-1){
                                Fluttertoast.showToast(
                                    msg: "Elige una figura decorativa",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if(this.colorComedorGroup==-1){
                                Fluttertoast.showToast(
                                    msg: "Elige un color del comedor",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if(this.alturaComedorGroup==-1){
                                Fluttertoast.showToast(
                                    msg: "Elige la altura de los platos",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if(this.tamanosPlatosGroup==-1){
                                Fluttertoast.showToast(
                                    msg: "Elige un tamaño de platos",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if(this.cantPlatosGroup==-1 ){
                                Fluttertoast.showToast(
                                    msg: "Elige una cantidad de platos",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if( this.image==null){
                                Fluttertoast.showToast(
                                    msg: "Elige una imagen",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else if(this._controllerPetName.text==null || this._controllerPetName.text=="" || this._controllerPetName.text==" "){
                                Fluttertoast.showToast(
                                    msg: "Nombre no valido",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                              }else{
                                this.total= this.total+this.tamanosPlatosPrice;
                                print("CantPlatos: ${this.cantPlatosNombre}");
                                print("TamPlatos: ${this.tamanosPlatosNombre}");
                                print("AlturaPlatos: ${this.alturaComedorNombre}");
                                print("ColorPlatos: ${this.colorComedorNombre}");
                                print("Figura: ${this.figuraDecorativaComedorNombre}");
                                print("Nombre de la mascota: ${this._controllerPetName.text}");

                                widget.userProducts.putIfAbsent("Comedor para ${this._controllerPetName.text}", () =>
                                    Product(productName: "Comedor para ${this._controllerPetName.text}",price: this.total,
                                        units: 1,image: this.image,
                                        description: ("${this.cantPlatosNombre}, ${this.tamanosPlatosNombre}, ${this.alturaComedorNombre}, ${this.colorComedorNombre}, ${this.figuraDecorativaComedorNombre}"),
                                        provider: widget.provider,
                                        providerId: widget.businessId,
                                        category: "Mandi${widget.type}",
                                    ));

                                Fluttertoast.showToast(
                                    msg: "Se agregó al carrito",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                    timeInSecForIos: 2);
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(builder: (context)=>StoreScreen(widget.userId,widget.mainContext)));

                              }
                              },
                            child: Center(
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal*24,
                                //color: Colors.blue,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: SizeConfig.safeBlockVertical*2.5,
                                    ),
                                    Text("añadir",
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockVertical*2.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "RobotoRegular",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imageHandle(){
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.safeBlockVertical*4
      ),
      //color: Colors.orange,
      width: SizeConfig.blockSizeHorizontal*100 ,
      height: SizeConfig.blockSizeVertical*25,
      child: Center(
        child: Container(
         // color: Colors.red,
          width: SizeConfig.blockSizeHorizontal*52,
          height: SizeConfig.blockSizeVertical*25,
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.blue,
                width: SizeConfig.blockSizeHorizontal*100 ,
                height: SizeConfig.blockSizeVertical*15,
                child: Center(
                  child: Container(
                    //color: Colors.amber,
                    width: SizeConfig.blockSizeHorizontal*45,
                    height: SizeConfig.blockSizeVertical*15,
                    child: Row(
                      children: <Widget>[
                        (this.image==null)? Container(
                          width: SizeConfig.blockSizeVertical*15,
                          height: SizeConfig.blockSizeVertical*15,
                          //color: Colors.brown,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFe74b64) )
                          ),
                          child: Center(
                            child: Text("Foto de tu mascota",textAlign: TextAlign.center,),
                          ),
                        ):
                        Container(
                          width: SizeConfig.blockSizeVertical*15,
                          height: SizeConfig.blockSizeVertical*15,
                          decoration: BoxDecoration(
                            //color: Colors.brown,
                              border: Border.all(color: Color(0xFFe74b64) ),
                              image: DecorationImage(
                                  image: FileImage(
                                    File(this.image),
                                  ),
                                  //fit: BoxFit.cover
                              )
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeVertical*5,
                          height: SizeConfig.blockSizeVertical*15,
                          // color: Colors.amber,
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFFe74b64),
                                  ),
                                  onPressed:(){
                                    print("CAMARA");
                                    this.getImageCamera();
                                  }
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    color: Color(0xFFe74b64),

                                  ),
                                  onPressed:(){
                                    print("GALERIA");
                                    this.getImageGallery();
                                  }
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
              Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.safeBlockVertical * 7,
                  //  color: Colors.greenAccent,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: SizeConfig.safeBlockHorizontal*50,
                      height: SizeConfig.safeBlockVertical * 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        //color: Colors.deepPurple,
                      ),
                      child: TextFormField(
                        controller: this._controllerPetName,
                        maxLines: 1,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo inválido";
                          }
                          return null;
                        },
                        onSaved: (input) {
                          setState(() {
                            name=input;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          hintText: "Nombre de tu mascota",


                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  bool valida() {
    final formState= formKey.currentState;
    if(formState.validate()){
      formState.save();
      return true;
    }else{
      return false;
    }

  }
}


/*
*         onPressed: (){

                                        print("EL CATEGORY: ${widget.category}");

                                        print("AGREGAR AL CARRITO");
                                        print("PRECIO A PAGAR: ${this.currentPrice}");

                                        widget.userProducts.putIfAbsent(widget.productName, () =>
                                            Product(productName: widget.productName,price: this.currentPrice,
                                                units: this.currentProductUnits,image: widget.image,
                                                description: widget.productDescription,
                                                currentUnitsInStock: widget.currentUnits,
                                                provider: widget.provider,
                                                id: widget.productId,
                                                productCost: widget.productCost,
                                                category: widget.category
                                            ));

                                        Fluttertoast.showToast(
                                            msg: "Se agregó al carrito",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            timeInSecForIos: 2);
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(builder: (context)=>StoreScreen(widget.userId,widget.mainContext)));
                                      },
*
*
*
* */