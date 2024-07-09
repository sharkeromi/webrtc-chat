import 'dart:developer';

import 'package:startup_boilerplate/utils/constants/consts.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

void heightWidthKeyboardValue(context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  keyboardValue = MediaQuery.of(context).viewInsets.bottom;
}

double getPaddingTop(context) => MediaQuery.of(context).padding.top;

void unFocus(context) {
  FocusScope.of(context).unfocus();
}

void ll(message) {
  log(message.toString());
}


// show alert dialog
Future<dynamic> showAlertDialog({context, child}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => child,
  );
}

bool isDeviceScreenLarge() {
  if (height > kSmallDeviceSizeLimit) {
    return true;
  } else {
    return false;
  }
}

void unfocus(context) {
  FocusScope.of(context).unfocus();
}

  void showSnackBar({required String title, required String message, required Color color, duration}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: cWhiteColor,
      maxWidth: 400,
      duration: Duration(milliseconds: duration ?? 1500),
    );
  }


