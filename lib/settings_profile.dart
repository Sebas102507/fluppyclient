import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  UserBloc userBloc;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    userBloc = BlocProvider.of(context);
    print("Contexto: ${context.toString()}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF211551),
        title: Text("Ajustes",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
          fontSize: SizeConfig.safeBlockVertical*3,
            fontFamily: "RobotoRegular"
        ),
        ),
      ),
      body: Container(
        child: Container(
          height: SizeConfig.safeBlockVertical*20,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  //bottom: SizeConfig.safeBlockVertical*4
                ),
                width: double.infinity,
                height: SizeConfig.safeBlockVertical*8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[350]
                  )
                ),
          child: ButtonTheme(
            minWidth: double.infinity,
            height: SizeConfig.safeBlockVertical*4,
            child: RaisedButton(
                onPressed: (){},
                color: Colors.white,
              child: Container(
                //color: Colors.yellow,
                margin: EdgeInsets.only(
                  right: SizeConfig.safeBlockHorizontal*25
                ),
                child: Text("Términos y condiciones",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.safeBlockVertical*3,
                  ),
                ),
              )
            ),
          )
              ),
              Container(
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
              ),
            ],
          )
        )
      )
    );
  }
  /*Future<void> erraseRequestDocument(){
    return Firestore.instance.collection('linkedService').document("DtKqHkx8GXbNSMc1YVrsnVuNOUH2").delete();
  }*/

}
      /*
      * children: <Widget>[
            Container(
             color: Colors.white,
              ),
              Center(
              child: Container(
               color: Colors.grey,
                 width: 50,
                 height: 50,
                   child: Row(
             children: <Widget>[

              IconButton(
               icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
                   ),
       onPressed: (){
          Navigator.pop(context);
            }
        ),
  Container(
    margin: EdgeInsets.only(
     top: SizeConfig.blockSizeVertical*15,
     left: SizeConfig.safeBlockHorizontal*70
    ),
   decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(50)),
  //color: Colors.red
  ),
      width: SizeConfig.blockSizeVertical*5,
       height: SizeConfig.blockSizeVertical*5,
     child: Center(
       child:  IconButton(
         icon: Icon(
            Icons.exit_to_app,
             color: Colors.white,
       ),
               onPressed: (){
                   userBloc.signOut();
               },

              ),

             )

            ),

           ],

          )

         ),

        )

       ],

      )

    );

  }

}
      *
 */
      
      
      /*
      * 
      * Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                  icon: Icon(
                      Icons.arrow_back
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ),
          ],
        ),
      ),
      * 
      * 
      * */


      /*
      *
      * child: ButtonTheme(
              minWidth: double.infinity,
              height: SizeConfig.safeBlockVertical*4,
              child: RaisedButton(
                  onPressed: (){},
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.red,
                  child: Center(
                    child: Text("Cerrar sesión",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  )
              ),
            )
      *
      * */