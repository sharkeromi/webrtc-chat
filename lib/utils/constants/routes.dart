import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/auth/login.dart';
import 'package:startup_boilerplate/views/home/home_screen.dart';
import 'package:startup_boilerplate/views/intro/splash_screen.dart';
import 'package:startup_boilerplate/views/messenger/call_screen.dart';
import 'package:startup_boilerplate/views/messenger/inbox.dart';
import 'package:startup_boilerplate/views/messenger/message_screen.dart';
import 'package:startup_boilerplate/views/messenger/ringing_screen.dart';

const String krSplashScreen = '/splash-screen';
const String krHome = '/home';
const String krLogin = '/login';
const String krInbox = '/inbox';
const String krMessages = '/messages';
const String krCallScreen = '/call-screen';
const String krRingingScreen = '/ringing-screen';

List<GetPage<dynamic>>? routes = [
  GetPage(name: krSplashScreen, page: () => const SplashScreen(), transition: Transition.noTransition),
  GetPage(name: krHome, page: () => HomeScreen(), transition: Transition.noTransition),
  GetPage(name: krLogin, page: () => Login(), transition: Transition.noTransition),
  GetPage(name: krInbox, page: () => Inbox(), transition: Transition.noTransition),
  GetPage(name: krMessages, page: () => MessageScreen(), transition: Transition.noTransition),
  GetPage(name: krCallScreen, page: () => CallScreen(), transition: Transition.noTransition),
  GetPage(name: krRingingScreen, page: () => RingingScreen(), transition: Transition.noTransition),
];
