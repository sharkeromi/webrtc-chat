import 'package:startup_boilerplate/controllers/auth/authentication_controller.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/widgets/common/buttons/custom_button.dart';
import 'package:startup_boilerplate/views/widgets/common/buttons/custom_text_button.dart';
import 'package:startup_boilerplate/views/widgets/common/textfield/custom_textfield.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_loading.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final AuthenticationController authenticationController = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    heightWidthKeyboardValue(context);
    return Container(
      decoration: const BoxDecoration(
        color: cWhiteColor,

      ),
      child: Obx(
        () => Stack(
          children: [
            SafeArea(
              top: false,
              child: Scaffold(
                backgroundColor: cTransparentColor,
                body: SizedBox(
                  height: height,
                  width: width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        kH30sizedBox,

                        kH25sizedBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: h20),
                          child: CustomModifiedTextField(

                            controller: authenticationController.loginEmailTextEditingController,
                            hint: "Email",
                            textHintStyle: regular16TextStyle(cGreyBoxColor),
                            fillColor: cWhiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(k4BorderRadius),
                              borderSide: const BorderSide(width: 1, color: cGreyBoxColor),
                            ),
                            onChanged: (text) {
                              // loginHelper.loginEmailEditorOnChanged();
                            },
                            onSubmit: (text) {},
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: h20),
                          child: CustomModifiedTextField(
                            controller: authenticationController.loginPasswordTextEditingController,
                            hint: "Password",
                            textHintStyle: regular16TextStyle(cGreyBoxColor),
                            fillColor: cWhiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(k4BorderRadius),
                              borderSide: const BorderSide(width: 1, color: cGreyBoxColor),
                            ),
                            suffixIcon: authenticationController.isLoginPasswordToggleObscure.value ? Icons.visibility_off_outlined: Icons.visibility_outlined,
                            onSuffixPress: () {
                              authenticationController.isLoginPasswordToggleObscure.value = !authenticationController.isLoginPasswordToggleObscure.value;
                            },
                            onChanged: (text) {
                              // loginHelper.loginPasswordEditorOnChanger();
                            },
                            onSubmit: (text) {},
                            obscureText: authenticationController.isLoginPasswordToggleObscure.value,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.visiblePassword,
                          ),
                        ),
                        kH24sizedBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: h20),
                          child: CustomElevatedButton(
                            label: "Log in",
                            onPressed: () async {
                                    unFocus(context);
                                    await authenticationController.userLogin();
                                  }
                                ,
                            buttonWidth: width - 40,
                            textStyle:
                                 semiBold16TextStyle(cWhiteColor),
                          ),
                        ),


                        kH40sizedBox,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (authenticationController.isLoginLoading.value == true)
              Positioned(
                child: CommonLoadingAnimation(
                  onWillPop: () async {
                    if (authenticationController.isLoginLoading.value) {
                      return false;
                    }
                    return true;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxAndContainer extends StatelessWidget {
  const CheckBoxAndContainer({
    Key? key,
    required this.onTapCheckBox,
    required this.onPressForgetButton,
    required this.isChecked,
  }) : super(key: key);

  final Function(bool?) onTapCheckBox;
  final VoidCallback onPressForgetButton;
  final RxBool isChecked;

  @override
  Widget build(BuildContext context) {
    var textStyle = regular14TextStyle(cPrimaryColor);
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicWidth(
            child: CustomCheckBox(
              value: isChecked.value,
              onChanged: onTapCheckBox,
              label: "Remember me",
              textStyle: regular14TextStyle(cBlackColor),
            ),
          ),
          CustomTextButton(
            onPressed: onPressForgetButton,
            textStyle: textStyle,
            text: "Forgot Password.,"
          ),
        ],
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;
  final TextStyle textStyle;

  const CustomCheckBox({
    required this.value,
    required this.label,
    required this.onChanged,
    required this.textStyle,
    Key? key,
  }) : super(key: key);

  Widget buildCheckBox() {
    return Container(
      width: isDeviceScreenLarge() ? h18 : h14,
      height: isDeviceScreenLarge() ? h18 : h14,
      decoration: BoxDecoration(
        border: Border.all(color: value ? cPrimaryColor : cIconColor, width: 1),
        borderRadius: BorderRadius.circular(k4BorderRadius),
        color: value ? cPrimaryColor : cWhiteColor,
      ),
      child: value
          ? Icon(
              Icons.check,
              color: cWhiteColor,
              size: isDeviceScreenLarge() ? kIconSize14 : kIconSize12,
            )
          : null,
    );
  }

  Widget buildLabel() {
    return Expanded(
      child: Text(
        label.toString(),
        textAlign: TextAlign.justify,
        style: textStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        color: cTransparentColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCheckBox(),
              const SizedBox(width: 10),
              buildLabel(),
              kEmptySizedBox,
            ],
          ),
        ),
      ),
    );
  }
}

