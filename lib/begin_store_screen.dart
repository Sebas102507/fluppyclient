import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/LogIn_screen.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/extra_info_gmail.dart';
import 'package:fluppyclient/home_page.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/product.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:fluppyclient/user_shop_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class BeginStoreScreen extends StatefulWidget {

  @override
  _BeginStoreScreen createState() => _BeginStoreScreen();
}

class _BeginStoreScreen extends State<BeginStoreScreen> {
  String _description;
  final _controllerSuggestion = TextEditingController();
  UserBloc userBloc;
  double _stars = 3;
  final formKey = GlobalKey<FormState>();
  //List<SnapshotMetadata> queryResult= new List<SnapshotMetadata>();
  var temporalSearch=[];
  var queryResult=[];
  String productName="";
  Map<String, Product> userProducts;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  double screenWidth;
  double screenHeight;
  Widget returnedWidget;
  int option=-1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProducts= new Map<String, Product>();
  }


  Future<bool> validaBasesDatos(String id) async{
    bool exists=false;
    final snapShot = await Firestore.instance .collection('users') .document(id).get();
    if (snapShot == null || !snapShot.exists) {
      return exists;
    }else{
      setState(() {
        exists=true;
      });
      return exists;
    }
  }
  Widget _handleCurrenSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot contiene nuestros datos, nuestro objeto user traido de firebase
        if (!snapshot.hasData ||
            snapshot.hasError) { // si el snapshot no tiene datos o un error
          return handlePetType();
        }
        else {
          validaBasesDatos(snapshot.data.uid).then((value){
            if(value==true){
              //print("ENTRE EN EL VERDADERO");
              setState(() {
                returnedWidget= HomeScreen();
              });
            }else {
              //print("ENTRE EN EL FALSO");
              if( snapshot.data.email==null || snapshot.data.uid==null || snapshot.data.photoUrl==null || snapshot.data.displayName==null){
                setState(() {
                  returnedWidget= HomeScreen();
                });
              }else{
                setState(() {
                  returnedWidget= ExtraInfoGmail(email: snapshot.data.email,id: snapshot.data.uid,photoUrl: snapshot.data.photoUrl,name: snapshot.data.displayName);
                });
              }
            }
          });
          if(returnedWidget!=null){
            return returnedWidget;
          }else {
            return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF211551)),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }





  searchProduct(value) {
    if (value.length == 0) {
      setState(() {
        temporalSearch=[];
        queryResult=[];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResult.length == 0 && value.length == 1) {
      getInitialDocuments().then((QuerySnapshot snapshot){
        for(int i=0; i< snapshot.documents.length;i++){
          print("EL TAMAÑO DEL SNAPSHOT: ${snapshot.documents.length}");
          // print("LA CLASE ES : ${snapshot.documents[i].metadata}");
          //queryResult.add("dfaes");
          queryResult.add(snapshot.documents[i].data);
        }
      });
    } else {
      temporalSearch= [];
      queryResult.forEach((element) {
        if ((element['productName'].toUpperCase()).contains(capitalizedValue.toUpperCase())) {
          setState(() {
            temporalSearch.add(element);
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    //SizeConfig.blockSizeVertical*18,
    return _handleCurrenSession();
  }

  Widget handleStore(double cardHeight){
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*100 ,
                  height: SizeConfig.blockSizeVertical*30,
                  decoration: BoxDecoration(
                      color: Color(0xFF53d2be),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                  ),
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
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>BeginScreen()));
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,//Colors.white,
                                          size: SizeConfig.blockSizeVertical * 4,
                                        ),
                                      )
                                  )
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            //color: Colors.redAccent,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("¿Qué deseas para tu perro?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical*3,
                                    fontFamily: "RobotoRegular",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            height: SizeConfig.blockSizeVertical*6,
                            //color: Colors.blueGrey,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Busca lo que necesitas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        ),


                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal*75,
                                height: SizeConfig.safeBlockHorizontal*16,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  /* boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(-10.0, 1.0)
                                      )
                                    ],*/
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)
                                  ),
                                  //color: Colors.deepPurple,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*5,
                                    left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  height: SizeConfig.safeBlockVertical * 8,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(80)
                                    ),
                                    //color: Colors.deepPurple,
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
                                    onChanged: (productName){
                                      setState(() {
                                        this.productName=productName;
                                      });
                                      searchProduct(productName);
                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search,color: Color(0xFF53d2be),),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Buscar",
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                (this.productName==null || this.productName=="") ?
                Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.blockSizeVertical*65,
                  child: StreamBuilder(
                    stream: Firestore.instance.collection('productStore').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData){
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,mainAxisSpacing: 15, crossAxisSpacing: 15,childAspectRatio: 0.85),
                          itemCount: snapshot.data.documents.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            //int, existingUnits, double cardHeight,String image, String productName, description
                            return BeginbuildResultCard(snapshot.data.documents[index].data["existingUnits"],cardHeight+SizeConfig.safeBlockVertical*1.5,
                              snapshot.data.documents[index].data["image"],snapshot.data.documents[index].data["productName"],
                              snapshot.data.documents[index].data["description"],snapshot.data.documents[index].data["price"]
                            );
                          },
                        );
                      }
                    },
                  ),
                )
                    :
                Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical*65,
                    child: Stack(
                      children: <Widget>[
                        GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                            padding: EdgeInsets.all(2.0),
                            primary: false,
                            shrinkWrap: true,
                            children: temporalSearch.map((element) {
                              return buildResultCard(element,cardHeight+SizeConfig.safeBlockVertical*1.5);
                            }).toList()),
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }

  Widget handleCatStore(double cardHeight){
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*100 ,
                  height: SizeConfig.blockSizeVertical*30,
                  decoration: BoxDecoration(
                      color: Color(0xFF53d2be),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                  ),
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
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>BeginScreen()));
                                        },
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,//Colors.white,
                                          size: SizeConfig.blockSizeVertical * 4,
                                        ),
                                      )
                                  )
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            //color: Colors.redAccent,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("¿Qué deseas para tu gato?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical*3,
                                    fontFamily: "RobotoRegular",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              //top: SizeConfig.safeBlockVertical*5,
                              left: SizeConfig.safeBlockHorizontal * 2,
                            ),
                            width: SizeConfig.blockSizeHorizontal*100 ,
                            height: SizeConfig.blockSizeVertical*6,
                            //color: Colors.blueGrey,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Busca lo que necesitas",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeVertical*2.5,
                                  fontFamily: "RobotoRegular",
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                        ),


                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: SizeConfig.blockSizeHorizontal*75,
                                height: SizeConfig.safeBlockHorizontal*16,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  /* boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(-10.0, 1.0)
                                      )
                                    ],*/
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)
                                  ),
                                  //color: Colors.deepPurple,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    //top: SizeConfig.safeBlockVertical*5,
                                    left: SizeConfig.safeBlockHorizontal * 2,
                                  ),
                                  height: SizeConfig.safeBlockVertical * 8,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(80)
                                    ),
                                    //color: Colors.deepPurple,
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
                                    onChanged: (productName){
                                      setState(() {
                                        this.productName=productName;
                                      });
                                      searchProduct(productName);
                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search,color: Color(0xFF53d2be),),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Buscar",
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                //color: Colors.blueGrey,
                                width: SizeConfig.blockSizeHorizontal*20,
                                height: SizeConfig.safeBlockHorizontal*16,
                                margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*2,
                                  right: SizeConfig.blockSizeHorizontal*2,
                                ),
                                decoration: BoxDecoration(
                                  /*boxShadow: <BoxShadow>[
                                      BoxShadow (
                                          color:  Colors.white24,
                                          blurRadius: 8.0,
                                          offset: Offset(0.0, 0.2)
                                      )
                                    ],*/
                                ),
                                child: Center(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              width: SizeConfig.blockSizeHorizontal*18,
                                              height: SizeConfig.safeBlockHorizontal*16,
                                              child: RaisedButton(
                                                onPressed: (){
                                                  print("**********MIS PEDIDOS*******************************");
                                                  mostrarProductos();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context)=> UserShopRequests()));
                                                },
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                color: Colors.white,
                                                child: Column(
                                                  children: <Widget>[
                                                    Text("Mis pedidos",
                                                      style: TextStyle(
                                                        color: Color(0xFF53d2be),
                                                        fontSize: SizeConfig.blockSizeVertical*1.2,
                                                        fontFamily: "RobotoRegular",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Icon(
                                                      Icons.check_circle_outline,
                                                      color: Color(0xFF53d2be),
                                                      size: SizeConfig.blockSizeVertical*3,
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                (this.productName==null || this.productName=="") ?
                Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.blockSizeVertical*65,
                  child: StreamBuilder(
                    stream: Firestore.instance.collection('productStoreCat').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                     if(!snapshot.hasData){
                       return Container(
                         child: CircularProgressIndicator(),
                       );
                     }else{
                       return GridView.builder(
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,mainAxisSpacing: 15, crossAxisSpacing: 15,childAspectRatio: 0.85),
                         itemCount: snapshot.data.documents.length,
                         padding: EdgeInsets.all(2.0),
                         itemBuilder: (BuildContext context, int index) {
                           //int, existingUnits, double cardHeight,String image, String productName, description
                           return BeginbuildResultCard(snapshot.data.documents[index].data["existingUnits"],cardHeight+SizeConfig.safeBlockVertical*1.5,
                             snapshot.data.documents[index].data["image"],snapshot.data.documents[index].data["productName"],
                               snapshot.data.documents[index].data["description"],snapshot.data.documents[index].data["price"]
                           );
                         },
                       );
                     }
                    },
                  ),
                )
                    :
                Container(
                    width: SizeConfig.blockSizeHorizontal*100,
                    height: SizeConfig.blockSizeVertical*65,
                    child: Stack(
                      children: <Widget>[
                        GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.85,
                            padding: EdgeInsets.all(2.0),
                            primary: false,
                            shrinkWrap: true,
                            children: temporalSearch.map((element) {
                              return buildResultCard(element,cardHeight+SizeConfig.safeBlockVertical*1.5);
                            }).toList()),
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }



  Future <QuerySnapshot>getInitialDocuments(){
    if(this.option==0){
      return Firestore.instance.collection("productStore").getDocuments();
    }else{
      return Firestore.instance.collection("productStoreCat").getDocuments();
    }
  }

  Widget buildResultCard(data, double cardHeight) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),)),
        elevation: 2.0,
        child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*48,
                  height: SizeConfig.blockSizeVertical*18,
                  //color: Colors.deepOrange,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.blockSizeHorizontal*45,
                          height: SizeConfig.blockSizeVertical*14,
                          child: CachedNetworkImage(
                            imageUrl: data["image"],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                            width: SizeConfig.blockSizeHorizontal*48,
                            height: SizeConfig.blockSizeVertical*4,
                            color: Colors.grey[200],
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*1
                              ),
                              child: Text(data["productName"],
                                style: TextStyle(
                                    color:Color(0xFF211551),
                                    fontSize: SizeConfig.blockSizeVertical*1.3,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),
                    ),
                    width: double.infinity,
                    height: cardHeight,
                    child:  ButtonTheme(
                      minWidth: 50,
                      height: 30,
                      child: RaisedButton(
                          onPressed: (){
                            showConfirmationRegistration(context);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: (data["existingUnits"]==0)? Colors.grey : Color(0xFF53d2be),
                          child: Center(
                              child: Container(
                                  child: Container(
                                      height: SizeConfig.safeBlockHorizontal*10,
                                      //color: Colors.amber,
                                      alignment: Alignment.center,
                                      child:  (data["existingUnits"]==0) ?
                                      Text(
                                        "Agotado",
                                        style: TextStyle(
                                            fontFamily: "RobotoRegular",
                                            fontSize: 15,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      )
                                          :
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${data["price"].toString().replaceAllMapped(reg, mathFunc)} COP",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                            Text(
                                              "(ver)",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 12,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                              )
                          )
                      ),
                    )
                ),
              ],
            )
        )
    );

  }


  Widget BeginbuildResultCard(int existingUnits, double cardHeight,String image, String productName, description, int price) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(color: (existingUnits==0)? Colors.grey : Color(0xFF53d2be),)),
        elevation: 2.0,
        child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*48,
                  height: SizeConfig.blockSizeVertical*18,
                  //color: Colors.deepOrange,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.blockSizeHorizontal*45,
                          height: SizeConfig.blockSizeVertical*14,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                            width: SizeConfig.blockSizeHorizontal*48,
                            height: SizeConfig.blockSizeVertical*4,
                            color: Colors.grey[200],
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal*1
                              ),
                              child: Text(productName,
                                style: TextStyle(
                                    color:Color(0xFF211551),
                                    fontSize: SizeConfig.blockSizeVertical*1.3,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: (existingUnits==0)? Colors.grey : Color(0xFF53d2be),
                    ),
                    width: double.infinity,
                    height: cardHeight,
                    child:  ButtonTheme(
                      minWidth: 50,
                      height: 30,
                      child: RaisedButton(
                          onPressed: (){
                            showConfirmationRegistration(context);

                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: (existingUnits==0)? Colors.grey : Color(0xFF53d2be),
                          child: Center(
                              child: Container(
                                  child: Container(
                                      height: SizeConfig.safeBlockHorizontal*10,
                                      //color: Colors.amber,
                                      alignment: Alignment.center,
                                      child:  (existingUnits==0) ?
                                      Text(
                                        "Agotado",
                                        style: TextStyle(
                                            fontFamily: "RobotoRegular",
                                            fontSize: 15,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      )
                                          :
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "\$${price.toString().replaceAllMapped(reg, mathFunc)} COP",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                            Text(
                                              "(ver)",
                                              style: TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  fontSize: 12,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                              )
                          )
                      ),
                    )
                ),
              ],
            )
        )
    );

  }



  void mostrarProductos(){
    this.userProducts.forEach((String key, Product product){
      print("${product.productName}");
      print("${product.price}");
      print("${product.units}");
      print("${product.image}");
    });
  }


  Widget LargeoptionButton(String title, String image, Color background,VoidCallback onPressed){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*95,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child:  Material(
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
                width: SizeConfig.safeBlockHorizontal*95,
                height: SizeConfig.safeBlockVertical*20,
                child:  Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child:  Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal*95,
                        height: SizeConfig.safeBlockVertical*20,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*10,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      //color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*40,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 22,
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

  Widget ShortoptionButton(String title, String image, Color background,VoidCallback onPressed){
    return  Container(
        width: SizeConfig.safeBlockHorizontal*45,
        height: SizeConfig.safeBlockVertical*18,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child:  Material(
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
                width: SizeConfig.safeBlockHorizontal*95,
                height: SizeConfig.safeBlockVertical*20,
                child:  Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 1,
                      child:  Container(
                        //color: Colors.green,
                        width: SizeConfig.safeBlockHorizontal*95,
                        height: SizeConfig.safeBlockVertical*20,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.safeBlockVertical*12,
                          left: SizeConfig.safeBlockHorizontal*2
                      ),
                      // color: Colors.green,
                      width: SizeConfig.safeBlockHorizontal*30,
                      child: Text(title,
                        style: TextStyle(
                          fontSize: 16,
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
  Widget handlePetType(){
    if(this.option==0){
      if((screenHeight<650)){
        return handleStore(SizeConfig.safeBlockHorizontal*18.5);
      }else if((screenHeight>650 && screenHeight<700)){
        return handleStore(SizeConfig.safeBlockHorizontal*17);
      }else if(screenHeight<812){
        return  handleStore(SizeConfig.safeBlockHorizontal*15.5);
      }else if(screenHeight<850){
        return  handleStore(SizeConfig.safeBlockHorizontal*14);
      }else {
        return  handleStore(SizeConfig.safeBlockHorizontal*5);
      }

    }else if(this.option==1){
      if((screenHeight<650)){
        return handleCatStore(SizeConfig.safeBlockHorizontal*18.5);
      }else if((screenHeight>650 && screenHeight<700)){
        return handleCatStore(SizeConfig.safeBlockHorizontal*17);
      }else if(screenHeight<812){
        return  handleCatStore(SizeConfig.safeBlockHorizontal*15.5);
      }else if(screenHeight<850){
        return  handleCatStore(SizeConfig.safeBlockHorizontal*14);
      }else {
        return  handleCatStore(SizeConfig.safeBlockHorizontal*12);
      }

    }else{
      return Scaffold(
        body:  Container(
          //color: Colors.amber,
          child: Center(
              child: Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  height: SizeConfig.blockSizeVertical*30,
                  margin: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal*2,
                      right: SizeConfig.blockSizeHorizontal*2
                  ),
                  //color: Colors.greenAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.blockSizeHorizontal*100,
                        height: SizeConfig.blockSizeVertical*5,
                        //color: Colors.grey,
                        margin: EdgeInsets.only(
                          bottom: SizeConfig.safeBlockVertical*2,
                        ),
                        child: Text("Elige el tipo de mascota :)",
                          style: TextStyle(
                            color: Color(0xFF53d2be),
                            fontSize: SizeConfig.safeBlockVertical*3,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoRegular",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.blockSizeHorizontal*46,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.red,
                            child: RaisedButton(
                              padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  bottom: 0,
                                  top: 0
                              ),
                              onPressed:(){
                                print("Perro");
                                setState(() {
                                  this.option=0;
                                });
                              },
                              color: Colors.deepOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),/*side: BorderSide(color: Color(0xFF53d2be),width: SizeConfig.blockSizeHorizontal*1)*/),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 1,
                                      child:  Container(
                                        //color: Colors.green,
                                        width: SizeConfig.blockSizeHorizontal*46,
                                        height: SizeConfig.blockSizeVertical*20,
                                        child: CachedNetworkImage(
                                          imageUrl: "https://static.wixstatic.com/media/07fea2_dbdf58b8e919412c837cbcab32ad4c41~mv2.png",
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //color: Colors.greenAccent,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical*12
                                      ),
                                      width: SizeConfig.blockSizeHorizontal*46,
                                      child: Text("Perro",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: SizeConfig.safeBlockVertical*3,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "RobotoRegular",
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            width: SizeConfig.blockSizeHorizontal*4,
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal*46,
                            height: SizeConfig.blockSizeVertical*20,
                            //color: Colors.blue,
                            child: RaisedButton(
                              padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                  bottom: 0,
                                  top: 0
                              ),
                              onPressed:(){
                                print("Gato");
                                setState(() {
                                  this.option=1;
                                });
                              },
                              color: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),/*side: BorderSide(color: Color(0xFF53d2be),width: SizeConfig.blockSizeHorizontal*1)*/),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 1,
                                      child:  Container(
                                        //color: Colors.green,
                                        width: SizeConfig.blockSizeHorizontal*46,
                                        height: SizeConfig.blockSizeVertical*20,
                                        child: CachedNetworkImage(
                                          imageUrl: "https://static.wixstatic.com/media/07fea2_5db9d2d5d0b64f4d8e14eaa44f627a68~mv2.png",
                                          alignment: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //color: Colors.greenAccent,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical*12
                                      ),
                                      width: SizeConfig.blockSizeHorizontal*46,
                                      child: Text("Gato",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: SizeConfig.safeBlockVertical*3,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "RobotoRegular",
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              )
          ),
        ),
      );
    }
  }
  showConfirmationRegistration(BuildContext mainContext) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Registrate ahora mismo y continuar con tu búsqueda :)",
            style: TextStyle(
                color: Color(0xFF211551),
                fontSize: SizeConfig.safeBlockVertical * 1.5,
                fontWeight: FontWeight.bold
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>LogInScreen()));
              },
              child: Text("Continuar con correo",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockVertical * 1.5,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pop(mainContext);
                userBloc.signIn().then((FirebaseUser user){
                  print("El usuario es ${user.displayName}");
                });
              },
              child: Text("Continuar con gmail",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockVertical * 1.5,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


