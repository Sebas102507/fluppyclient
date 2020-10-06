import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/pet_info_gmail.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';



class ExtraInfoGmail extends StatefulWidget {
  String email;
  String id;
  String photoUrl;
  String name;
  ExtraInfoGmail({Key key, this.email, this.id, this.photoUrl, this.name});
  @override
  _ExtraInfoGmailState createState() => _ExtraInfoGmailState();
}

class _ExtraInfoGmailState extends State<ExtraInfoGmail> {
  UserBloc userBloc;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  String _userFirstName,_userLastName,_userPhone;
  String image="";
  File imageFile;
  final formKey= new GlobalKey<FormState>();
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    userBloc = BlocProvider.of(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async=>false,
      child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: Color(0xFF211551),
                child: Form(
                  key: formKey ,
                  child: SingleChildScrollView(
                    child:Stack(
                      children: <Widget>[
                        Container(
                          width: null,
                          height: SizeConfig.blockSizeVertical*95,
                          //color: Colors.red,
                          margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical*10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: SizeConfig.safeBlockHorizontal* 100,
                                //color: Colors.greenAccent,
                                margin: EdgeInsets.only(
                                  bottom: SizeConfig.blockSizeVertical * 4,
                                  //right: SizeConfig.blockSizeVertical*20,
                                  left: SizeConfig.safeBlockHorizontal* 5,
                                ),
                                child: Text("Completa tu perfil",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.blockSizeVertical * 4,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: SizeConfig.safeBlockVertical*20,
                                //color: Colors.red,
                                child: Center(
                                  child:  (widget.photoUrl==null)?
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 60,
                                    height: SizeConfig.safeBlockVertical*25,
                                    //color: Colors.blue,
                                    child: Center(
                                        child: Stack(
                                          children: [
                                            Container(
                                                width: SizeConfig.safeBlockHorizontal*30,
                                                height:SizeConfig.safeBlockHorizontal*30,
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
                                                        image: (widget.photoUrl==null)? (this.image=="" || this.image==null)?AssetImage("assets/FluppyLogoApp.png"):FileImage(File(image)):CachedNetworkImageProvider(widget.photoUrl)
                                                    ),
                                                  ),
                                                )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: SizeConfig.safeBlockVertical*1
                                              ),
                                              width: SizeConfig.safeBlockHorizontal * 100,
                                              height: SizeConfig.safeBlockVertical*7,
                                              //color: Colors.greenAccent,
                                              child: Container(
                                                width:  SizeConfig.safeBlockVertical*5,
                                                height: SizeConfig.safeBlockVertical*5,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(200))
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: SizeConfig.safeBlockHorizontal * 35,
                                                  right: SizeConfig.safeBlockHorizontal * 10,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.add_a_photo,color: Color(0xFF211551),size: SizeConfig.safeBlockVertical*3,),
                                                  onPressed: (){
                                                    this.getImageGallery();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  )




                                      :
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 40,
                                    height: SizeConfig.safeBlockVertical*25,
                                    //color: Colors.blue,
                                    child: Center(
                                      child: Container(
                                          width: SizeConfig.safeBlockHorizontal*30,
                                          height:SizeConfig.safeBlockHorizontal*30,
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
                                                  image: (widget.photoUrl==null)? AssetImage("assets/FluppyLogoApp.png"):CachedNetworkImageProvider(widget.photoUrl)
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /////////////////////////////Campos de texto(colocar correo, nombre, contraseña)//////
                              Container(
                                  height:SizeConfig.safeBlockHorizontal* 80,
                                  margin: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeVertical*3,
                                    left: SizeConfig.safeBlockHorizontal* 3,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow (
                                            color:  Colors.black,
                                            blurRadius: 8.0,
                                            offset: Offset(0.0, 0.2)
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)
                                      )
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left:SizeConfig.safeBlockHorizontal* 3.5,
                                      right: SizeConfig.safeBlockHorizontal*3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      //color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30)
                                        )
                                    ),

                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                            height: SizeConfig.safeBlockHorizontal* 23,
                                            margin: EdgeInsets.only(
                                              top: SizeConfig.blockSizeHorizontal*7,
                                            ),
                                            child: Theme(
                                                data: ThemeData(
                                                  primaryColor:  Color(0xFF211551),
                                                  hintColor:   Color(0xFF211551),
                                                ),
                                                child: Container(
                                                  //color: Colors.green,
                                                    height: SizeConfig.blockSizeHorizontal*15,
                                                    child: TextFormField(
                                                      initialValue: widget.name,
                                                      validator: (value){
                                                        if(value.isEmpty){
                                                          return "Ingresa unos nombres válidos";
                                                        }
                                                      },
                                                      onSaved: (input)=>_userFirstName=input,
                                                      style: TextStyle(
                                                        color: Color(0xFF211551),
                                                      ),
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white12,
                                                          labelText: "Nombres",
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          )
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                        Container(
                                            height: SizeConfig.safeBlockHorizontal* 23,
                                            child: Theme(
                                                data: ThemeData(
                                                  primaryColor:   Color(0xFF211551),
                                                  hintColor:   Color(0xFF211551),
                                                ),
                                                child: Container(
                                                  //color: Colors.green,
                                                    height: SizeConfig.blockSizeHorizontal*15,
                                                    child: TextFormField(
                                                      validator: (value){
                                                        if(value.isEmpty){
                                                          return "Ingresa unos apellidos válidos";
                                                        }
                                                      },
                                                      onSaved: (input)=>_userLastName=input,
                                                      style: TextStyle(
                                                        color: Color(0xFF211551),
                                                      ),
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white12,
                                                          labelText: "Apellidos",
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          )
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                        Container(
                                            height: SizeConfig.safeBlockHorizontal* 23,
                                            child: Theme(
                                                data: ThemeData(
                                                  primaryColor:   Color(0xFF211551),
                                                  hintColor:   Color(0xFF211551),
                                                ),
                                                child: Container(
                                                  //color: Colors.green,
                                                    height: SizeConfig.blockSizeHorizontal*15,
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      validator: (value){
                                                        if(value.isEmpty){
                                                          return "Ingresa un número válido";
                                                        }
                                                      },
                                                      onSaved: (input)=>_userPhone=input,
                                                      style: TextStyle(
                                                        color: Color(0xFF211551),
                                                      ),
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white12,
                                                          labelText: "Celular",
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          ) ,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              borderSide: BorderSide(
                                                                  color:  Color(0xFF211551),
                                                                  width: 2
                                                              )
                                                          )
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                //color: Colors.red,
                                height: SizeConfig.blockSizeVertical*10,
                                margin: EdgeInsets.only(
                                  left: SizeConfig.safeBlockHorizontal * 2.8,
                                  right: SizeConfig.safeBlockHorizontal * 2.8,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: SizeConfig.safeBlockHorizontal*2.8,
                                          right: SizeConfig.safeBlockHorizontal*2.8,
                                          bottom: SizeConfig.blockSizeVertical*1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          //color:  Colors.orange,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow (
                                                color:  Colors.white,
                                                blurRadius: 8.0,
                                                offset: Offset(0.0, 0.2)
                                            )
                                          ],
                                        ),
                                        width: double.infinity,
                                        height:SizeConfig.safeBlockHorizontal*15,
                                        child: GenericButton(
                                          text: "Continuar",
                                          radius: 10,
                                          textSize:  SizeConfig.safeBlockHorizontal* 5,
                                          width: SizeConfig.safeBlockHorizontal*21 ,
                                          height: SizeConfig.safeBlockHorizontal* 15,
                                          color: Colors.white,
                                          textColor: Color(0xFF42E695),
                                          onPressed: (){
                                            if (formKey.currentState.validate()) {
                                              formKey.currentState.save();
                                              setState(() {
                                                this.isLoading=true;
                                              });
                                              if(widget.photoUrl==null){
                                                //print("FOTO NULL");
                                                userBloc.uploadFile("${widget.email}", this.imageFile,false).then((StorageUploadTask _storageUploadTask){
                                                  _storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                                    snapshot.ref.getDownloadURL().then((urlImage){
                                                      print("IMAGENNN: $urlImage");
                                                      setState(() {
                                                        this.isLoading=false;
                                                      });
                                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>PetInfoGmailScreen(
                                                          email: widget.email,id: widget.id,photoUrl: urlImage,
                                                          firstName: _userFirstName,lastName: _userLastName,phoneNumber: _userPhone)));
                                                    });
                                                  });
                                                });
                                              }else{
                                                setState(() {
                                                  this.isLoading=false;
                                                });
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>PetInfoGmailScreen(
                                                    email: widget.email,id: widget.id,photoUrl: widget.photoUrl,
                                                    firstName: _userFirstName,lastName: _userLastName,phoneNumber: _userPhone)));
                                              }
                                            }
                                          },
                                        )
                                    ),
                                  ],
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
      ),
    );
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.imageFile=image;
      this.image = image.path;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: ${this.image}");
  }


}
