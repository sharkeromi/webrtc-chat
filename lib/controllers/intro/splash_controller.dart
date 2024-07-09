import 'package:startup_boilerplate/utils/constants/imports.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    startSplashScreen();
    super.onInit();
  }

  Timer startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () async {
        Get.offAllNamed(krHome);
      },
    );
  }
}
