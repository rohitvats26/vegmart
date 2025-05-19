import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOrderCard extends StatelessWidget {
  final int delay;

  const ShimmerOrderCard({this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (_, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 180,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
            : SizedBox();
      },
    );
  }
}