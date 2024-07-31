import 'dart:developer';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:startup_boilerplate/utils/constants/consts.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/utils/constants/urls.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/common-image_errorBuilder.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_loading.dart';

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

  IO.Socket socket = IO.io(webSocketURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

 Widget imageErrorBuilderCover(context, error, stackTrace, icon, iconSize) {
  return CommonImageErrorBuilder(
    icon: icon,
    iconSize: iconSize,
  );
}

Widget imageLoadingBuilder(context, child, loadingProgress) {
  if (loadingProgress == null) {
    return child;
  }
  return const CustomLoading(
    isTextVisible: false,
  );
}

