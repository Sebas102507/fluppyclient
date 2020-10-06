import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/reset_password_screen.dart';
import 'package:fluppyclient/reto.dart';
import 'package:fluppyclient/retos_screen.dart';
import 'package:fluppyclient/sign_in_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'blocUser.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:video_player/video_player.dart';

class RetoLayoutScreen extends StatefulWidget {
  String userId;
  String retoId;
  String retoName;
  String retoDescription;
  String videoUrl;
  int retoCoins;
  int userCurrentCoins;
  RetoLayoutScreen({Key key,this.retoName, this.retoDescription,this.videoUrl,this.userId,this.retoCoins,this.retoId,this.userCurrentCoins});
  State<StatefulWidget> createState() => _RetoLayoutScreen();
}

class _RetoLayoutScreen extends State<RetoLayoutScreen> {
  UserBloc userBloc;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  File _image;
  File _video;
  bool isLoading=false;
  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.videoUrl,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }



  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  //height: SizeConfig.blockSizeVertical*100,
                  color: Color(0xFF53d2be),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.blockSizeHorizontal*100 ,
                        height: SizeConfig.blockSizeVertical*60,
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
                                                Navigator.pop(context, MaterialPageRoute(builder: (context)=>RetosScreen(widget.userId)));
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
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*2,
                                    //left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  width: SizeConfig.blockSizeHorizontal*100 ,
                                  height: SizeConfig.blockSizeVertical * 50,
                                  //color: Colors.redAccent,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: SizeConfig.blockSizeHorizontal*100 ,
                                        height: SizeConfig.blockSizeVertical * 50,
                                        child: FutureBuilder(
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: _controller.value.aspectRatio,
                                                child: VideoPlayer(_controller),
                                              );
                                            } else {
                                              return Center(child: CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: FloatingActionButton(
                                          backgroundColor: Color(0xFF211551),
                                          onPressed: () {
                                            setState(() {
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                              } else {
                                                _controller.play();
                                              }
                                            });
                                          },
                                          child: Icon(
                                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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

                      Container(
                        width: double.infinity,
                        height: SizeConfig.blockSizeVertical*100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          /* borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight:Radius.circular(20),
                        )*/
                        ),
                        margin: EdgeInsets.only(
                          //left: SizeConfig.safeBlockHorizontal*1,
                          //right: SizeConfig.safeBlockHorizontal*1
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*1

                              ),
                              //color: Colors.red,
                              width: double.infinity,
                              child: Text("Reto:",
                                style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*1
                              ),
                              //color: Colors.red,
                              width: double.infinity,
                              child: Text("¡${widget.retoName}!",
                                style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*2,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*1
                              ),
                              //color: Colors.red,
                              width: double.infinity,
                              child: Text("Descripción:",
                                style: TextStyle(
                                  color: Color(0xFF53d2be),
                                  fontSize: SizeConfig.safeBlockVertical*3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical*1
                                ),
                                //color: Colors.red,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: Text("${widget.retoDescription.replaceAll("\\n", "\n")}",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Color(0xFF53d2be),
                                      fontSize: SizeConfig.safeBlockVertical*2,
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical*1,
                              ),
                              width: SizeConfig.blockSizeHorizontal*100 ,
                              height: SizeConfig.blockSizeVertical * 6,
                              //color: Colors.yellow,
                              child: Row(
                                children: [
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal*40,
                                    height: SizeConfig.blockSizeVertical * 6,
                                    //color: Colors.red,
                                    child: RaisedButton(
                                        onPressed: (){
                                          getImageGallery();
                                        },
                                        color: Color(0xFF211551),
                                        child: Text("Elegir imagen",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "RobotoRegular",
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        )
                                        )
                                    ),
                                  ),
                                  /*Container(
                                    width: SizeConfig.blockSizeHorizontal*40,
                                    height: SizeConfig.blockSizeVertical * 6,
                                    //color: Colors.red,
                                    child: RaisedButton(
                                        onPressed: (){
                                          getVideoGallery();
                                        },
                                        color: Color(0xFF211551),
                                        child: Text("Elegir video",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "RobotoRegular",
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        )
                                        )
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*1,
                                  bottom: SizeConfig.safeBlockVertical*1,
                                ),
                                width: SizeConfig.blockSizeHorizontal*80,
                                height: SizeConfig.blockSizeVertical * 4,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Text((_image==null && _video==null) ? "Selecciona un archivo": "Archivo listo",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: SizeConfig.safeBlockVertical*2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:  Container(
                                width: SizeConfig.blockSizeHorizontal*40,
                                height: SizeConfig.blockSizeVertical * 6,
                                //color: Colors.red,
                                child: RaisedButton(
                                    onPressed: (){
                                      if(_video==null){
                                        if((_image.lengthSync()/1000000)>25){
                                          Fluttertoast.showToast(
                                              msg: "Máximo un archivo de 25MB",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.grey,
                                              timeInSecForIos: 2);
                                        }else{
                                          setState(() {
                                            this.isLoading=true;
                                          });
                                          userBloc.uploadFile("Challenges/${widget.retoName}/${widget.userId}", _image,false).then((StorageUploadTask _storageUploadTask){
                                            _storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                              snapshot.ref.getDownloadURL().then((fileUrl){
                                                Reto nuevoReto= Reto(filePath: fileUrl ,retoName: widget.retoName ,retoCoins: widget.retoCoins,
                                                    retoDescription: widget.retoDescription,
                                                    retoId:widget.retoId ,userId:widget.userId,userCurrentCoins: widget.userCurrentCoins);
                                                userBloc.updateUserRequestChallenge(nuevoReto);
                                                setState(() {
                                                  this.isLoading=false;
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Se subió con éxito el archivo",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    backgroundColor: Colors.grey,
                                                    timeInSecForIos: 2);
                                              });
                                            });
                                          });
                                        }
                                      }/*else if(_image==null){
                                        if((_video.lengthSync()/1000000)>45){
                                          Fluttertoast.showToast(
                                              msg: "Máximo un video de 20s",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.grey,
                                              timeInSecForIos: 2);
                                        }else{
                                          setState(() {
                                            this.isLoading=true;
                                          });

                                          userBloc.uploadFile("Challenges/${widget.retoName}/${widget.userId}", _video,true).then((StorageUploadTask _storageUploadTask){
                                            _storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                              snapshot.ref.getDownloadURL().then((fileUrl){
                                                Reto nuevoReto= Reto(filePath: fileUrl ,retoName: widget.retoName ,retoCoins: widget.retoCoins,
                                                    retoDescription: widget.retoDescription,
                                                    retoId:widget.retoId ,userId:widget.userId );
                                                userBloc.updateUserRequestChallenge(nuevoReto);
                                                setState(() {
                                                  this.isLoading=false;
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "Se subió con éxito el archivo",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    backgroundColor: Colors.grey,
                                                    timeInSecForIos: 2);
                                              });
                                            });
                                          });
                                        }
                                      }*/
                                    },
                                    color: Color(0xFF53d2be),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
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

  Future<File> getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 480, maxWidth: 640);
    setState(() {
      _image = image;
      _video=null;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: $_image");
    return image;
  }

  Future<File> getVideoGallery() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = video;
      _image=null;
    });
    print("FILE DEL VIDEO  CON GALERIA: ${_video.path}");
    return video;
  }

}