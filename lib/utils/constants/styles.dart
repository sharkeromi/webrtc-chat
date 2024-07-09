import 'package:startup_boilerplate/utils/constants/imports.dart';

dynamic screenWiseSize(size, difference) {
  return isDeviceScreenLarge() ? size : size - difference;
}

TextStyle regular16TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w400, fontSize: screenWiseSize(h16, 2), color: color);
}

TextStyle regular14TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w400, fontSize: screenWiseSize(h14, 2), color: color);
}

TextStyle regular12TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w400, fontSize: screenWiseSize(h12, 2), color: color);
}


TextStyle medium12TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w500, fontSize: screenWiseSize(h12, 2), color: color);
}

TextStyle medium14TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w500, fontSize: screenWiseSize(h14, 2), color: color);
}

TextStyle medium16TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w500, fontSize: screenWiseSize(h16, 2), color: color);
}

TextStyle semiBold18TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w600, fontSize: screenWiseSize(h18, 2), color: color);
}

TextStyle semiBold16TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w600, fontSize: screenWiseSize(h16, 2), color: color);
}

TextStyle semiBold14TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w600, fontSize: screenWiseSize(h14, 2), color: color);
}

TextStyle semiBold12TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w600, fontSize: screenWiseSize(h12, 2), color: color);
}

TextStyle semiBold10TextStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w600, fontSize: screenWiseSize(h10, 0), color: color);
}

//* info: remove extra padding from TextButton
ButtonStyle? kTextButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  splashFactory: InkSplash.splashFactory,
);