import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_helper.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

class CallScreen extends StatelessWidget {
  CallScreen({super.key});

  final MessengerController messengerController = Get.find<MessengerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhiteColor,
      child: SafeArea(
        top: false,
        child: Obx(
          () => SizedBox(
            height: height,
            child: Scaffold(
              backgroundColor: cWhiteColor,
              body: Stack(
                children: [
                  if (messengerController.callState.value == "inCall")
                    Expanded(
                      child: messengerController.isRemoteFeedStreaming.value
                          ? (messengerController.callState.value == "ringing"
                              ? RTCVideoView(messengerController.localRenderer, mirror: true)
                              : RTCVideoView(messengerController.remoteRenderer))
                          : const SizedBox(),
                    ),
                  if (messengerController.callState.value == "ringing")
                    Positioned(
                        top: 100,
                        child: SizedBox(
                          width: width,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 200,
                              ),
                              Container(
                                height: isDeviceScreenLarge() ? 150 : (150 - h10),
                                width: isDeviceScreenLarge() ? 150 : (150 - h10),
                                decoration: BoxDecoration(
                                  color: cBlackColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: cWhiteColor.withAlpha(500), width: 2),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    messengerController.callerImage.value.toString(),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) => imageErrorBuilderCover(
                                      context,
                                      error,
                                      stackTrace,
                                      Icons.person_2_rounded,
                                      70.0,
                                    ),
                                    loadingBuilder: imageLoadingBuilder,
                                  ),
                                ),
                              ),
                              kH20sizedBox,
                              Text(messengerController.callerName.value),
                            ],
                          ),
                        )),
                  Positioned(
                      bottom: 70,
                      // left: (width / 2) - 35,
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  MessengerHelper().switchCamera(messengerController.callerID.value);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: cBlackColor, shape: BoxShape.circle),
                                  height: 70,
                                  width: 70,
                                  child: const Center(
                                    child: Icon(
                                      Icons.cameraswitch_rounded,
                                      color: cWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  MessengerHelper().hangUp();
                                  Get.back();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  height: 70,
                                  width: 70,
                                  child: const Center(
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  MessengerHelper().toggleMuteAudio();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: cBlackColor, shape: BoxShape.circle),
                                  height: 70,
                                  width: 70,
                                  child: const Center(
                                    child: Icon(
                                      Icons.mic_off_rounded,
                                      color: cWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  if (messengerController.callState.value == "inCall")
                    Positioned(
                      top: 50,
                      right: 20,
                      child: SizedBox(
                        height: 200,
                        width: 150,
                        child:
                            messengerController.isLocalFeedStreaming.value ? RTCVideoView(messengerController.localRenderer, mirror: true) : const SizedBox(),
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
