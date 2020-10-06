
import 'size_config.dart';
import 'package:flutter/material.dart';


class SplashLayout extends StatelessWidget{
  double screenWidth;
  double screenHeight;
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    print("AnchoPantalla: $screenWidth");
    print("AltoPantalla: $screenHeight");
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: null,
              color: Color(0xFF211551)//Colors.white,
          ),

            Center(
              child: Container(
                height: SizeConfig.blockSizeHorizontal*32,
                width: SizeConfig.blockSizeHorizontal*32,
                decoration: BoxDecoration(
                  //color: Colors.yellow,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        //image: AssetImage(user.photoURL),
                        image: AssetImage("assets/FluppyLogoApp.png")// traer una foto desde una URL
                    )
                ),
              ),
            )
        ],
      )
    );
  }

}
