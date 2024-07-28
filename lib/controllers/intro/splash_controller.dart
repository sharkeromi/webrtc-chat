import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/common/sp_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

class SplashScreenController extends GetxController {
  final SpController spController = SpController();
  @override
  void onInit() async {
    await getRemember();
    startSplashScreen();
    super.onInit();
  }

  bool rememberStatus = false;
  Future<void> getRemember() async {
    bool? state = await spController.getRememberMe();
    if (state == null || state == false) {
      rememberStatus = false;
    } else {
      rememberStatus = true;
    }
  }

  Timer startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () async {
        if (rememberStatus) {
          await Get.find<GlobalController>().getUserInfo();
          // Get.find<GlobalController>().socketInit();
          ll(Get.find<GlobalController>().userId.value);
          Get.offAllNamed(krHome);
        } else {
          await Get.find<GlobalController>().getUserInfo();
          Get.offAllNamed(krLogin);
        }
      },
    );
  }
}
