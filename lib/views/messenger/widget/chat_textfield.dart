import 'package:startup_boilerplate/controllers/messenger/messenger_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/widgets/common/textfield/custom_textfield.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({super.key});
  final MessengerController messengerController = Get.find<MessengerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: cWhiteColor,
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!messengerController.isMessageTextFieldFocused.value)
                  const Padding(
                    padding: const EdgeInsets.only(right: k12Padding, bottom: 14),
                    child: Icon(
                      Icons.mic,
                      color: cPrimaryColor,
                    ),
                  ),
                if (!messengerController.isMessageTextFieldFocused.value)
                  const Padding(
                    padding: const EdgeInsets.only(right: k12Padding, bottom: 14),
                    child: Icon(
                      Icons.image,
                      color: cPrimaryColor,
                    ),
                  ),
                if (!messengerController.isMessageTextFieldFocused.value)
                  const Padding(
                    padding: const EdgeInsets.only(right: k12Padding, bottom: 14),
                    child: Icon(
                      Icons.sticky_note_2_rounded,
                      color: cPrimaryColor,
                    ),
                  ),
                if (!messengerController.isMessageTextFieldFocused.value)
                  const Padding(
                    padding: const EdgeInsets.only(right: k12Padding, bottom: 14),
                    child: Icon(
                      Icons.gif,
                      color: cPrimaryColor,
                    ),
                  ),
                if (messengerController.isMessageTextFieldFocused.value)
                  Padding(
                    padding: const EdgeInsets.only(right: k8Padding, bottom: 10),
                    child: SizedBox(
                      width: 25,
                      child: InkWell(
                        onTap: () {
                          messengerController.isMessageTextFieldFocused.value = false;
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: cPrimaryColor,
                          size: kIconSize35,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CustomModifiedTextField(
                              maxLines: 5,
                              minLines: 1,
                              inputAction: TextInputAction.newline,
                              inputType: TextInputType.multiline,
                              focusNode: messengerController.messageFocusNode,
                              controller: messengerController.messageTextEditingController,
                              suffixIconColor: cPrimaryColor,
                              borderRadius: h18,
                              hint: "Message",
                              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: k8Padding),
                              onChanged: (v) {
                                messengerController.isMessageTextFieldFocused.value = true;
                                messengerController.checkCanSendMessage();
                              },
                            ),
                            const Positioned(
                                bottom: 12,
                                right: 4,
                                child: Icon(
                                  Icons.emoji_emotions_rounded,
                                  color: cPrimaryColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!messengerController.isSendEnabled.value)
                  Padding(
                    padding: const EdgeInsets.only(left: k8Padding, bottom: 14),
                    child: Icon(
                      Icons.thumb_up_alt_rounded,
                      color: cRedColor,
                    ),
                  ),
                if (messengerController.isSendEnabled.value)
                  Padding(
                    padding: const EdgeInsets.only(left: k8Padding, bottom: 14),
                    child: InkWell(
                      onTap: () {
                        ll("STATE: ${messengerController.targetDataChannel!.state}");
                        ll("DC: ${messengerController.targetDataChannel}");
                        ll("Label: ${messengerController.targetDataChannel!.label}");
                        messengerController.sendMessage(messengerController.messageTextEditingController.text.trim(), messengerController.targetDataChannel!);
                      },
                      child: const Icon(
                        Icons.send_rounded,
                        color: cPrimaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
