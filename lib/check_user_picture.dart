import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/take_user_picture.dart';
import 'package:fluppyclient/user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CheckPicture extends StatefulWidget {
  String userFirstName;
  String userLastName;
  String userPhoneNumber;
  String userEmail;
  String userPetName;
  String userPetType;
  String imagePath;
  File imageFile;
  String userPassword;
  CheckPicture({Key key, this.imagePath,this.userFirstName, this.userLastName,this.userEmail, this.userPassword,this.userPhoneNumber,this.userPetName,this.userPetType,this.imageFile});

  @override
  _CheckPictureState createState() => _CheckPictureState();
}

class _CheckPictureState extends State<CheckPicture> {
  UserBloc userBloc;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    print("EL FILE ES DEPUESSS DE TOMAR LA FOTOOOO: ${widget.imageFile}");
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF211551),
            child: Center(
              child: Container(
                width: SizeConfig.safeBlockHorizontal * 100,
                height: SizeConfig.blockSizeVertical* 100,
                //color: Colors.red,
                child: Column(
                  children: <Widget>[
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
                                Navigator.of(context).pop(MaterialPageRoute(builder: (context) => TakePictureScreen()));
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
                      height: SizeConfig.blockSizeVertical*68,
                      //color: Colors.pink,
                      child: Center(
                        child: Container(
                            width: SizeConfig.blockSizeVertical*40,
                            height: SizeConfig.blockSizeVertical*40,
                            //color: Colors.yellow,
                            child:  Container(
                              width: SizeConfig.blockSizeVertical*40,
                              height: SizeConfig.blockSizeVertical*40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 10,
                                    color:  Color(0xFF54d1bf),
                                    style: BorderStyle.solid
                                ),

                              ),
                              child: CircleAvatar(backgroundImage: new FileImage(File(widget.imagePath),),radius: 50,),
                            )
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                      ),
                      width: SizeConfig.safeBlockHorizontal * 100,
                      height: SizeConfig.blockSizeVertical* 12,
                      //color: Colors.blue,
                      child: Center(
                        child: Container(
                            width: SizeConfig.safeBlockHorizontal * 20,
                            height: SizeConfig.safeBlockHorizontal * 20,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                            child: RaisedButton(
                              color:  Color(0xFF53d2be),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  size: SizeConfig.blockSizeVertical*4,
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  isLoading=true;
                                });
                                print("NUMERO DE CELULAR: ${widget.userPhoneNumber}");
                                print("EMAIL: ${widget.userEmail}");
                                print("EMAIL: ${widget.imageFile}");

                               authUser().then((currentUserId){
                                  print("HOLA, SÍ FUNCIONA $currentUserId");
                                  if(currentUserId!=null){
                                    print("NUMERO DE CELULAR: ${widget.userPhoneNumber}");
                                    print("EMAIL: ${widget.userEmail}");
                                    print("EMAIL: ${widget.imageFile}");
                                    print("CURRENT ID: ${currentUserId}");

                                  userBloc.uploadFile("${widget.userEmail}", widget.imageFile,false).then((StorageUploadTask _storageUploadTask){
                                      _storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                        snapshot.ref.getDownloadURL().then((urlImage){
                                          print("URL DESPUÉS DEL SNAPSHOT: $urlImage");
                                          print("NUMERO DE CELULAR: ${widget.userPhoneNumber}");
                                          print("EMAIL: ${widget.userEmail}");
                                         print("EMAIL: ${widget.imageFile}");
                                         User nuevoUsuario= new User(email: widget.userEmail, id:currentUserId, firstName:widget.userFirstName,lastName: widget.userLastName,
                                              phone: widget.userPhoneNumber,photoURl: urlImage,serviceAccepted: false,trips: 0,userPetName: widget.userPetName,userPetType: widget.userPetType);
                                          userBloc.updateUserData(nuevoUsuario);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                          setState(() {
                                            isLoading=false;
                                          });
                                        });
                                      });
                                    });
                                  }
                                });
                              },
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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

 Future<String> authUser() async{
    FirebaseUser user= (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: widget.userEmail, password: widget.userPassword)).user;
return user.uid;
  }

}
