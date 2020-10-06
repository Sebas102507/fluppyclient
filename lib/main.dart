import 'package:fluppyclient/LogIn_screen.dart';
import 'package:fluppyclient/Splash_layout.dart';
import 'package:fluppyclient/begin_screen.dart';
import 'package:fluppyclient/blocUser.dart';
import 'package:fluppyclient/paraBorrar.dart';
import 'package:fluppyclient/settings_profile.dart';
import 'package:fluppyclient/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
          ),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            'SplasScreen': (BuildContext context) => SplashScreen(),
            'BeginScreen': (BuildContext context) => BeginScreen(),
            'LogInScreen': (BuildContext context) => LogInScreen(),
            'SigInScreen': (BuildContext context) => SignInScreen(),
            'ProfileSettings': (BuildContext context) => ProfileSettings(),
            //"mapScreen" : (BuildContext context) => TestWidget(userId: "CpRpDS64M9chnZ6m6hDI6Qvrfdw2")
          },
        ),
        bloc: UserBloc());

  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(
        Duration(seconds: 2),(){
      Navigator.push(
          context, FadeRoute(page: BeginScreen())//ParaBorrar())//BeginScreen())//
      );
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    return SplashLayout();
  }

}
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}