import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    super.key,
    required this.discount,
    this.bannerTopOffset = -8.0,
    this.bannerLeftOffset = -25.6,
    this.bannerTextTopOffset = -2.0,
    this.bannerTextLeftOffset = -10.0,
    this.kWidth = 100.0,
    this.kHeight = 50.0,
    this.kTextSizeLarge = 9.0,
    this.kTextSizeSmall = 8.0,
  });

  final String? discount;
  final double? bannerTopOffset;
  final double? bannerLeftOffset;
  final double? bannerTextTopOffset;
  final double? bannerTextLeftOffset;
  final double? kWidth;
  final double? kHeight;
  final double? kTextSizeLarge;
  final double? kTextSizeSmall;

  @override
  Widget build(BuildContext context) {
    if (discount == null || discount!.isEmpty) {
      return Container();
    }
    final discountValue = discount?.split(' ')[0]; // Handle potential errors if split doesn't work as expected

    return Positioned(
      top: bannerTopOffset,
      left: bannerLeftOffset,
      child: SizedBox(
        width: kWidth,
        height: kHeight,
        child: Stack(
          children: [
            ClipRRect(
              child: Image.asset("assets/badge2.png", height: kHeight, width: kWidth, fit: BoxFit.fill),
            ),
            Positioned(
              top: bannerTextTopOffset,
              bottom: 0,
              left: bannerTextLeftOffset,
              // Assuming the inner offset is the same
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(discountValue!, style: TextStyle(color: Colors.white, fontSize: kTextSizeLarge, fontWeight: FontWeight.bold)),
                  Text('OFF', style: TextStyle(color: Colors.white, fontSize: kTextSizeSmall, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
