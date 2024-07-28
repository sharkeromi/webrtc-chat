import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:startup_boilerplate/utils/constants/imports.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    this.isTextVisible = true,
  
    super.key, this.radius,
  });

  final bool isTextVisible;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CupertinoActivityIndicator(radius: radius??20),
          if (isTextVisible) const Text('Loading...'),
        ],
      ),
    );
  }
}

class CommonLoadingAnimation extends StatelessWidget {
  const CommonLoadingAnimation({super.key, required this.onWillPop, this.backgroundColor});
  final Future<bool> Function() onWillPop;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: backgroundColor ?? Colors.black.withOpacity(.3),
        child:  const Center(
          child: SpinKitThreeBounce(
            color: cPrimaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}