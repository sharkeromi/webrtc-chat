import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/models/messenger/message_list_model.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/messenger/widget/chat_textfield.dart';
import 'package:startup_boilerplate/views/messenger/widget/custom_bubble.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_app_bar.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_divider.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});
  final MessengerController messengerController = Get.find<MessengerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                isCenterTitle: false,
                titleSpacing: 0,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ClipOval(
                          child: Container(
                            height: h36,
                            width: h36,
                            decoration: const BoxDecoration(
                              color: cBlackColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              messengerController.selectedReceiver.value!.roomImage![0].toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                size: kIconSize24,
                                color: cIconColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: h14,
                            width: h14,
                            decoration: const BoxDecoration(color: cWhiteColor, shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: h12,
                                width: h12,
                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    kW12sizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messengerController.selectedReceiver.value!.roomName!.length > 14
                              ? "${messengerController.selectedReceiver.value!.roomName!.substring(0, 14)}..."
                              : messengerController.selectedReceiver.value!.roomName!,
                          style: semiBold18TextStyle(cBlackColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Active Now",
                          style: regular12TextStyle(cBlackColor).copyWith(fontSize: screenWiseSize(h12, 2)),
                        ),
                      ],
                    )
                  ],
                ),
                onBack: () {
                  Get.back();
                },
                action: [
                  Padding(
                    padding: const EdgeInsets.only(right: h20),
                    child: TextButton(
                      style: kTextButtonStyle,
                      onPressed: () {
                        messengerController.ringUser(messengerController.selectedReceiver.value!.roomUserId, false);
                      },
                      child: Icon(
                        Icons.video_call_rounded,
                        color: cPrimaryColor,
                        size: isDeviceScreenLarge() ? 24 : 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: h20),
                    child: TextButton(
                      style: kTextButtonStyle,
                      onPressed: () {
                        messengerController.ringUser(messengerController.selectedReceiver.value!.roomUserId, true);
                      },
                      child: Icon(
                        Icons.call,
                        color: cPrimaryColor,
                        size: isDeviceScreenLarge() ? 24 : 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: h20),
                    child: TextButton(
                      style: kTextButtonStyle,
                      onPressed: () {},
                      child: Icon(
                        Icons.menu,
                        color: cPrimaryColor,
                        size: isDeviceScreenLarge() ? 24 : 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Obx(() => Stack(
                  children: [
                    Column(
                      children: [
                        const CustomDivider(),
                        Obx(() => Expanded(
                              child: SingleChildScrollView(
                                reverse: true,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemCount: messengerController.allRoomMessageList[messengerController.selectedRoomIndex.value]["messages"].length,
                                      itemBuilder: (context, index) {
                                        MessageData messages =
                                            messengerController.allRoomMessageList[messengerController.selectedRoomIndex.value]["messages"][index];
                                        return CustomBubbleNormal(
                                          userImage: messengerController.selectedReceiver.value!.roomImage![0],
                                          text: messages.text.toString(),
                                          isSender: messages.senderId == Get.find<GlobalController>().userId.value ? true : false,
                                          color: messages.senderId == Get.find<GlobalController>().userId.value ? cPrimaryColor : cNeutralColor,
                                          tail: false,
                                          textStyle:
                                              regular16TextStyle(messages.senderId == Get.find<GlobalController>().userId.value ? cWhiteColor : cBlackColor),
                                        );
                                      },
                                    ),
                                    if (messengerController.isMessageListLoading.value)
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SpinKitThreeBounce(
                                            color: cPrimaryColor,
                                            size: 30,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            )),
                        ChatTextField(),
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
                              style: regular10TextStyle(cBlackColor),
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
