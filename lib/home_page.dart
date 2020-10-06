import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/check_pet_number.dart';
import 'package:fluppyclient/custom_icons_icons.dart';
import 'package:fluppyclient/home_screen.dart';
import 'package:fluppyclient/map_screen_test.dart';
import 'package:fluppyclient/paraBorrar.dart';
import 'package:fluppyclient/profile_screen.dart';
import 'package:fluppyclient/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

/*class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserBloc userBloc;
  double screenWidth;
  double screenHeight;
  double bigContainer;
  int currentIndex=0;
  String userId;
  FirebaseUser mCurrentUser;
  FirebaseAuth _auth;

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }
_getCurrentUser () async {
    mCurrentUser = await _auth.currentUser();
    setState(() {
      this.userId=mCurrentUser.uid;
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    SizeConfig().init(context);
    userBloc= BlocProvider.of(mainContext);
    screenWidth=MediaQuery.of(mainContext).size.width;
    screenHeight=MediaQuery.of(mainContext).size.height;
    bigContainer=(screenHeight-(2*(screenHeight/20)));
    userBloc= BlocProvider.of(mainContext);
    return WillPopScope(
      onWillPop: () async=>false,
      child: Scaffold(
        bottomNavigationBar: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Colors.grey[100],
              activeColor:  Colors.grey[50],
              inactiveColor:  Colors.grey[50],
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: currentIndex==0 ? Icon(CustomIcons.home, color:Color(0xFF211551),size: 25,): Icon(CustomIcons.home, color: Colors.grey[400] ,size: 25,),
                    title: Text("")
                ),
                BottomNavigationBarItem(
                    icon: currentIndex==1 ? Icon(CustomIcons.paw, color:Color(0xFF211551),size: 30,): Icon(CustomIcons.paw, color:  Colors.grey[400] ,size: 30,),
                    title: Text("")
                ),
                BottomNavigationBarItem(
                    icon: currentIndex==2 ? Icon(CustomIcons.user, color:Color(0xFF211551) ,size: 25,): Icon(CustomIcons.user, color:  Colors.grey[400] ,size: 25,),
                    title: Text("")
                ),
              ]
          ),

          tabBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                  builder: (BuildContext context) => HomeScreen(),
                );
                break;
              case 1:
                return CupertinoTabView(
                  builder: (BuildContext context){
                    return BlocProvider<UserBloc>(
                      bloc: UserBloc(),
                      child: CheckPetNumber(userId: userId,)//MapScreen2(userId: userId,) ,// a donde quiero que llegue la info
                    );
                  },
                );
                break;
              case 2:
                try{
                  return CupertinoTabView(
                    builder: (BuildContext context){
                      return BlocProvider<UserBloc>(
                        bloc: UserBloc(),
                        child: ProfileScreen(mainContext,userId) ,// a donde quiero que llegue la info
                      );
                    },
                  );
                }catch(e){
                  print("TIPO DE ERROR $e");
                  return CupertinoTabView(
                    builder: (BuildContext context){
                      return Container(
                        color: Colors.green,
                      );
                    },
                  );
            }
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}*/