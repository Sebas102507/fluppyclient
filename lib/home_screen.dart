import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/check_pet_number.dart';
import 'package:fluppyclient/consulta_veterinaria_screen.dart';
import 'package:fluppyclient/coupon_screen.dart';
import 'package:fluppyclient/fluppy_at_home_screen.dart';
import 'package:fluppyclient/fluppy_icons_icons.dart';
import 'package:fluppyclient/fluppy_vet_home.dart';
import 'package:fluppyclient/paraBorrar.dart';
import 'package:fluppyclient/profile_screen.dart';
import 'package:fluppyclient/retos_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/store_screen.dart';
import 'package:fluppyclient/support_screen.dart';
import 'package:fluppyclient/tips_screen.dart';
import 'package:fluppyclient/user.dart';
import 'package:fluppyclient/veterinarias_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userId;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;

  _getCurrentUser () async {
    mCurrentUser = await _auth.currentUser();
    setState(() {
      this.userId=mCurrentUser.uid;
    });
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  Widget checkFirstId(double screenHeight){
    _getCurrentUser();
    if(this.userId==null){
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
            ),
          ),
        ),
      );
    }else{
      return  _handleHome(screenHeight);
    }
  }


  Widget _handleHome(double screenHeight) {
    // print("EL ID DEL WALKER ES: ${widget.walkerId} ");
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(this.userId).snapshots(),
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
            try {

              return home(new User(
                  email: snapshot.data["email"],
                  id: this.userId,
                firstName: snapshot.data["firstName"],
                lastName: snapshot.data["lastName"],
                photoURl: snapshot.data["photoUrl"],
                userPoints: snapshot.data["points"],
                phone: snapshot.data["phoneNumber"],
                userPetName: snapshot.data["petName"],
                userPetType: snapshot.data["petType"],

              ),SizeConfig.safeBlockVertical * 84,
              );

            } catch (e) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Color(0xFF211551)),
                  ),
                ),
              );
            }
          }
        }
    );
  }


  Widget home(User user, double height) {
    int points;
    print("EL ID ES: ${this.userId}");
    if (user.userPoints == null) {
       points = 0;
    } else {
        points = user.userPoints;
    }
    return WillPopScope(
      onWillPop: () async=>false,
      child: Scaffold(
          body: Container(
            // color: Colors.red,
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 4
                    ),
                    height: SizeConfig.safeBlockVertical * 100,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: SizeConfig.safeBlockVertical * 12,
                          width: SizeConfig.safeBlockHorizontal * 100,
                          //color: Colors.red,
                          margin: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 3
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: SizeConfig.blockSizeHorizontal * 20,
                                  height: SizeConfig.safeBlockVertical * 8,
                                  // color: Colors.red,
                                  child: Center(
                                    child: Container(
                                      height: SizeConfig.safeBlockVertical * 8,
                                      width: SizeConfig.safeBlockVertical * 8,
                                      decoration: BoxDecoration(
                                        //  color: Colors.greenAccent,
                                        border: Border.all(
                                            color: Color(0xFF211551),
                                            width: SizeConfig
                                                .blockSizeHorizontal * 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)
                                        ),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                user.photoURl),
                                          fit: BoxFit.fitHeight
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                   // color: Colors.lightGreenAccent,
                                  ),
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.safeBlockHorizontal
                                  ),
                                  width: SizeConfig.blockSizeHorizontal * 65,
                                  height: SizeConfig.safeBlockVertical * 20,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        child: Text("¡Hola de nuevo!",
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "RobotoRegular",
                                              color: Color(0xFF211551)
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        width: SizeConfig.blockSizeHorizontal * 70,
                                        height: SizeConfig.safeBlockVertical * 5,
                                        //color: Colors.red,
                                        child: Row(
                                          children: [
                                            Container(
                                              //width: SizeConfig.blockSizeHorizontal * 40,
                                              height: SizeConfig.safeBlockVertical * 5,
                                              child: Align(
                                                child: Text(user.firstName,
                                                  style: TextStyle(
                                                      fontSize:  SizeConfig.safeBlockVertical*3,
                                                      //fontWeight: FontWeight.bold,
                                                      fontFamily: "RobotoRegular",
                                                      color: Color(0xFF211551)
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                alignment: Alignment.topLeft,
                                              )
                                            ),
                                            Container(
                                              width: SizeConfig.blockSizeHorizontal * 30,
                                              height: SizeConfig.safeBlockVertical * 3.5,
                                              margin: EdgeInsets.only(
                                                left: SizeConfig.safeBlockHorizontal*2
                                              ),
                                              child: Align(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FluppyIcons.coin,
                                                      size: SizeConfig.safeBlockVertical*2,
                                                        color: Colors.deepOrange
                                                    ),
                                                    Text(user.userPoints==null ? "0":"${user.userPoints}",
                                                      style: TextStyle(
                                                          fontSize:  SizeConfig.safeBlockVertical*2,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "RobotoRegular",
                                                          color: Colors.deepOrange
                                                      ),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                                alignment: Alignment.topLeft,
                                              )
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              Container(
                                  width: SizeConfig.blockSizeHorizontal * 10,
                                  height: SizeConfig.safeBlockVertical * 8,
                                   //color: Colors.red,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.settings, color: Colors.grey[300],size: SizeConfig.safeBlockVertical*4,),
                                      onPressed: (){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => ProfileScreen(this.userId)));
                                      },
                                    )
                                  )
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child:  Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal,
                              right: SizeConfig.safeBlockHorizontal,
                            ),
                            color: Colors.grey[200],
                            height: height,
                            width: SizeConfig.safeBlockHorizontal * 100,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 8.0,
                                            offset: Offset(0.0, 0.2)
                                        )
                                      ],
                                    ),
                                    height: SizeConfig.safeBlockVertical * 60,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: SizeConfig.safeBlockHorizontal * 5,
                                            ),
                                            child: optionButton("Tienda",
                                                "https://static.wixstatic.com/media/07fea2_4784ce7b10ce4d73a7d2e3c824e2642e~mv2.png",
                                                Color(0xFF53d2be), () {
                                                  print("Tienda");
                                                  if (user.userPoints == null) {
                                                    createPoints(this.userId);
                                                  }
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => StoreScreen(this.userId, context)));
                                                })
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: SizeConfig.safeBlockHorizontal * 4,
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: SizeConfig.safeBlockHorizontal * 90,
                                                child: Row(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                            margin: EdgeInsets.only(
                                                              right: SizeConfig.safeBlockHorizontal * 2,
                                                            ),
                                                            child: middleOptionButton(
                                                                "Fluppy home",
                                                                "https://static.wixstatic.com/media/07fea2_96f2168936d641d7b0375ffc85b584f3~mv2.png",
                                                                Colors.deepOrange, () {
                                                              print("Cupones");
                                                              Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) => FluppyAtHomeScreen()));
                                                            })
                                                        ),
                                                        Container(
                                                            child: middleOptionButton(
                                                                "Fluppy retos",
                                                                "https://static.wixstatic.com/media/07fea2_32e79cfd4b714ffb877270618f8837d0~mv2.png",
                                                                Color(
                                                                    0xFF211551), () {
                                                              print("Tips");

                                                              if (user.userPoints == null) {
                                                                createPoints(this.userId);
                                                              }
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => RetosScreen(this.userId)));
                                                            })
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: SizeConfig.safeBlockHorizontal * 5,
                                            ),
                                            child: shortOptionButton("FluppyVet",
                                                "https://static.wixstatic.com/media/07fea2_2bf0edd07ac44ff7ae3daf9ed106d307~mv2.png",
                                                Color(0xFF0048cd), () {
                                                  print("Tienda");
                                                  if (user.userPoints == null) {
                                                    createPoints(this.userId);
                                                  }
                                                  /*Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => ConsultaVetScreen(userId: widget.userId)));*/
                                                  /*Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => VeterinariasScreen()));*/
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => FluppyVetHome(user.id)));
                                                })
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.safeBlockVertical * 2,
                                  ),
                                  Container(
                                      height: SizeConfig.safeBlockVertical * 28,
                                      width: SizeConfig.blockSizeHorizontal * 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 8.0,
                                              offset: Offset(0.0, 0.2)
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: SizeConfig
                                                    .safeBlockVertical * 1
                                            ),
                                            width: double.infinity,
                                            child: Text("Servicios adicionales",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "RobotoRegular",
                                                  color: Color(0xFF211551)
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            width: SizeConfig
                                                .blockSizeHorizontal * 100,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: SizeConfig.safeBlockHorizontal * 4,
                                                          right: SizeConfig.blockSizeHorizontal * 5
                                                      ),
                                                      child: scrollOptionButton(
                                                          "Servicio de paseo",
                                                          "https://static.wixstatic.com/media/07fea2_85b80d8fa6e94a7982656f859438709f~mv2.png",
                                                          Colors.deepPurpleAccent, () {
                                                        print("Cupones");
                                                        Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) => CheckPetNumber(userId: userId,)));//MapScreen2(userId: userId,)));
                                                      })
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: SizeConfig.safeBlockHorizontal * 4,
                                                          right: SizeConfig.blockSizeHorizontal * 5
                                                      ),
                                                      child: scrollOptionButton(
                                                          "Cupones",
                                                          "https://static.wixstatic.com/media/07fea2_b08a03fd10354ae594a8bee80ea2d3e9~mv2.png/v1/fill/w_342,h_204,al_c,usm_0.66_1.00_0.01/FluppyCupones.png",
                                                          Colors.lightGreen, () {
                                                        print("Cupones");

                                                        if (user.userPoints == null) {
                                                          createPoints(this.userId);
                                                          Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => CouponScreen( new User(
                                                                email: user.email,
                                                                id: this.userId,
                                                                firstName: user.firstName,
                                                                lastName: user.lastName,
                                                                photoURl: user.photoURl,
                                                                userPoints: 0,
                                                                phone: user.phone,
                                                                userPetName: user.userPetName,
                                                                userPetType: user.userPetType,
                                                              ))));

                                                        }else{
                                                          Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => CouponScreen(user)));
                                                        }
                                                      })
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: SizeConfig
                                                              .safeBlockHorizontal *
                                                              4,
                                                          right: SizeConfig
                                                              .blockSizeHorizontal *
                                                              5
                                                      ),
                                                      child: scrollOptionButton(
                                                          "Fluppy Consejo",
                                                          "https://static.wixstatic.com/media/07fea2_8ac762de17d048d1a7d4f62d0f8c3434~mv2.png/v1/fill/w_178,h_302,al_c,usm_0.66_1.00_0.01/FluppyLightBulb.png",
                                                          Colors.pinkAccent, () {
                                                        print("Fluppy consejo");

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context)=>TipsScreen()));
                                                      })
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                        top: SizeConfig
                                                            .safeBlockHorizontal *
                                                            4,
                                                      ),
                                                      child: scrollOptionButton(
                                                          "Soporte",
                                                          "https://static.wixstatic.com/media/07fea2_837d6f3dd7db4009bfdf28c1149b9ec0~mv2.png",
                                                          Colors.amber, () {
                                                        print("Soporte");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => SupportScreen(this.userId))
                                                        );
                                                      })
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
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
              )
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return checkFirstId(MediaQuery.of(context).size.height);
  }

  Widget optionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 90,
        height: SizeConfig.safeBlockVertical * 20,
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
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal * 90,
                height: SizeConfig.safeBlockVertical * 20,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child: Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        height: SizeConfig.safeBlockVertical * 20,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 14,
                          left: SizeConfig.safeBlockHorizontal * 2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal * 85,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  Widget
  middleOptionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 44,
        height: SizeConfig.safeBlockVertical * 20,
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
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal * 44,
                height: SizeConfig.safeBlockVertical * 20,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child: Container(
                        //color: Colors.red,
                        width: SizeConfig.safeBlockHorizontal * 44,
                        height: SizeConfig.safeBlockVertical * 15,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 14,
                          left: SizeConfig.safeBlockHorizontal * 2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal * 85,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }


  Widget shortOptionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 90,
        height: SizeConfig.safeBlockVertical * 10,
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
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal * 90,
                height: SizeConfig.safeBlockVertical * 10,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child: Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        height: SizeConfig.safeBlockVertical * 10,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 5,
                          left: SizeConfig.safeBlockHorizontal * 2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal * 85,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  Widget scrollOptionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 50,
        height: SizeConfig.safeBlockVertical * 16,
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
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal * 50,
                height: SizeConfig.safeBlockVertical * 11,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child: Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal * 50,
                        height: SizeConfig.safeBlockVertical * 11,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 11,
                          left: SizeConfig.safeBlockHorizontal * 2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal * 85,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  Widget smallHeightOptionButton(String title, String image, Color background,
      VoidCallback onPressed) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 90,
        height: SizeConfig.safeBlockVertical * 10,
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
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                width: SizeConfig.safeBlockHorizontal * 90,
                height: SizeConfig.safeBlockVertical * 15,
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child: Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal * 90,
                        height: SizeConfig.safeBlockVertical * 15,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 14,
                          left: SizeConfig.safeBlockHorizontal * 2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal * 85,
                      height: SizeConfig.safeBlockVertical * 5,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "RobotoRegular",
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  void createPoints(String userId) async {
    Firestore.instance.collection('users').document(userId).updateData({
      "points": 0
    });
  }
}
