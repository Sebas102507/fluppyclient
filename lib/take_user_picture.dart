import 'dart:math';

import 'package:fluppyclient/check_user_picture.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
class TakePictureScreen extends StatefulWidget {
  String userFirstName;
  String userLastName;
  String userPhoneNumber;
  String userEmail;
  String userPetName;
  String userPetType;
  CameraDescription camera;
  String userPassword;
  TakePictureScreen({Key key,this.camera,this.userFirstName, this.userLastName,this.userEmail,this.userPhoneNumber,this.userPetName,this.userPetType,this.userPassword});
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  File _image;
  @override
  void initState() {
    super.initState();
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    print("FILE DE LA IMAGEN CON CAMERA : $_image");
    return image;
  }
  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: $_image");
    return image;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: () async=>false,
        child:Scaffold(
            body: Container(
                color: Color(0xFF211551),
                child: Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 5,
                  ),
                  width: SizeConfig.safeBlockHorizontal * 100,
                  height: SizeConfig.blockSizeVertical* 100,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 100,
                        height: SizeConfig.blockSizeVertical* 15,
                        //color: Colors.green,
                        child: Text("Ahora tu foto de perfíl",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 100,
                          height: SizeConfig.blockSizeVertical* 80,
                          // color: Colors.amber,
                          child: Center(
                            child: Container(
                              width: SizeConfig.safeBlockHorizontal * 100,
                              height: SizeConfig.blockSizeVertical* 30,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: SizeConfig.blockSizeHorizontal*1
                                    ),
                                    width: SizeConfig.safeBlockHorizontal * 44,
                                    height: SizeConfig.blockSizeVertical* 20,
                                    child: ButtonTheme(
                                      minWidth: SizeConfig.safeBlockHorizontal* 10,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      child: RaisedButton(
                                          onPressed: (){
                                            getImageGallery().then((value){
                                              if(value==null){
                                                print("EL PATH ES NULL");
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckPicture(userFirstName: widget.userFirstName,
                                                    userLastName: widget.userLastName,userEmail: widget.userEmail,userPassword: widget.userPassword
                                                    ,userPhoneNumber: widget.userPhoneNumber,userPetName: widget.userPetName,userPetType: widget.userPetType,imagePath: _image.path,imageFile: _image)));
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.white)),
                                          color: Colors.white54,
                                          child: Center(
                                              child: Container(
                                                  child: Icon(
                                                    CustomIcons.picture,
                                                    color: Colors.white,
                                                    size: SizeConfig.blockSizeVertical*4,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: SizeConfig.blockSizeHorizontal*10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.blockSizeHorizontal*1
                                    ),
                                    width: SizeConfig.safeBlockHorizontal * 44,
                                    height: SizeConfig.blockSizeVertical* 20,
                                    child: ButtonTheme(
                                      minWidth: SizeConfig.safeBlockHorizontal* 10,
                                      height: SizeConfig.safeBlockHorizontal* 15,
                                      child: RaisedButton(
                                          onPressed: (){
                                            getImageCamera().then((value){
                                             if(value==null){
                                               print("EL PATH ES NULL");
                                             }else{
                                               Navigator.push(context, MaterialPageRoute(builder: (context) => CheckPicture(userFirstName: widget.userFirstName,
                                                   userLastName: widget.userLastName,userEmail: widget.userEmail,userPassword: widget.userPassword
                                                   ,userPhoneNumber: widget.userPhoneNumber,userPetName: widget.userPetName,userPetType: widget.userPetType,imagePath: _image.path,imageFile: _image)));

                                             }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.white)),
                                          color: Colors.white54,
                                          child: Center(
                                              child: Container(
                                                  child: Icon(
                                                    CustomIcons.camera,
                                                    color: Colors.white,
                                                    size: SizeConfig.blockSizeVertical*4,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
}
