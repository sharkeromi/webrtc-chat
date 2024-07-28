import 'package:startup_boilerplate/utils/constants/imports.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.thickness});
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Divider(
        thickness: thickness ?? 1,
        height: 1,
        color: cGreyBoxColor,
      ),
    );
  }
}