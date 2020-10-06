import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';

class SquareServiceItem extends StatefulWidget {
  String title,title2;
  String photoIndicator;
  String description;
  double tamanoDescription, imageOpacity;
  int price;
  String priceString,petNumber;
  Color borderColor, bottomContainerColor;
  int active;
  Color mainColor;
  VoidCallback onPressed;
  String alertMessage;
  SquareServiceItem({Key key, this.title, this.photoIndicator, this.description, this.tamanoDescription, this.price, this.title2, this.active,this.mainColor,this.onPressed,this.imageOpacity,this.petNumber,this.bottomContainerColor,this.alertMessage});
  @override
  _SquareServiceItem createState() => _SquareServiceItem();
}

class _SquareServiceItem extends State<SquareServiceItem>{
  @override
  Widget build(BuildContext context) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    widget.priceString= widget.price.toString();
    widget.priceString=widget.priceString.replaceAllMapped(reg, mathFunc);
    SizeConfig().init(context);
    return Container(
        /*margin: EdgeInsets.only(
          bottom: SizeConfig.blockSizeHorizontal*5,
        ),*/
        width: SizeConfig.blockSizeHorizontal*45,
        height: SizeConfig.blockSizeHorizontal*40,
        decoration: BoxDecoration(
          //color: Colors.cyan,//Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: widget.mainColor,
            width: 5,
          ),
        ),
        child: Container(
          child: InkWell(
            onTap: widget.onPressed,
            child: Column(
              children: <Widget>[
               Container(
                 width: SizeConfig.blockSizeHorizontal*45,
                 height: SizeConfig.blockSizeHorizontal*22.5,
                 //color: Colors.pink,
                 child:  Row(
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(
                         top: SizeConfig.blockSizeHorizontal*2,
                         left: SizeConfig.blockSizeHorizontal*1
                       ),
                       //color: Colors.orange,
                       width: SizeConfig.blockSizeHorizontal*25,
                       height: SizeConfig.blockSizeHorizontal*22,
                       child: Column(
                         children: <Widget>[
                           Container(
                             //color: Colors.brown,
                             width: SizeConfig.blockSizeHorizontal*25,
                             height: SizeConfig.blockSizeHorizontal*8,
                             child: Text(
                               widget.title,
                               textAlign: TextAlign.start,
                               style: TextStyle(
                                   fontSize: SizeConfig.blockSizeVertical*3,
                                   color: widget.mainColor,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: "RobotoRegular"
                               ),
                             ),
                           ),
                           Container(
                            //color: Colors.deepOrangeAccent,
                             width: SizeConfig.blockSizeHorizontal*25,
                             height: SizeConfig.blockSizeHorizontal*6.5,
                             child: Row(
                               children: <Widget>[
                                 Text(
                                   widget.title2,
                                   textAlign: TextAlign.start,
                                   style: TextStyle(
                                       fontSize: SizeConfig.blockSizeVertical*3,
                                       color: widget.mainColor,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: "RobotoRegular"
                                   ),
                                 ),
                                 Container(
                                   width: SizeConfig.safeBlockHorizontal * 6,
                                   height: SizeConfig.blockSizeVertical* 6.5,
                                   //color: Colors.greenAccent,
                                   child: Center(
                                     child: Container(
                                         width: SizeConfig.safeBlockHorizontal * 12,
                                         height: SizeConfig.safeBlockHorizontal * 20,
                                         child: IconButton(
                                           alignment: Alignment.topLeft,
                                         icon: Icon(
                                           Icons.info,
                                           size: SizeConfig.blockSizeVertical*3.5,
                                           color: widget.mainColor,
                                         ),
                                             onPressed: (){
                                             alertDialog(context, widget.alertMessage);
                                             }
                                         )
                                     ),
                                   ),
                                 )
                               ],
                             )
                           ),
                           Container(
                             width: SizeConfig.blockSizeHorizontal*25,
                             height: SizeConfig.blockSizeHorizontal*3.5,
                             //color: Colors.blueAccent,
                             child: Row(
                               children: <Widget>[
                                 Container(
                                   //color: Colors.white,
                                   width: SizeConfig.blockSizeHorizontal*5,
                                   height: SizeConfig.blockSizeHorizontal*3.5,
                                   child: Icon(
                                     Icons.pets,
                                     color: widget.mainColor,
                                     size: 13,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     Container(
                       //color: Colors.blue,
                       width: SizeConfig.blockSizeHorizontal*18,
                       height: SizeConfig.blockSizeHorizontal*22.5,
                       child: Opacity(
                         opacity: widget.imageOpacity,
                         child: Container(
                           width: SizeConfig.blockSizeHorizontal*30,
                           height: SizeConfig.blockSizeHorizontal*10,
                           decoration: BoxDecoration(
                               //color: Colors.yellow,
                               image: DecorationImage(
                                 image: AssetImage(widget.photoIndicator),
                               )
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
                Container(
                  width: double.infinity,
                  height: SizeConfig.blockSizeHorizontal*9.7,
                  decoration: BoxDecoration(
                   color: widget.bottomContainerColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                    )
                  ),
                  child:  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal*1
                        ),
                        //color: Colors.cyanAccent,
                        width: SizeConfig.blockSizeHorizontal*25,
                        height: SizeConfig.blockSizeHorizontal*10,
                    child: Center(
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal*26,
                          child:Text(
                            "\$${widget.priceString}",
                            style: TextStyle(
                                color: widget.mainColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RobotoRegular"
                            ),
                            textAlign: TextAlign.start,
                          ),
                        )
                    )
                      ),
                      Container(
                        //color: Colors.brown,
                        width: SizeConfig.blockSizeHorizontal*18,
                          height: SizeConfig.blockSizeHorizontal*10,
                          child: Center(
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal*18,
                              child: Text(
                                "x1hora",
                                style: TextStyle(
                                    color: widget.mainColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoLight"
                                ),
                                textAlign: TextAlign.end,
                              ),
                            )
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  void alertDialog(BuildContext context, String message){
    print("Contexto: ${context.toString()}");
    var alert= AlertDialog(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      content: Container(
        //color: Colors.red,
        height: SizeConfig.safeBlockVertical*30,
        child: Container(
          child: Container(
            //color: Colors.blue,
            width: double.infinity,
            height: SizeConfig.safeBlockVertical*9,
            child: SingleChildScrollView(
              child: Text(message,
                style: TextStyle(
                    color:  Color(0xFF211551),
                    fontSize: SizeConfig.safeBlockVertical*2,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            )
          ),
      ),
      )
    );
    showDialog(
        context: context,
        builder: (BuildContext context)=>alert
    );
  }
}
