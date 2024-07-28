import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/services/api_services.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

import 'sp_controller.dart';

class GlobalController extends GetxController {
  final SpController spController = SpController();
  final ApiServices apiServices = ApiServices();

  @override
  void onInit() {
    super.onInit();
  }

  final Rx<String?> userName = Rx<String?>(null);
  final Rx<String?> userFirstName = Rx<String?>(null);
  final Rx<String?> userLastName = Rx<String?>(null);
  final Rx<String?> userImage = Rx<String?>(null);
  final Rx<String?> userEmail = Rx<String?>(null);
  final Rx<int?> userId = Rx<int?>(null);
  final Rx<String?> userToken = Rx<String?>(null);

  Future<void> getUserInfo() async {
    SpController spController = SpController();

    userId.value = await spController.getUserId();
    userToken.value = await spController.getBearerToken();
  }

  RxList<Map<String, dynamic>> allOnlineUsers = RxList<Map<String, dynamic>>([]);
  void populatePeerList(newUserData) {
    allOnlineUsers.add({"userID": newUserData});

    if (Get.find<MessengerController>().allRoomMessageList.isNotEmpty) {
      Get.find<MessengerController>().updateRoomListWithOnlineUsers();
    }
  }
}
