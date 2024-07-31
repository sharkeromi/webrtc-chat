import 'package:startup_boilerplate/controllers/common/global_controller.dart';
import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

class RingingScreen extends StatelessWidget {
  RingingScreen({super.key});

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
                  SizedBox(
                    height: height,
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
                  ),
                  if (messengerController.callState.value == "ringing")
                    Positioned(
                      bottom: 70,
                      // left: (width / 2) - 35,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: SizedBox(
                          width: width - 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  socket.emit('mobile-video-call-${messengerController.callerID.value}', {
                                    'userID': Get.find<GlobalController>().userId.value,
                                    'callStatus': "declined",
                                  });
                                  Get.back();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  height: 70,
                                  width: 70,
                                  child: const Center(
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  socket.emit('mobile-video-call-${messengerController.callerID.value}', {
                                    'userID': Get.find<GlobalController>().userId.value,
                                    'callStatus': "accepted",
                                  });
                                  Get.offAndToNamed(krCallScreen);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
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
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
