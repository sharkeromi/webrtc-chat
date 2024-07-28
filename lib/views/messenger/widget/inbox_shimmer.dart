import 'dart:math';

import 'package:startup_boilerplate/utils/constants/imports.dart';
import 'package:startup_boilerplate/views/widgets/common/utils/custom_shimmer.dart';

class InboxShimmer extends StatelessWidget {
  const InboxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemCount: 15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => kH16sizedBox,
            itemBuilder: (context, index) {
              return Container(
                color: cWhiteColor,
                width: width,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: cWhiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: ShimmerCommon(
                        widget: Container(
                          decoration: const BoxDecoration(color: cWhiteColor, shape: BoxShape.circle),
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    kW12sizedBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerCommon(
                            widget: Container(
                              decoration: BoxDecoration(color: cWhiteColor, borderRadius: k8CircularBorderRadius),
                              height: 14,
                              width: getNameShimmerLength(),
                            ),
                          ),
                          // kH4sizedBox,
                          ShimmerCommon(
                            widget: Container(
                              decoration: BoxDecoration(color: cWhiteColor, borderRadius: k8CircularBorderRadius),
                              height: 10,
                              width: getMessageShimmerLength(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ShimmerCommon(
                      widget: Container(
                        decoration: const BoxDecoration(color: cWhiteColor, shape: BoxShape.circle),
                        height: 14,
                        width: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

double getMessageShimmerLength() {
  final Random random = Random();
  return (random.nextInt(201) + 50).toDouble();
}

double getNameShimmerLength() {
  final Random random = Random();
  return (random.nextInt(101) + 80).toDouble();
}
