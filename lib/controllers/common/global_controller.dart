import 'package:startup_boilerplate/models/dummy.dart';
import 'package:startup_boilerplate/services/api_services.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

import 'sp_controller.dart';

class GlobalController extends GetxController {
  final SpController spController = SpController();
  final ApiServices apiServices = ApiServices();

  @override
  void onInit() {
    getPostList();

    super.onInit();
  }

  final RxBool isPageLoading = RxBool(false);
  final Rx<TestListModel?> modelData = Rx<TestListModel?>(null);
  final RxList<ListData> listData = RxList<ListData>([]);
  Future<void> getPostList() async {
    try {
      isPageLoading.value = true;
      String? token = await spController.getBearerToken();
      var response = await apiServices.commonApiCall(
        requestMethod: get,
        token: token,
        url: "users?page=1",
      );
      if (response != null) {
        listData.clear();
        modelData.value = TestListModel.fromJson(response);
        listData.addAll(modelData.value!.data!);
        isPageLoading.value = false;
      } else {
        isPageLoading.value = true;

        // ErrorModel errorModel = ErrorModel.fromJson(response.data);
        // if (errorModel.errors.isEmpty) {
        //   showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
        // } else {
        //   showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
        // }
      }
    } catch (e) {
      isPageLoading.value = true;
      ll('getList error: $e');
    }
  }
}
