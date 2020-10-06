import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/map_screen_test.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/trip_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';

class CheckPetNumber extends StatefulWidget {
  String userId;
  CheckPetNumber({Key key, this.userId});
  @override
  _CheckPetNumberState createState() => _CheckPetNumberState();
}

class _CheckPetNumberState extends State<CheckPetNumber> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _handle();
  }
  Widget _handle() {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();

          }else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text("ERROR"),
              ),
            );
          }else if(snapshot.data["serviceAcceptedType"]==-1 || snapshot.data["stillLinked"]==null || snapshot.data["stillLinked"]==" "|| snapshot.data["stillLinked"]==""){
            return choosePetNumber(snapshot.data["couponId"]);
          }
        }
    );
  }
  Widget choosePetNumber(String couponId){
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              //color: Colors.pink,
                margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical*5,
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
                        Navigator.of(context).pop(MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF211551),
                        size: SizeConfig.blockSizeVertical * 4,
                      ),
                    )
                )
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 80,
              //color: Colors.red,
              child:Center(
                child: Container(
                  width: double.infinity,
                  height:  SizeConfig.blockSizeVertical*50,
                  // color: Colors.blueGrey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height:  SizeConfig.blockSizeHorizontal*20,
                        child: Text("¡Comenzar paseo!",style: TextStyle(fontFamily: "RobotoRegular",fontWeight: FontWeight.bold,fontSize: SizeConfig.blockSizeVertical*3,color: Color(0xFF211551)),textAlign: TextAlign.center),
                      ),
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          //color: Colors.amber,
                          child: Center(
                            child: Container(
                              width: SizeConfig.safeBlockHorizontal * 100,
                              height: SizeConfig.blockSizeVertical* 30,
                              //color: Colors.red,
                              child: Row(
                                children: <Widget>[
                                  Spacer(
                                    flex: 10,
                                  ),
                                  optionButtonLayout(1, couponId,"https://static.wixstatic.com/media/07fea2_030b0214c1e147298fb608a5c001eb02~mv2.png","Mi #1"),
                                  Spacer(
                                    flex: 10,
                                  ),
                                  optionButtonLayout(2, couponId,"https://static.wixstatic.com/media/07fea2_fe58d9dd01b241ed95f768340f4fdc81~mv2.png","La pareja"),
                                  Spacer(
                                    flex: 10,
                                  ),
                                  optionButtonLayout(3, couponId,"https://static.wixstatic.com/media/07fea2_242802c7c4f748278fcbfb296733db3b~mv2.png","La familia"),
                                  Spacer(
                                    flex: 10,
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
            )
          ],
        )
      ),
    );
  }

  Widget optionButtonLayout(int petNumber,String couponId,String imageUrl,String title){
   return  Container(
      margin: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*1
      ),
      width: SizeConfig.safeBlockHorizontal * 30,
      height: SizeConfig.blockSizeVertical* 30,
     //color: Color(0xFF53d2be),
     child: RaisedButton(
         onPressed: (){
           Navigator.push(
               context,
               MaterialPageRoute(builder: (context)=>MapScreen2(userId: widget.userId,petNumber: petNumber,userCoupon:couponId)));
         },
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
         color: Colors.white,//Color(0xFF53d2be),
         child: Center(
             child: Container(
                 width: SizeConfig.safeBlockHorizontal * 30,
                 height: SizeConfig.blockSizeVertical* 30,
                 child: Column(
                   children: [
                     Container(
                       width: SizeConfig.safeBlockHorizontal * 30,
                       height: SizeConfig.blockSizeVertical* 15,
                       //color: Colors.red,
                       child: Center(
                         child: Stack(
                           children: [
                             Container(
                               width: SizeConfig.safeBlockHorizontal * 30,
                               height: SizeConfig.blockSizeVertical* 15,
                               child: Center(
                                 child: Container(
                                   width: SizeConfig.safeBlockHorizontal * 20,
                                   height: SizeConfig.safeBlockHorizontal * 20,
                                   decoration: BoxDecoration(
                                       color: Colors.grey[200],
                                       borderRadius: BorderRadius.all(Radius.circular(100))
                                   ),
                                 ),
                               ),
                             ),
                             Container(
                               width: SizeConfig.safeBlockHorizontal * 30,
                               height: SizeConfig.blockSizeVertical* 15,
                               margin: EdgeInsets.only(
                                 bottom: SizeConfig.safeBlockVertical*1
                               ),
                               child: Center(
                                 child: CachedNetworkImage(
                                   imageUrl: imageUrl,
                                   fit: BoxFit.fitHeight,
                                 ),
                               ),
                             ),
                           ],
                         )
                       ),
                     ),
                     Text("$title",
                       style: TextStyle(
                         color: Color(0xFF211551),
                         fontSize: SizeConfig.blockSizeVertical*2,
                         fontWeight: FontWeight.bold
                       ),
                       textAlign: TextAlign.center,
                     ),
                     Text("Quiero un paseo para $petNumber perro(s)",
                       style: TextStyle(
                           color: Color(0xFF211551),
                           fontSize: SizeConfig.blockSizeVertical*1.3,
                       ),
                       textAlign: TextAlign.center,
                     )
                   ],
                 )
             )
         )
     ),
    );
  }

}

