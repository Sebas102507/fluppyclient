import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluppyclient/fluppy_coins_vet_screen.dart';
import 'package:fluppyclient/fluppy_icons_icons.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/veterinarias_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FluppyVetHome extends StatefulWidget {

  String userId;
  FluppyVetHome(this.userId);

  @override
  _FluppyVetHome createState() => _FluppyVetHome();
}

class _FluppyVetHome extends State<FluppyVetHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        //color: Colors.red,
        child: Column(
          children: [
            Container(
              width: SizeConfig.safeBlockHorizontal*100,
              height: SizeConfig.safeBlockVertical*33,
              //color: Colors.redAccent,
              child: Stack(
                children: [
                  Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.safeBlockVertical * 28,
                    decoration: BoxDecoration(
                        color: Color(0xFF0048cd),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)
                        )
                    ),
                    child: Column(
                      children: [
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
                                          Navigator.pop(context, MaterialPageRoute(builder: (
                                              context) => VeterinariasScreen()));
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
                          width: SizeConfig.blockSizeHorizontal*100,
                          height: SizeConfig.safeBlockVertical * 15,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Container(
                                  width: SizeConfig.blockSizeHorizontal*20,
                                  height: SizeConfig.safeBlockVertical * 5,
                                  //color: Colors.yellow,
                                  child: CachedNetworkImage(
                                    imageUrl: "https://static.wixstatic.com/media/07fea2_a9773a483c5744de9a683361e954e9c3~mv2.png",
                                    fit: BoxFit.fitHeight,
                                  )
                              ),
                              Container(
                                  width: SizeConfig.blockSizeHorizontal*75,
                                  height: SizeConfig.safeBlockVertical * 8,
                                  //color: Colors.brown,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text("FluppyVet",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: SizeConfig.safeBlockVertical*3.5),),
                                        Text("¿En qué te puedo ayudar?",style: TextStyle(color: Colors.white,fontSize: SizeConfig.safeBlockVertical*2),textAlign: TextAlign.start,)
                                      ],
                                    ),
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
                      top: SizeConfig.safeBlockVertical*23
                    ),
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.safeBlockVertical * 8,
                    //color: Colors.orange,
                    child: Center(
                      child: Container(
                        width: SizeConfig.safeBlockVertical * 7,
                        height: SizeConfig.safeBlockVertical * 7,
                        decoration: BoxDecoration(
                            /*boxShadow: <BoxShadow>[
                              BoxShadow (
                                  color: Colors.deepOrange,//Color(0xFF211551),
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 0.2)
                              )
                            ],*/
                            color: Colors.deepOrange,
                            border: Border.all(color: Colors.white,),
                          borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                          ),
                          onPressed: (){
                            print("Fluppy coins");
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FluppyCoinsVetScreen(widget.userId)));
                          },
                          padding: EdgeInsets.all(0),
                          child: Center(
                            child: Icon(
                              FluppyIcons.coin,
                              color: Colors.white,
                              size: SizeConfig.safeBlockVertical*4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.safeBlockVertical * 65,
              //color: Colors.green,
              child: ListView(
                padding: EdgeInsets.only(
                  top: 0
                ),
                children: [
                  optionButton("Tu Vet más cercana", "https://static.wixstatic.com/media/07fea2_778acf6eb095484d89bde18574c9fabd~mv2.png", Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => VeterinariasScreen()));
                  }),
                  optionButton("Consulta a domicilio", "https://static.wixstatic.com/media/07fea2_98879e8b60c24646aaa1d0d71cfb98da~mv2.png", Colors.grey, () {
                    Fluttertoast.showToast(
                        msg: "Próximamente :)",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                        timeInSecForIos: 2);
                  }),
                  optionButton("Consulta online", "https://static.wixstatic.com/media/07fea2_f57edc035fa5417aa46015391441cac1~mv2.png", Colors.grey, () {
                    Fluttertoast.showToast(
                        msg: "Próximamente :)",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                        timeInSecForIos: 2);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget optionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.safeBlockVertical*1
      ),
        width: SizeConfig.safeBlockHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 17,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Material(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: background,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  height: SizeConfig.safeBlockVertical * 15,
                  child: Column(
                    children: <Widget>[
                      Opacity(
                        opacity: 1,
                        child: Container(
                          //color: Colors.green,
                          width: SizeConfig.safeBlockHorizontal * 100,
                          height: SizeConfig.safeBlockVertical * 8,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.green,
                          width: SizeConfig.safeBlockHorizontal * 85,
                          height: SizeConfig.safeBlockVertical * 5,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(title,
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical*2.3,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "RobotoRegular",
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                      )
                    ],
                  )
              ),
            )
          ),
        )
    );
  }
}