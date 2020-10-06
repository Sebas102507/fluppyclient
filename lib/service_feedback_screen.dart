import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/feed_back_info.dart';
import 'package:fluppyclient/map_screen_test.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class FeedBackScreen extends StatefulWidget {
  bool reset;
  User userInfo;
  FeedBackScreen({Key key, this.userInfo, this.reset});
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  double _stars=5;
  String starMessage="¡Muy Bueno!";
  String image="assets/muyBueno";
  UserBloc userBloc;
  String userFirstName;
  String userLastName;
  String photoUrl;
  String walkerId;
  String userId;
  String awful="assets/muyMalo";
  String bad="assets/malo";
  String regular="assets/regular";
  String good="assets/bueno";
  String veryGood="assets/muyBueno";
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  FeedBack feedBack;
  final formKey = GlobalKey<FormState>();

  void updateClientServiceState()async{
    FirebaseUser currentUser= await FirebaseAuth.instance.currentUser();
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    print("ID:  ${currentUser.uid} ");
    batch.updateData(db.collection('users').document(currentUser.uid), {"walkerId": null});
    batch.updateData(db.collection('users').document(currentUser.uid), {"linked": "preLinked"});
    batch.updateData(db.collection('users').document(currentUser.uid), {"serviceAcceptedType": -1});
    batch.updateData(db.collection('users').document(currentUser.uid), {"stillLinked": null});
    await batch.commit().then((value){
      print("update successful");
    }
    ).catchError((err){
      print("Something went wrong try again");
    });
  }
  _getCurrentUserWalkerId () async {
    FirebaseUser currentUser= await FirebaseAuth.instance.currentUser();
    //print('Hello EMAIL USUARIO ACTUAL ' + mCurrentUser.email.toString());
    print('Hello ID USUARIO ACTUAL MIRAAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaaaaaaAAAAAAAA ' + currentUser.uid);
    var userQuery = Firestore.instance.collection('users').where(
        'id', isEqualTo: currentUser.uid).limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        print("ENTRE");
        if(this.mounted){
          setState(() {
            userId=currentUser.uid;
            walkerId=data.documents[0].data['walkerId'];
          });
        }
        //print("CORREO: $email");
        //print("PRIMER NOMBRE: $userFirstName");
        //print("SEGUNDO NOMBRE: $userLastName");
        //print("PHOTO URL: $photoUrl");
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUserWalkerId();
  }
  void sendFeedBack(){
    feedBack= new FeedBack(
        clientFirstName: widget.userInfo.firstName,
        clientLastName: widget.userInfo.lastName,
        clientId: widget.userInfo.id,
        walkerId: walkerId,
        clientPhoto: widget.userInfo.photoURl,
        stars: _stars
    );
    userBloc.updateWalkerFeedBack(feedBack);
    updateClientServiceState();
  }
  @override
  Widget build(BuildContext context) {
    userBloc= BlocProvider.of<UserBloc>(context);
    _getCurrentUserWalkerId();
    SizeConfig().init(context);
    return Container(
      key: formKey,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF211551),
                  Color(0xFF53d2be),
                ],
                begin: FractionalOffset(0.8, 0.0),
                end: FractionalOffset(1.0, 3.5),
                stops: [0.0, 0.6],
                tileMode: TileMode.clamp
            )
        ),
        child: Column(
          children: <Widget>[
           Container(
             margin: EdgeInsets.only(
               top: SizeConfig.safeBlockVertical*10
             ),
             child:  Center(
               child: Container(
                 //color: Colors.red,
                 height: SizeConfig.safeBlockVertical*74,
                 child: Column(
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(
                         bottom: SizeConfig.safeBlockVertical*8,
                       ),
                       //color: Colors.purple,
                       width: SizeConfig.safeBlockHorizontal*75,
                       height: SizeConfig.safeBlockVertical*10,
                       child: Text(
                         "Nos importa tu opinión, califica nuestro servicio",
                         style: TextStyle(
                           fontSize: SizeConfig.safeBlockVertical*3,
                           color: Colors.white,
                         ),
                         textAlign: TextAlign.center,
                       ),
                     ),
                     Container(
                       height: SizeConfig.safeBlockVertical*28,
                       width: double.infinity,
                       //color: Colors.green,
                       child: Container(
                         margin: EdgeInsets.all(SizeConfig.safeBlockVertical*4),
                         decoration: BoxDecoration(
                             image: DecorationImage(
                                 image: AssetImage(image)
                             )
                         ),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(
                         bottom: SizeConfig.safeBlockVertical*3,
                       ),
                       height: SizeConfig.safeBlockVertical*5,
                       //color: Colors.amber,
                       child: Center(
                         child: Text(starMessage,
                           style: TextStyle(
                               fontSize: SizeConfig.safeBlockVertical*2.5,
                               color: Colors.white
                           ),
                         ),
                       ),
                     ),
                     Container(
                         width: SizeConfig.safeBlockHorizontal*70,
                         height: SizeConfig.safeBlockVertical*8,
                         decoration: BoxDecoration(
                             boxShadow: <BoxShadow>[
                               /* BoxShadow (
                            color:  Colors.black,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 0.2)
                        )*/
                             ],
                             borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical*10)),
                             color: Colors.white70
                         ),
                         child: Center(
                           child: FlutterRatingBar(
                             fullRatingWidget: Icon(Icons.star, color: Color(0xFFffb531),size: 50,),
                             noRatingWidget: Icon(Icons.star_border, color: Color(0xFFffb531),size: 50,),
                             initialRating: 5,
                             allowHalfRating: false,
                             onRatingUpdate: (rating) {
                               if(rating==1){
                                 setState(() {
                                   _stars=rating;
                                   image=awful;
                                   starMessage="Muy Malo";
                                 });
                               }else if(rating==2){
                                 setState(() {
                                   _stars=rating;
                                   image=bad;
                                   starMessage="Malo";
                                 });
                               }else if(rating==3){
                                 setState(() {
                                   _stars=rating;
                                   image=regular;
                                   starMessage="Regular";
                                 });
                               }else if(rating==4){
                                 setState(() {
                                   _stars=rating;
                                   image=good;
                                   starMessage="Bueno";
                                 });
                               }else if(rating==5){
                                 setState(() {
                                   _stars=rating;
                                   image=veryGood;
                                   starMessage="¡Muy Bueno!";
                                 });
                               }
                               print(rating);
                             },
                           ),
                         )
                     )
                   ],
                 ),
               ),
             ),
           ),
            Container(
              //color: Colors.grey,
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal*80
                ),
                child: IconButton(
                    icon: Icon(
                      CustomIcons.arrow_right,
                      size: SizeConfig.safeBlockVertical*6,
                      color: Colors.white,
                    ),
                    onPressed:(){
                      sendFeedBack();
                      updateClientServiceState();
                      //Navigator.of(context).pushNamedAndRemoveUntil('mapScreen', (Route<dynamic> route) => false);
                        print("ENTRO EN EL QUE NO HAYYYYYYY ERRORRRRRRRRRRRRRRRR");
                        if(widget.reset){
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, MaterialPageRoute(builder: (context)=> MapScreen2(userId:  widget.userInfo.id),));
                        }else{
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, MaterialPageRoute(builder: (context)=> MapScreen2(userId:  widget.userInfo.id),));
                          Navigator.pop(context, MaterialPageRoute(builder: (context)=> MapScreen2(userId:  widget.userInfo.id),));
                        }
                    } ),
              ),
            )
          ],
        )
      );
  }
}
