import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/widgets/common/buttons/custom_button.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_app_bar.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhiteColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kAppBarSize),
            //* info:: appBar
            child: CustomAppBar(
              appBarColor: cWhiteColor,
              title: "App bar",
              titleColor: cPrimaryColor,
              hasBackButton: false,
              isCenterTitle: false,
              onBack: () {
                Get.back();
              },
            ),
          ),
          body: SizedBox(
            width: width,
            height: height- kAppBarSize,
            child: 
            Center(
              child: CustomElevatedButton(
                label: "Go to messenger",
                onPressed: () async {
                   Get.find<MessengerController>().roomList.clear();
                            Get.toNamed(krInbox);
                            await Get.find<MessengerController>().getRoomList();
                },
              ),
            )
          ),
        ),
      ),
    );
  }

  // customListView() {
  //   return ListView.builder(
  //       itemCount: globalController.listData.length,
  //       shrinkWrap: true,
  //       itemBuilder: (context, index) {
  //         ListData item = globalController.listData[index];
  //         return CustomListTile(
  //           leading: ClipOval(
  //             child: Container(
  //               height: h16,
  //               width: h16,
  //               decoration: const BoxDecoration(
  //                 color: cBlackColor,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Image.network(
  //                 item.avatar ?? "",
  //                 fit: BoxFit.cover,
  //                 errorBuilder: (context, error, stackTrace) => const Icon(
  //                   Icons.person,
  //                   size: kIconSize24,
  //                   color: cIconColor,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           title: Text(item.firstName!),
  //         );
  //       });
  // }
}
