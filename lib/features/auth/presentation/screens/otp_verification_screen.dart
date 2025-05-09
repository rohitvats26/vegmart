import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'dart:math';

import 'package:vegmart/features/auth/presentation/screens/signup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _otpController;
  late final AnimationController _shakeController;
  bool _isLoading = false;
  bool _isVerified = false;
  bool _isError = false;
  int _resendCooldown = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (!mounted || _otpController.text.length != 6) return;

    setState(() => _isError = true);
    await _shakeController.forward(from: 0);
    if (!mounted) return;
    _shakeController.reset();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isVerified = true;
    });

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignupScreen(isNewUser: true),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _resendTimer = null;
    _shakeController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Responsive sizing based on screen width
  double _responsiveSize(BuildContext context, double small, double medium, double large, double xlarge) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 395) return small; // Small mobile
    if (width < 400) return medium; // Medium mobile
    if (width < 600) return large; // Large mobile
    if (width <= 1024) return xlarge; // Tablet
    return xlarge * 1.2; // Desktop
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Screen type detection
    final isSmallMobile = width < 360;
    final isMediumMobile = width < 400;
    final isLargeMobile = width < 600;
    final isTablet = width < 1024 && width >= 600;
    final isDesktop = width >= 1024;

    return Scaffold(
      body: Stack(
        children: [
          // Background decoration for larger screens
          if (isDesktop || isTablet)
            Positioned(
              top: -height * 0.2,
              right: -width * 0.1,
              child: Container(
                width: width * 0.6,
                height: width * 0.6,
                decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              ),
            ),

          // Main content
          SafeArea(
            child:
                isDesktop
                    ? _buildDesktopLayout(context)
                    : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: _responsiveSize(context, 16, 20, 24, 32),
                        horizontal: _responsiveSize(context, 16, 20, 24, 48),
                      ),
                      child: _buildMobileTabletLayout(context),
                    ),
          ),

          // Verification Success Overlay
          if (_isVerified)
            Container(
              color: colorScheme.primary.withOpacity(0.95),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'animations/success.json',
                      width: _responsiveSize(context, 150, 180, 200, 300),
                      height: _responsiveSize(context, 150, 180, 200, 300),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: _responsiveSize(context, 16, 20, 24, 32)),
                    Text(
                      'Verification Complete!',
                      style: TextStyle(
                        fontSize: _responsiveSize(context, 16, 18, 20, 24),
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: _responsiveSize(context, 8, 10, 12, 16)),
                    Text(
                      'Your phone number has been successfully verified',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _responsiveSize(context, 12, 14, 16, 18),
                        color: colorScheme.onPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SvgPicture.asset(
                  'assets/enter_otp.svg',
                ),
              ),
            ),
            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.all(32.0), child: _buildOtpForm(context, true))),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context) {
    return _buildOtpForm(context, false);
  }

  Widget _buildOtpForm(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600 && !isDesktop;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back Button (for mobile/tablet)
        if (!isDesktop)
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: _responsiveSize(context, 18, 20, 22, 24),
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),

        // Logo
        if (!isDesktop)
          Padding(
            padding: EdgeInsets.only(
              top: _responsiveSize(context, 8, 12, 16, 24),
              bottom: _responsiveSize(context, 8, 12, 16, 24),
            ),
            child: SvgPicture.asset(
              'assets/enter_otp.svg',
              height: _responsiveSize(context, 80, 100, 120, 150),
            ),
          ),

        // Title Section
        Padding(
          padding: EdgeInsets.symmetric(vertical: _responsiveSize(context, 8, 12, 16, 24)),
          child: Column(
            children: [
              Text(
                'Verify Your Phone Number',
                style: TextStyle(
                  fontSize: _responsiveSize(context, 18, 20, 22, 24),
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              SizedBox(height: _responsiveSize(context, 4, 6, 8, 12)),
              Text.rich(
                TextSpan(
                  text: 'Enter the 6-digit code sent to ',
                  style: TextStyle(
                    fontSize: _responsiveSize(context, 12, 14, 16, 18),
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  children: [
                    TextSpan(text: widget.phoneNumber, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // OTP Input Field
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: _responsiveSize(context, 16, 20, 24, 28),
            horizontal: isDesktop ? 0 : width * 0.05, // Reduced from 0.1 to use more space
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate optimal field size based on available width
              final availableWidth = constraints.maxWidth;
              final fieldCount = 6;
              final spacing = _responsiveSize(context, 8, 10, 12, 14);
              final minFieldSize = _responsiveSize(context, 36, 40, 44, 48);
              final maxFieldSize = _responsiveSize(context, 52, 56, 60, 64);

              // Calculate field size that fits perfectly in available width
              double fieldSize = min(
                maxFieldSize,
                max(
                  minFieldSize,
                  (availableWidth - (fieldCount - 1) * spacing) / fieldCount,
                ),
              );

              return AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(8 * sin(4 * pi * _shakeController.value), 0),
                    child: child,
                  );
                },
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  animationType: AnimationType.fade,
                  autoFocus: true,
                  autoDismissKeyboard: true,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: fieldSize,
                    fieldWidth: fieldSize,
                    activeColor: _isError
                        ? colorScheme.error
                        : colorScheme.primary,
                    inactiveColor: colorScheme.onSurface.withOpacity(0.2),
                    selectedColor: colorScheme.primary,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                    borderWidth: _responsiveSize(context, 1.5, 2, 2.5, 3),
                  ),
                  textStyle: TextStyle(
                    fontSize: _responsiveSize(context, 20, 22, 24, 26),
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                  enableActiveFill: false,
                  onCompleted: (value) => _verifyOTP(),
                  onChanged: (value) {
                    if (_isError && value.length < 6) {
                      setState(() => _isError = false);
                    }
                  },
                  beforeTextPaste: (text) {
                    // Only allow numeric input
                    return RegExp(r'^[0-9]+$').hasMatch(text ?? '');
                  },
                ),
              );
            },
          ),
        ),

        // Verify Button
        SizedBox(
          width: isDesktop ? _responsiveSize(context, 300, 350, 400, 450) : double.infinity,
          height: _responsiveSize(context, 48, 50, 52, 56),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_responsiveSize(context, 10, 12, 14, 16))),
              elevation: 0,
            ),
            child:
                _isLoading
                    ? SizedBox(
                      width: _responsiveSize(context, 20, 22, 24, 26),
                      height: _responsiveSize(context, 20, 22, 24, 26),
                      child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary)),
                    )
                    : Text(
                      'Verify & Continue',
                      style: TextStyle(
                        fontSize: _responsiveSize(context, 14, 16, 18, 20),
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
          ),
        ),

        // Resend OTP Section
        Padding(
          padding: EdgeInsets.only(top: _responsiveSize(context, 16, 20, 24, 32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive code? ",
                style: TextStyle(
                  fontSize: _responsiveSize(context, 10, 12, 14, 16),
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              TextButton(
                onPressed:
                    _resendCooldown > 0
                        ? null
                        : () {
                          setState(() => _resendCooldown = 30);
                          _startResendTimer();
                        },
                child: Text(
                  _resendCooldown > 0 ? "Resend in $_resendCooldown sec" : "Resend now",
                  style: TextStyle(
                    fontSize: _responsiveSize(context, 10, 12, 14, 16),
                    fontWeight: FontWeight.w600,
                    color: _resendCooldown > 0 ? colorScheme.onSurface.withOpacity(0.4) : colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
