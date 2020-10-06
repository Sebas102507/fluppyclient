import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatefulWidget {
  String title,title2;
  String photoIndicator;
  String description;
  double tamanoDescription, imageOpacity;
  int price;
  String priceString,petNumber;
  Color borderColor;
  int active;
  Color mainColor;
  VoidCallback onPressed;
  ServiceItem({Key key, this.title, this.photoIndicator, this.description, this.tamanoDescription, this.price, this.title2, this.active,this.mainColor,this.onPressed,this.imageOpacity,this.petNumber});
  @override
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem>{
  @override
  Widget build(BuildContext context) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    widget.priceString= widget.price.toString();
    widget.priceString=widget.priceString.replaceAllMapped(reg, mathFunc);
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.blockSizeHorizontal*2,
      ),
        width: SizeConfig.blockSizeHorizontal*90,
        height: SizeConfig.blockSizeHorizontal*21.5,
        decoration: BoxDecoration(
          //color: Colors.green,//Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: widget.mainColor,
            width: 5,
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal*1.5),
          child: InkWell(
            onTap: widget.onPressed,
            child: Row(
              children: <Widget>[
                Container(
                  //color: Colors.redAccent,
                  height: SizeConfig.blockSizeHorizontal*40,
                  width: SizeConfig.blockSizeHorizontal*50,
                  child: Row(
                    children: <Widget>[
                      Opacity(
                          opacity: widget.imageOpacity,
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal*18,
                          height: SizeConfig.blockSizeHorizontal*40,
                          decoration: BoxDecoration(
                            //color: Colors.yellow,
                              image: DecorationImage(
                                image: AssetImage(widget.photoIndicator,),
                              )
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.grey,
                        width: SizeConfig.blockSizeHorizontal*25,
                        height: SizeConfig.blockSizeHorizontal*40,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: SizeConfig.blockSizeHorizontal*25,
                              height: SizeConfig.blockSizeHorizontal*12,
                             // color: Colors.purple,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    //color: Colors.brown,
                                    width: SizeConfig.blockSizeHorizontal*25,
                                    height: SizeConfig.blockSizeHorizontal*6.5,
                                    child: Text(
                                      widget.title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical*2.5,
                                          color: widget.mainColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //color: Colors.deepOrangeAccent,
                                    width: SizeConfig.blockSizeHorizontal*25,
                                    height: SizeConfig.blockSizeHorizontal*5.5,
                                    child: Text(
                                      widget.title2,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical*2.5,
                                          color: widget.mainColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                                      color: Colors.grey,
                                      size: 13,
                                    ),
                                  ),
                                  Container(
                                    //color: Colors.white,
                                      width: SizeConfig.blockSizeHorizontal*5,
                                      height: SizeConfig.blockSizeHorizontal*3.5,
                                      child: Text(
                                        widget.petNumber,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14
                                        ),
                                        textAlign: TextAlign.start,
                                      )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  //color: Colors.blue,
                  width: SizeConfig.blockSizeHorizontal*33,
                  height: SizeConfig.blockSizeHorizontal*40,
                  child: Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.purple,
                        width: SizeConfig.blockSizeHorizontal*33,
                        height: SizeConfig.blockSizeHorizontal*6,
                        child:Text(
                          "\$${widget.priceString}",
                          style: TextStyle(
                              color: widget.mainColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Container(
                        //color: Colors.amber,
                        width: SizeConfig.blockSizeHorizontal*33,
                        height: SizeConfig.blockSizeHorizontal*4,
                        child: Text(
                          "x45 min",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


/*
*
* child:Row(
                children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*20,
                  height: SizeConfig.safeBlockVertical*15,
                  color: Colors.redAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.blockSizeHorizontal*20,
                        height: SizeConfig.safeBlockVertical*10,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical*2.5,
                                color: Color(0xFF211551),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal*20,
                        height: SizeConfig.safeBlockVertical*10,
                        color: Colors.blueAccent,
                        child: Text(
                          description,
                          style: TextStyle(
                              fontSize: tamanoDescription
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                    ],
                  ),
                ),
                   Container(
                  width: SizeConfig.blockSizeHorizontal*20.2,
                  height: SizeConfig.safeBlockVertical*20,
                  color: Colors.yellow,
                   ),
                  ],
                 ),
*
*
* */


/*
*
*  width: SizeConfig.blockSizeHorizontal*80,
      height: SizeConfig.blockSizeHorizontal*60,
      decoration: BoxDecoration(
        color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Color(0xFF211551),
          width: 5,
        ),
      ),
      child : SizedBox(
          width: double.infinity, // match_parent
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              print("fUNCIONA");
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                     color: Color.fromRGBO(25, 90, 58, 0.06),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                      ),
                  ),
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*15,
                  child:Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*1.4,
                        ),
                        width: SizeConfig.blockSizeHorizontal*24,
                        height: SizeConfig.safeBlockVertical*15,
                       color: Colors.pinkAccent,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: SizeConfig.blockSizeHorizontal*20,
                              height: SizeConfig.safeBlockVertical*7.5,
                              color: Colors.green,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF211551),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                     Text(
                                      title2,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF211551),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),

                            ),
                            Container(
                              width: SizeConfig.blockSizeHorizontal*20,
                              height: SizeConfig.safeBlockVertical*6,
                              //color: Colors.purple,
                              child: Text(
                                description,
                                style: TextStyle(
                                    fontSize: tamanoDescription,
                                    color: Colors.grey[400]
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*1.4
                        ),
                        alignment: Alignment(10, 0),
                        width: SizeConfig.blockSizeHorizontal*24,
                        height: SizeConfig.safeBlockVertical*15,
                        decoration: BoxDecoration(
                            //color: Colors.yellow,
                            image: DecorationImage(
                              image: AssetImage(photoIndicator),
                            )
                        ),
                      ),
                    ],
                  ),


                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)
                        )
                    ),
                    padding: EdgeInsets.all(0),
                    width: double.infinity,
                    height: SizeConfig.safeBlockVertical*5,
                    child: Center(
                      child: Text(
                        "\$${priceString}",
                        style: TextStyle(
                            color: Color(0xFF211551),
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
      ),
*
*
*
* */