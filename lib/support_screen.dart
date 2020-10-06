
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/generic_button.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/support.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class SupportScreen extends StatefulWidget {
  String clientId;
  SupportScreen(this.clientId);
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String _description;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  double _stars = 3;
  final formKey = GlobalKey<FormState>();


  Widget _handle() {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(widget.clientId).snapshots(),
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
            return support(snapshot.data["email"], snapshot.data["id"],snapshot.data["phoneNumber"]);

          }
        }
    );
  }

  Widget support(String email, String id, String phone){
    return Scaffold(
      body: Container(
        //color:  Color(0xFF211551),
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical * 4
                      ),
                      // color: Colors.orange,
                      width: double.infinity,
                      height: SizeConfig.safeBlockVertical * 10,
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
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(

                                    Icons.arrow_back,
                                    color: Color(0xFF211551),//Colors.white,
                                    size: SizeConfig.blockSizeVertical * 4,
                                  ),
                                )
                            )
                        ),
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical*2
                    ),
                    width: SizeConfig.safeBlockHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 44,
                    //color: Colors.green,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal * 50,
                            height: SizeConfig.blockSizeVertical * 28,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/help.png")
                                )
                            ),
                          ),
                          Container(
                            //color: Colors.purple,
                            width: SizeConfig.safeBlockHorizontal * 70,
                            height: SizeConfig.blockSizeVertical * 5,
                            child: Text("¿Necesitas ayuda?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  color:  Color(0xFF211551),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            //color: Colors.blue,
                            width: SizeConfig.safeBlockHorizontal * 70,
                            height: SizeConfig.blockSizeVertical * 10,
                            child: Text("Algo no funciona, algún problema con un paseo, tienes alguna duda...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color:  Colors.grey[400],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      //top: SizeConfig.safeBlockVertical*5,
                      left: SizeConfig.safeBlockHorizontal * 2,
                      right: SizeConfig.safeBlockHorizontal * 2,
                    ),
                    height: SizeConfig.safeBlockVertical * 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.deepPurple,
                    ),
                    child: TextFormField(
                      controller: _controllerSuggestion,
                      maxLines: 12,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo inválido";
                        }
                        return null;
                      },
                      onSaved: (input) {
                        _description = input;
                        print(_description);
                      },
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: "Escríbenos",
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.safeBlockVertical * 2,
                    ),
                    child: GenericButton(
                      text: "Enviar",
                      radius: 10,
                      textSize: SizeConfig.blockSizeVertical * 2.5,
                      width: SizeConfig.safeBlockHorizontal * 55,
                      height: SizeConfig.safeBlockHorizontal* 15,
                      color: Color(0xFF211551),
                      textColor: Colors.white,
                      onPressed: () {
                        alertDialog(context);
                        print(_controllerSuggestion.text);
                        userBloc.submitSupportRequest(new Support(email: email,id: id,description:_controllerSuggestion.text,type: "client",phoneNumber: phone));
                        _controllerSuggestion.clear();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void alertDialog(BuildContext context){
    print("Contexto: ${context.toString()}");
    var alert= AlertDialog(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      content: Container(
        //color: Colors.red,
        height: SizeConfig.safeBlockVertical*20,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*9,
                  child: Center(
                    child: Text("Se envío tu mensaje, pronto te responderemos por correo",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.safeBlockVertical*2.3,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  //color: Colors.yellow,
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical*11,
                  child: Center(
                    child: Container(
                      height:  SizeConfig.safeBlockVertical*12,
                      child: Icon(
                        CustomIcons.checkmark_cicle,
                        color: Colors.green,
                        size: SizeConfig.blockSizeVertical*3,
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context)=>alert
    );
  }
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    return _handle();
  }
}
