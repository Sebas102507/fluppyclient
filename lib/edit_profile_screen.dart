import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/settings_profile.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
class EditProfileScreen extends StatefulWidget {

  String currentFirstName;
  String currentLasttName;
  String currentPhoneNumber;
  String currentPetName;
  String currentPetType;
  String userId;
  EditProfileScreen(this.userId,this.currentFirstName,this.currentLasttName,this.currentPetName,
      this.currentPetType,this.currentPhoneNumber);

  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  double screenWidth;
  double screenHeight;
  double bigContainer;
  UserBloc userBloc;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;
  String email;
  double secondContainerHeight;
  String _userFirstName,_userLastName,_userPhone, _userPetName, _userPetType;
  final formKey= new GlobalKey<FormState>();
  String image="";
  File imageFile;
  bool isLoading=false;

  Widget profile(String userFirstName, String userLastName, String userPhoneNumber,
      String email,String photoUrl,String userPetName,String userPetType,int userTrips, double secondContainerHeight){
    return Scaffold(
        body: Stack(
          children: [
            Form(
                key: formKey,
                child: SingleChildScrollView(
                  //physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    //height: SizeConfig.safeBlockVertical*,
                    color: Colors.grey[250],
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                                width: SizeConfig.safeBlockHorizontal * 100,
                                height: SizeConfig.safeBlockVertical*25,
                                color: Color(0xFF211551),
                                child: Stack(
                                  children: [
                                    Container(
                                        width: SizeConfig.safeBlockHorizontal * 100,
                                        height: SizeConfig.safeBlockVertical*25,
                                        //color: Colors.orange,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: CachedNetworkImage(
                                            imageUrl: "https://static.wixstatic.com/media/07fea2_1d8b4361dac54b49b2f8f8a2f0309280~mv2.png",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )
                                    ),
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
                                  ],
                                )
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*14
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
                                  left: SizeConfig.safeBlockHorizontal * 65,
                                  right: SizeConfig.safeBlockHorizontal * 22,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add_a_photo,color: Color(0xFF211551),size: SizeConfig.safeBlockVertical*3,),
                                  onPressed: (){
                                    this.getImageGallery();
                                  },
                                ),
                              ),
                            ),

                            Container(
                              //color: Colors.green,
                              //color: Color(0xFF211551),
                              margin: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical*12
                              ),
                              height: SizeConfig.safeBlockVertical*18,
                              child: Center(
                                child: Container(
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
                                              color: Colors.white,
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
                                              image: (this.image==""|| this.image==null || this.image==" ")?
                                              CachedNetworkImageProvider(photoUrl):
                                              FileImage(File(image)),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            height: SizeConfig.safeBlockVertical*70,
                            width: SizeConfig.safeBlockHorizontal*90,
                            //color: Colors.orange,
                            child: Center(
                              child: Container(
                                  height: SizeConfig.safeBlockVertical*62,
                                  width: SizeConfig.safeBlockHorizontal*90,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow (
                                            color:  Colors.black38,
                                            blurRadius: 8.0,
                                            offset: Offset(0.0, 0.2)
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Container(
                                    width: SizeConfig.safeBlockHorizontal*90,
                                    height: SizeConfig.safeBlockVertical*60,
                                    //color: Colors.red,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal*90,
                                          height: SizeConfig.safeBlockVertical*50,
                                          // color: Colors.deepOrange,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*1
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Text("Sobre mí",
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig.safeBlockVertical*2,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "RobotoRegular",
                                                                  color: Color(0xFF211551)
                                                              ),
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            Icon(Icons.person, color: Color(0xFF211551) , size: SizeConfig.safeBlockVertical*3,)
                                                          ],
                                                        )
                                                    )
                                                ),

                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*3
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig.safeBlockHorizontal*24,
                                                              // color: Colors.green,
                                                              child: Text("Nombre(s):",
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig.safeBlockVertical*2,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "RobotoRegular",
                                                                    color: Colors.grey
                                                                ),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: SizeConfig.safeBlockHorizontal* 15,
                                                                width: SizeConfig.safeBlockHorizontal*60,
                                                                //color: Colors.red,
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                      primaryColor:  Color(0xFF211551),
                                                                      hintColor:   Color(0xFF211551),
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                        //color: Colors.green,
                                                                          height: SizeConfig.blockSizeHorizontal*15,
                                                                          child: TextFormField(
                                                                            initialValue: userFirstName,
                                                                            validator: (value){
                                                                              if(value.isEmpty){
                                                                                return "Nombres inválidos";
                                                                              }
                                                                            },
                                                                            onSaved: (input)=>_userFirstName=input,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF211551),
                                                                            ),
                                                                            decoration: InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.white12,
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                )
                                                            )
                                                          ],
                                                        )
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*1
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig.safeBlockHorizontal*24,
                                                              //color: Colors.green,
                                                              child: Text("Apellido(s):",
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig.safeBlockVertical*2,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "RobotoRegular",
                                                                    color: Colors.grey
                                                                ),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: SizeConfig.safeBlockHorizontal* 15,
                                                                width: SizeConfig.safeBlockHorizontal*60,
                                                                //color: Colors.red,
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                      primaryColor:  Color(0xFF211551),
                                                                      hintColor:   Color(0xFF211551),
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                        //color: Colors.green,
                                                                          height: SizeConfig.blockSizeHorizontal*15,
                                                                          child: TextFormField(
                                                                            initialValue: userLastName,
                                                                            validator: (value){
                                                                              if(value.isEmpty){
                                                                                return "Apellidos inválidos";
                                                                              }
                                                                            },
                                                                            onSaved: (input)=>_userLastName=input,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF211551),
                                                                            ),
                                                                            decoration: InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.white12,
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                )
                                                            ),

                                                          ],
                                                        )
                                                    )
                                                ),

                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*3
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig.safeBlockHorizontal*24,
                                                              //color: Colors.green,
                                                              child: Text("Tel:",
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig.safeBlockVertical*2,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "RobotoRegular",
                                                                    color: Colors.grey
                                                                ),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: SizeConfig.safeBlockHorizontal* 15,
                                                                width: SizeConfig.safeBlockHorizontal*60,
                                                                //color: Colors.red,
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                      primaryColor:  Color(0xFF211551),
                                                                      hintColor:   Color(0xFF211551),
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                        //color: Colors.green,
                                                                          height: SizeConfig.blockSizeHorizontal*15,
                                                                          child: TextFormField(
                                                                            initialValue: userPhoneNumber,
                                                                            keyboardType: TextInputType.number,
                                                                            validator: (value){
                                                                              if(value.isEmpty){
                                                                                return "Teléfono inválido";
                                                                              }
                                                                            },
                                                                            onSaved: (input)=>_userPhone=input,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF211551),
                                                                            ),
                                                                            decoration: InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.white12,
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                )
                                                            )
                                                          ],
                                                        )
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*1
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Text("Mi peludo",
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig.safeBlockVertical*2,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "RobotoRegular",
                                                                  color: Color(0xFF211551)
                                                              ),
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            Icon(Icons.pets, color: Color(0xFF211551) , size: SizeConfig.safeBlockVertical*3,)
                                                          ],
                                                        )
                                                    )
                                                ),

                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*3
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig.safeBlockHorizontal*24,
                                                              //color: Colors.green,
                                                              child: Text("Nombre(s):",
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig.safeBlockVertical*2,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "RobotoRegular",
                                                                    color: Colors.grey
                                                                ),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: SizeConfig.safeBlockHorizontal* 15,
                                                                width: SizeConfig.safeBlockHorizontal*60,
                                                                //color: Colors.red,
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                      primaryColor:  Color(0xFF211551),
                                                                      hintColor:   Color(0xFF211551),
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                        //color: Colors.green,
                                                                          height: SizeConfig.blockSizeHorizontal*15,
                                                                          child: TextFormField(
                                                                            initialValue: userPetName,
                                                                            validator: (value){
                                                                              if(value.isEmpty){
                                                                                return "Nombre de mascota inválido";
                                                                              }
                                                                            },
                                                                            onSaved: (input)=>_userPetName=input,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF211551),
                                                                            ),
                                                                            decoration: InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.white12,
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                )
                                                            )
                                                          ],
                                                        )
                                                    )
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: SizeConfig.safeBlockVertical*1
                                                    ),
                                                    width: SizeConfig.safeBlockHorizontal*85,
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: SizeConfig.safeBlockHorizontal*24,
                                                              //color: Colors.green,
                                                              child: Text("Raza:",
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig.safeBlockVertical*2,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "RobotoRegular",
                                                                    color: Colors.grey
                                                                ),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: SizeConfig.safeBlockHorizontal* 15,
                                                                width: SizeConfig.safeBlockHorizontal*60,
                                                                //color: Colors.red,
                                                                child: Theme(
                                                                    data: ThemeData(
                                                                      primaryColor:  Color(0xFF211551),
                                                                      hintColor:   Color(0xFF211551),
                                                                    ),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                        //color: Colors.green,
                                                                          height: SizeConfig.blockSizeHorizontal*15,
                                                                          child: TextFormField(
                                                                            initialValue: userPetType,
                                                                            validator: (value){
                                                                              if(value.isEmpty){
                                                                                return "Raza de mascota inválida";
                                                                              }
                                                                            },
                                                                            onSaved: (input)=>_userPetType=input,
                                                                            style: TextStyle(
                                                                              color: Color(0xFF211551),
                                                                            ),
                                                                            decoration: InputDecoration(
                                                                              filled: true,
                                                                              fillColor: Colors.white12,
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                )
                                                            ),

                                                          ],
                                                        )
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: SizeConfig.safeBlockHorizontal * 100,
                                            height: SizeConfig.safeBlockVertical*10,
                                            child: Center(
                                              child: Container(
                                                width: SizeConfig.safeBlockHorizontal * 40,
                                                height: SizeConfig.safeBlockVertical*6,
                                                child: RaisedButton(
                                                  onPressed: (){
                                                    if (formKey.currentState.validate()) {
                                                      setState(() {
                                                        this.isLoading=true;
                                                      });
                                                      formKey.currentState.save();
                                                      print("Nombres: ${this._userFirstName}");
                                                      print("Apellidos: ${this._userLastName}");
                                                      print("Tel: ${this._userPhone}");
                                                      print("Pet Name: ${this._userPetName}");
                                                      print("Pet Type: ${this._userPetType}");

                                                      if(this._userFirstName!=widget.currentFirstName){
                                                        print("SE CAMBIÓ EL PRIMER NOMBRE");
                                                        this.updateField(widget.userId, "firstName", this._userFirstName);
                                                      }
                                                      if(this._userLastName!=widget.currentLasttName){
                                                        print("SE CAMBIÓ EL SEGUNDO NOMBRE");
                                                        this.updateField(widget.userId, "lastName", this._userLastName);
                                                      }
                                                      if(this._userPhone!=widget.currentPhoneNumber){
                                                        print("SE CAMBIÓ EL NÚMERO");
                                                        this.updateField(widget.userId, "phoneNumber", this._userPhone);
                                                      }
                                                      if(this._userPetName!=widget.currentPetName){
                                                        print("SE CAMBIÓ EL NOMBRE DE MASCOTA");
                                                        this.updateField(widget.userId, "petName", this._userPetName);
                                                      }
                                                      if(this._userPetType!=widget.currentPetType){
                                                        print("SE CAMBIÓ LA RAZA DE LA MASCOTA");
                                                        this.updateField(widget.userId, "petType", this._userPetType);
                                                      }
                                                      if(this.image!="" ){
                                                        print("SE CAMBIÓ LA IMAGEN");
                                                        userBloc.uploadFile("$email", this.imageFile,false).then((StorageUploadTask _storageUploadTask){
                                                          _storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                                            snapshot.ref.getDownloadURL().then((urlImage){
                                                              this.updateField(widget.userId, "photoUrl", urlImage);
                                                            });
                                                          });
                                                        });

                                                      }
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                  color: Color(0xFF53d2be),
                                                  child: Container(
                                                      child: Center(
                                                        child: Text("Actualizar",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig.safeBlockVertical*2,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontFamily: "RobotoRegular"
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            )
                                          //color: Colors.greenAccent,
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                )
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


  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.imageFile=image;
      this.image = image.path;
    });
    print("FILE DE LA IMAGEN  CON GALERIA: ${this.image}");
  }


  void updateField(String userId, String field,String fieldValue)async{
    var db= Firestore.instance;
    WriteBatch batch= db.batch();
    batch.updateData(db.collection("users").document(userId), {"$field": fieldValue});
    await batch.commit().then((value){
      print("SE ACTUALIZÓ EL FIELD: $field");
      setState(() {
        this.isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Se actualizó el perfil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
    }
    ).catchError((err){
      print("HUBO UN ERROR AL MOMENTO DE ACTUALIZAR EL FIELD: $field");
      setState(() {
        this.isLoading=false;
      });
      Fluttertoast.showToast(
          msg: "Hubo un error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          timeInSecForIos: 2);
    });
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