import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/intro/splash_controller.dart';

class BinderController implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashScreenController>(SplashScreenController());
    Get.put<GlobalController>(GlobalController());
  }
}
