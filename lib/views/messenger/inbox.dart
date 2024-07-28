import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/messenger/widget/inbox_shimmer.dart';
import 'package:startup_boilerplate/views/messenger/widget/inbox_widget.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_app_bar.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_divider.dart';

class Inbox extends StatelessWidget {
  Inbox({super.key});
  final MessengerController messengerController = Get.find<MessengerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: cWhiteColor,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: height,
            child: Scaffold(
              backgroundColor: cWhiteColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kAppBarSize),
                //* info:: appBar
                child: CustomAppBar(
                  hasBackButton: true,
                  isCenterTitle: true,
                  title: "Inbox",
                  onBack: () {
                    Get.back();
                  },
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      CustomDivider(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                            child: Column(
                              children: [
                                messengerController.isInternetConnectionAvailable.value ? kH16sizedBox : kH24sizedBox,
                                if (messengerController.roomList.isEmpty && !messengerController.isInboxLoading.value)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 140),
                                    child: Column(
                                      children: [
                                        Text(
                                          "No Chat AvailAble",
                                          style: semiBold18TextStyle(cBlackColor),
                                        ),
                                        kH4sizedBox,
                                        Text(
                                          "No Chat Description",
                                          style: regular12TextStyle(cBlackColor),
                                        )
                                      ],
                                    ),
                                  ),
                                if (!messengerController.isInboxLoading.value)
                                  Padding(
                                    padding: const EdgeInsets.only(top: h16),
                                    child: Obx(() => ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) => kH16sizedBox,
                                        itemCount: messengerController.allRoomMessageList.length,
                                        itemBuilder: (context, index) {
                                          var item = messengerController.allRoomMessageList[index];
                                          return InboxContainer(
                                              index: index,
                                              dataChannel: item['dataChannel'],
                                              peerConnection: item['peerConnection'],
                                              roomID: messengerController.roomList[index].id!,
                                              userID: messengerController.roomList[index].roomUserId!,
                                              userName: messengerController.roomList[index].roomName!,
                                              userImage: messengerController.roomList[index].roomImage![0],
                                              message: item["messages"].isEmpty ? RxString("Test message") : RxString(item["messages"][0].messageText),
                                              isActive: item["status"],
                                              isMute: false,
                                              isLastMessageSelf: false,
                                              isSeen: item['isSeen'],
                                              receiverData: messengerController.roomList[index],
                                              lastMessageTime: messengerController.roomList[index].updatedAt!);
                                        })),
                                  ),
                                if (messengerController.isInboxLoading.value)
                                  const Padding(
                                    padding: EdgeInsets.only(top: h16),
                                    child: InboxShimmer(),
                                  ),
                                kH16sizedBox
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!messengerController.isInternetConnectionAvailable.value)
                    Positioned(
                      top: 1,
                      child: Container(
                        color: cPlaceHolderColor,
                        width: width,
                        height: 20,
                        child: Center(
                          child: Text(
                            "Waiting For Network...",
                            style: regular12TextStyle(cBlackColor).copyWith(fontSize: screenWiseSize(h12, 2)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
