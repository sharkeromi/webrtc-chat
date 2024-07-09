import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/home/home_screen.dart';
import 'package:startup_boilerplate/views/intro/splash_screen.dart';

const String krSplashScreen = '/splash-screen';
const String krHome = '/home';

List<GetPage<dynamic>>? routes = [
  GetPage(name: krSplashScreen, page: () => const SplashScreen(), transition: Transition.noTransition),
   GetPage(name: krHome, page: () => HomeScreen(), transition: Transition.noTransition),
];