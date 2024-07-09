// final RxBool isPageLoading = RxBool(false);
//     Future<void> getPostList() async {
//     try {
//       isPageLoading.value = true;
//       String? token = await spController.getBearerToken();
//       var response = await apiServices.commonApiCall(
//         requestMethod: get,
//         token: token,
//         url: "URL GOES HERE",
//       ) as CommonDM;
//       if (response.success == true) {
        
//         listData.value = ListModel.fromJson(response.data);

//         isPageLoading.value = false;
//       } else {
//         isPageLoading.value = true;

//         ErrorModel errorModel = ErrorModel.fromJson(response.data);
//         if (errorModel.errors.isEmpty) {
//           globalController.showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
//         } else {
//           globalController.showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
//         }
//       }
//     } catch (e) {
//       isPageLoading.value = true;
//       ll('getList error: $e');
//     }
//   }

// final RxBool isPageLoading = RxBool(false);
//   Future<void> postAPI() async {
//     try {
//       isPageLoading.value = true;
//       Map<String, dynamic> body = {
//       };
//       var response = await apiController.commonApiCall(
//         requestMethod: post,
//         url: "URL GOES HERE",
//         body: body,
//       ) as CommonDM;

//       if (response.success == true) {
//         Model resDATA = Model.fromJson(response.data);
//         isPageLoading.value = false;
//         globalController.showSnackBar(title: ksSuccess.tr, message: response.message, color: cGreenColor, duration: 1000);
//       } else {
//         ErrorModel errorModel = ErrorModel.fromJson(response.data);
//         isPageLoading.value = false;
//         if (errorModel.errors.isEmpty) {
//           globalController.showSnackBar(title: ksError.tr, message: response.message, color: cRedColor);
//         } else {
//           globalController.showSnackBar(title: ksError.tr, message: errorModel.errors[0].message, color: cRedColor);
//         }
//       }
//     } catch (e) {
//       isPageLoading.value = false;
//       ll('postAPI error: $e');
//     }
//   }