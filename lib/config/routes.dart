import 'package:flutter/cupertino.dart';
import '../home/view/screens/home_screen.dart';
import '../splash/splash_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  Routes.splash: (ctx) => SplashScreen(),
  Routes.home: (ctx) => HomeScreen(),

};

// ignore: avoid_classes_with_only_static_members
/// this class contains all routes names
class Routes {
  static String splash = "/";
  static String home = "/home";

}