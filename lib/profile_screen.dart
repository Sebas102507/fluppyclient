import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/edit_profile_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/settings_profile.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ProfileScreen extends StatefulWidget {


  String userId;
  ProfileScreen(this.userId);

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  String email;
  double secondContainerHeight;
//SizeConfig.blockSizeVertical * 6, ocupa el navigation bar
  //samsung j5 ocupa SizeConfig.blockSizeVertical * 8 el navigation bar


  Widget profile(String userFirstName, String userLastName, String userPhoneNumber,
      String email,String photoUrl,String userPetName,String userPetType,int userTrips, double secondContainerHeight){
    return Scaffold(
        body: Stack(
          children: [
            Container(
                width: SizeConfig.safeBlockHorizontal * 100,
                height: SizeConfig.safeBlockVertical*100,
                color: Color(0xFF211551),
            ),
            Container(
                width: SizeConfig.safeBlockHorizontal * 100,
                height: SizeConfig.safeBlockVertical*100,
                //color: Colors.orange,
                child: Opacity(
                  opacity: 0.1,
                  child: CachedNetworkImage(
                    imageUrl: "https://static.wixstatic.com/media/07fea2_1d8b4361dac54b49b2f8f8a2f0309280~mv2.png",
                    fit: BoxFit.fitHeight
                  ),
                )
            ),
            Container(
              //height: SizeConfig.safeBlockVertical*,
              child: Column(
                children: <Widget>[
                  Container(
                    //color: Colors.red,
                      margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical*5,
                      ),
                      width: double.infinity,
                      height: SizeConfig.blockSizeVertical * 7,
                      child: Container(
                        //color: Colors.deepOrangeAccent,
                          width: SizeConfig.safeBlockHorizontal * 2,
                          height: SizeConfig.blockSizeVertical * 7,
                          margin: EdgeInsets.only(
                              right: SizeConfig.safeBlockHorizontal * 86
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: SizeConfig.blockSizeVertical * 4,
                            ),
                          )
                      )
                  ),
                  Container(
                      width: SizeConfig.safeBlockHorizontal * 100,
                      height: SizeConfig.blockSizeVertical * 70,
                      child: Center(
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 47,
                          //color: Colors.orange,
                          child: Column(
                            children: [
                              Container(
                                //color: Colors.green,
                                //color: Color(0xFF211551),
                                height: SizeConfig.safeBlockVertical*25,
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: SizeConfig.safeBlockVertical*25,
                                    //color: Colors.brown,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal * 40,
                                          height: SizeConfig.safeBlockVertical*25,
                                          //color: Colors.blue,
                                          child: Center(
                                            child: Container(
                                                width: SizeConfig.safeBlockHorizontal*35,
                                                height:SizeConfig.safeBlockHorizontal*35,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: SizeConfig.safeBlockVertical/1.2,
                                                      color: Color(0xFF53d2be),
                                                      style: BorderStyle.solid
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(80)),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(80)),
                                                    child: FadeInImage(
                                                        fit: BoxFit.cover,
                                                        placeholder: AssetImage("assets/loading.gif"),
                                                        image: CachedNetworkImageProvider(photoUrl)
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          //color: Colors.redAccent,
                                          width: SizeConfig.safeBlockHorizontal*60,
                                          height:SizeConfig.safeBlockHorizontal*23,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: SizeConfig.safeBlockHorizontal*8,
                                                ),
                                                //color: Colors.black,
                                                width: SizeConfig.safeBlockHorizontal*52,
                                                height:SizeConfig.safeBlockHorizontal*7,
                                                child: Container(
                                                  child: Text(
                                                    //"Elon Musk",
                                                    userFirstName,
                                                    // email,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig.blockSizeHorizontal*4.5,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "RobotoRegular"
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: SizeConfig.safeBlockHorizontal*8,
                                                ),
                                                //color: Colors.black,
                                                width: SizeConfig.safeBlockHorizontal*52,
                                                height:SizeConfig.safeBlockHorizontal*7,
                                                child: Container(
                                                  child: Text(
                                                    //"Elon Musk",
                                                    userLastName,
                                                    // email,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig.blockSizeHorizontal*4.5,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "RobotoRegular"
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: SizeConfig.safeBlockHorizontal*2,
                                                ),
                                                //color: Colors.white,
                                                width: SizeConfig.safeBlockHorizontal*58,
                                                height:SizeConfig.safeBlockHorizontal*9,
                                                child: Container(
                                                  child: Text(
                                                    email,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.blockSizeHorizontal*3.5,
                                                      fontFamily: "RobotoLight",
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                height: SizeConfig.safeBlockVertical*9,
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        //color: Colors.pinkAccent,
                                        width: SizeConfig.safeBlockHorizontal*91,
                                        height:SizeConfig.safeBlockVertical*8,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              //color: Colors.lightGreenAccent,
                                                width: SizeConfig.safeBlockHorizontal*18,
                                                height:SizeConfig.safeBlockHorizontal*20,
                                                child: Center(
                                                  child: Container(
                                                    //color: Colors.white70,
                                                    width: SizeConfig.safeBlockHorizontal*20,
                                                    height:SizeConfig.safeBlockHorizontal*20,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*28,
                                                          //color: Colors.blueAccent,
                                                          child:  Text(
                                                            "Paseos",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white70,
                                                                fontSize: SizeConfig.blockSizeVertical*2,
                                                                fontFamily: "RobotoLight"
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*20,
                                                          height: SizeConfig.blockSizeVertical*5,
                                                          //color: Colors.purple,
                                                          child:  Text(
                                                            "$userTrips",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: SizeConfig.blockSizeVertical*2.5,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "RobotoRegular"
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),

                                            VerticalDivider(
                                                color: Colors.white,
                                                width: SizeConfig.safeBlockHorizontal*6
                                            ),

                                            Container(
                                              // color: Colors.lightGreenAccent,
                                                width: SizeConfig.safeBlockHorizontal*30,
                                                height:SizeConfig.safeBlockHorizontal*20,
                                                child: Center(
                                                  child: Container(
                                                    //color: Colors.white70,
                                                    width: SizeConfig.safeBlockHorizontal*20,
                                                    height:SizeConfig.safeBlockHorizontal*20,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*28,
                                                          //color: Colors.blueAccent,
                                                          child:  Text(
                                                            "Mascota",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white70,
                                                                fontSize: SizeConfig.blockSizeVertical*2,
                                                                fontFamily: "RobotoLight"
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*20,
                                                          height: SizeConfig.blockSizeVertical*5,
                                                          //color: Colors.purple,
                                                          child:  Text(
                                                            "$userPetName",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: SizeConfig.blockSizeVertical*2,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "RobotoRegular"
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            ),
                                            VerticalDivider(
                                                color: Colors.white,
                                                width: SizeConfig.safeBlockHorizontal*6
                                            ),
                                            Container(
                                              //color: Colors.lightGreenAccent,
                                                width: SizeConfig.safeBlockHorizontal*30,
                                                height:SizeConfig.safeBlockHorizontal*20,
                                                child: Center(
                                                  child: Container(
                                                    //color: Colors.white70,
                                                    width: SizeConfig.safeBlockHorizontal*20,
                                                    height:SizeConfig.safeBlockHorizontal*20,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*28,
                                                          //color: Colors.blueAccent,
                                                          child:  Text(
                                                            "Raza",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white70,
                                                                fontSize: SizeConfig.blockSizeVertical*2,
                                                                fontFamily: "RobotoLight"
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal*20,
                                                          height: SizeConfig.blockSizeVertical*5,
                                                          //color: Colors.purple,
                                                          child:  Text(
                                                            "$userPetType",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: SizeConfig.blockSizeVertical*2,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "RobotoRegular"
                                                            ),
                                                            textAlign: TextAlign.center,
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
                                  ],
                                ),
                              ),


                              Container(
                                width: SizeConfig.safeBlockHorizontal*100,
                                height: SizeConfig.blockSizeVertical*12,
                                //color: Colors.deepOrange,
                                child: Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.safeBlockHorizontal*50,
                                      height: SizeConfig.blockSizeVertical*8,
                                      //color: Colors.green,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.safeBlockHorizontal * 2.8,
                                            right: SizeConfig.safeBlockHorizontal * 2.8,
                                            bottom: SizeConfig.blockSizeVertical * 1,
                                          ),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                          ),
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(
                                              color: Colors.white
                                            )),
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => EditProfileScreen(widget.userId,userFirstName,userLastName,userPetName,userPetType,userPhoneNumber)));
                                            },
                                            color:  Colors.white54,
                                            child: Center(
                                              child: Text("Editar perfíl",
                                                style: TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal* 4,
                                                    fontWeight: FontWeight.bold,
                                                    color:  Colors.white,
                                                    fontFamily: "RobotoRegular"
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),

                                    Container(
                                      width: SizeConfig.safeBlockHorizontal*50,
                                      height: SizeConfig.blockSizeVertical*8,
                                      //color: Colors.green,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.safeBlockHorizontal * 2.8,
                                            right: SizeConfig.safeBlockHorizontal * 2.8,
                                            bottom: SizeConfig.blockSizeVertical * 1,
                                          ),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                          ),
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(
                                                color: Colors.white
                                            )),
                                            onPressed: (){
                                              userBloc.signOut();
                                              Navigator.of(context).pushNamedAndRemoveUntil('BeginScreen', (Route<dynamic> route) => false);
                                            },
                                            color:  Colors.red.withOpacity(1),
                                            child: Center(
                                              child: Text("Cerrar sesión",
                                                style: TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal* 4.5,
                                                    fontWeight: FontWeight.bold,
                                                    color:  Colors.white,
                                                    fontFamily: "RobotoRegular"
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        )
    );

  }

  Widget _handleProfile(double secondContainerHeight) {
    return StreamBuilder(
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
            return profile(snapshot.data["firstName"],snapshot.data["lastName"],snapshot.data["phoneNumber"],
                snapshot.data["email"],snapshot.data["photoUrl"],snapshot.data["petName"],snapshot.data["petType"],snapshot.data["trips"],secondContainerHeight);
          }
        }
    );
  }

Widget _firstHandle(double height){

  if((height<650)){
    return _handleProfile(SizeConfig.safeBlockVertical*55.18);
  }else if((height>650 && height<700)){
    return _handleProfile(SizeConfig.safeBlockVertical*55.68);
  }else if(height<812){
    return  _handleProfile(SizeConfig.safeBlockVertical*57.07);
  }else {
    return  _handleProfile(SizeConfig.safeBlockVertical*56.7);
  }

}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    //userBloc.signOut();
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    //realSafeVerticalArea= SizeConfig.safeBlockVertical*94; max que puedo usar
    return _firstHandle(screenHeight);
  }

}

/*Container(
                                  margin: EdgeInsets.only(
                                  ),
                                  color:  Color(0xFF53d2be),
                                  width: double.infinity,
                                  height: SizeConfig.safeBlockVertical*8,
                                  child: ButtonTheme(
                                    minWidth: double.infinity,
                                    height: SizeConfig.safeBlockVertical*4,
                                    child: RaisedButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => EditProfileScreen(widget.userId)));
                                        },
                                        color:  Color(0xFF53d2be),
                                        child: Center(
                                          child: Text("Editar perfíl",
                                            style: TextStyle(
                                                fontSize: SizeConfig.safeBlockVertical*2.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: "RobotoRegular"
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                              ),*/

/*Container(
                                  margin: EdgeInsets.only(
                                  ),
                                  color: Colors.red,
                                  width: double.infinity,
                                  height: SizeConfig.safeBlockVertical*8,
                                  child: ButtonTheme(
                                    minWidth: double.infinity,
                                    height: SizeConfig.safeBlockVertical*4,
                                    child: RaisedButton(
                                        onPressed: (){
                                          userBloc.signOut();
                                          Navigator.of(context).pushNamedAndRemoveUntil('BeginScreen', (Route<dynamic> route) => false);
                                        },
                                        color: Colors.red,
                                        child: Center(
                                          child: Text("Cerrar sesión",
                                            style: TextStyle(
                                                fontSize: SizeConfig.safeBlockVertical*2.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: "RobotoRegular"
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                              ),*/