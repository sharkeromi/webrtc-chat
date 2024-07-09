import 'package:flutter/cupertino.dart';

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
