import 'package:startup_boilerplate/utils/constants/imports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    heightWidthKeyboardValue(context);
    return Scaffold(
      backgroundColor: cWhiteColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Text("Splash Screen"),
        ),
      ),
    );
  }
}
