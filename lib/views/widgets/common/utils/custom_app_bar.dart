import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/widgets/common/buttons/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.action,
    this.hasBackButton = true,
    required this.onBack,
    this.iconColor,
    this.titleColor,
    this.appBarColor,
    this.isCenterTitle,
    this.systemUiOverlayStyle,
    this.leadingWidget,
    this.leadingWidth,
    this.titleSpacing,
  }) : super(key: key);

  final dynamic title;
  final List<Widget>? action;
  final Function()? onBack;
  final bool hasBackButton;
  final bool? isCenterTitle;
  final Color? iconColor;
  final Color? titleColor;
  final Color? appBarColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final Widget? leadingWidget;
  final double? leadingWidth, titleSpacing;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
      centerTitle: isCenterTitle ?? true,
      automaticallyImplyLeading: false,
      elevation: kCommonElevation,
      titleSpacing: titleSpacing,
      backgroundColor: appBarColor ?? cWhiteColor,
      leadingWidth: leadingWidth ?? kCommonBackSpace,
      title: (title is String)
          ? Text(
              title.toString(),
              style: semiBold18TextStyle(titleColor ?? cBlackColor),
            )
          : title,
      leading: hasBackButton
          ? Center(
              child: CustomIconButton(
                onPress: onBack,
                iconColor: iconColor ?? cBlackColor,
                icon: Icons.arrow_back_ios_new,
              ),
            )
          : leadingWidget,
      actions: action,
    );
  }
}
