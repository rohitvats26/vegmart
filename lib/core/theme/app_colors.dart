import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color shimmerBase;
  final Color shimmerHighlight;

  const AppColors({
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  static const light = AppColors(
    shimmerBase: Color(0xFFF1F3F5),
    shimmerHighlight: Color(0xFFE9ECEF),
  );

  static const dark = AppColors(
    shimmerBase: Color(0xFF2D333B),
    shimmerHighlight: Color(0xFF373E47),
  );

  @override
  AppColors copyWith({
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColors(
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}
