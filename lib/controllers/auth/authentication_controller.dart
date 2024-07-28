import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/common/sp_controller.dart';
import 'package:startup_boilerplate/models/common/common_data_model.dart';
import 'package:startup_boilerplate/models/common/common_login_model.dart';
import 'package:startup_boilerplate/services/api_services.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/utils/constants/urls.dart';

class AuthenticationController extends GetxController{
  final GlobalController globalController = Get.find<GlobalController>();
  final ApiServices apiController = ApiServices();
  final SpController spController = SpController();


  final RxBool isLoginLoading = RxBool(false);
  final TextEditingController loginEmailTextEditingController = TextEditingController();
  final TextEditingController loginPasswordTextEditingController = TextEditingController();
   final RxBool isLoginRememberCheck = RxBool(false);
   final RxBool isLoginPasswordToggleObscure = RxBool(true);


  Future<void> userLogin() async {
    try {
      isLoginLoading.value = true;
      Map<String, dynamic> body = {
        'email': loginEmailTextEditingController.text.toString(),
        "password": loginPasswordTextEditingController.text.toString(),
      };
      ll("body : $body");
      var response = await apiController.commonApiCall(
        url: kuLogin,
        body: body,
        requestMethod: post,
      ) as CommonDM;

      if (response.success == true) {
        LoginModel loginData = LoginModel.fromJson(response.data);
        await spController.saveBearerToken(loginData.token);
        await spController.saveRememberMe(true);
        await spController.saveUserId(loginData.user.id);
        await globalController.getUserInfo();
        isLoginLoading.value = false;

        // globalController.socketInit();
        // Get.find<MessengerController>().connectPeer();
        Get.offAllNamed(krHome);

        // final HomeController homeController = Get.find<HomeController>();
        showSnackBar(title: ksSuccess.tr, message: response.message, color: Colors.green, duration: 1000);
        // await homeController.getUserHome();
      } else {
        showSnackBar(title: ksError.tr, message: "Error", color: cRedColor);
      }
    } catch (e) {
      isLoginLoading.value = false;
      ll('userLogin error: $e');
    }
  }
}