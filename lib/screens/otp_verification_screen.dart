import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vegmart/screens/signup_screen.dart';
import 'dart:async';
import 'dart:math';
import 'home_screen.dart'; // Assuming this exists

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _otpController;
  late AnimationController _shakeController;
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
        timer.cancel(); // Stop if widget is disposed
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
    if (!mounted) return; // Prevent actions if disposed
    if (_otpController.text.length != 6) {
      setState(() => _isError = true);
      _shakeController.forward(from: 0).then((_) => _shakeController.reset());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a 6-digit OTP'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isVerified = true;
    });

    await Future.delayed(const Duration(milliseconds: 1300));
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
    _otpController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  TextStyle _responsiveTextStyle(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    double scaleFactor = width < 600 ? 1.0 : width < 1024 ? 1.2 : 1.4;
    return TextStyle(fontSize: baseSize * scaleFactor);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      body: Stack(
        children: [
          // Background circle (minimized for mobile)
          if (isDesktop) // Only show on desktop to avoid mobile top space
            Positioned(
              top: -screenWidth * 0.3,
              right: -screenWidth * 0.2,
              child: Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
              ),
            ),

          // Main content
          SafeArea(
            top: !isDesktop, // Ensure SafeArea only affects mobile top
            child: isDesktop
                ? _buildDesktopLayout(context)
                : SingleChildScrollView(child: _buildMobileTabletLayout(context)),
          ),

          // Verification Success Overlay
          if (_isVerified)
            Container(
              color: Colors.green.withOpacity(0.95),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'animations/success.json',
                      width: isDesktop ? 500 : 200,
                      height: isDesktop ? 500 : 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Verification Complete!',
                      style: _responsiveTextStyle(context, 18).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your phone number has been successfully verified',
                      textAlign: TextAlign.center,
                      style: _responsiveTextStyle(context, 14).copyWith(color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SvgPicture.asset('assets/logo.svg', height: 500)),
          const SizedBox(width: 80),
          Expanded(child: _buildOtpForm(context, true)),
        ],
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 24, vertical: 16), // Further reduced from 20
      child: _buildOtpForm(context, false),
    );
  }

  Widget _buildOtpForm(BuildContext context, bool isDesktop) {
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Changed from center to start
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back Button (for mobile/tablet)
        if (!isDesktop)
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero, // Minimize padding
            ),
          ),

        // Logo
        if (!isDesktop)
          SvgPicture.asset(
            'assets/logo.svg',
            height: isTablet ? 120 : 100, // Further reduced from 120/140
          ),
        SizedBox(height: isDesktop ? 60 : isTablet ? 20 : 10), // Reduced for mobile

        // Title
        Text(
          'Verify Your Phone Number',
          style: _responsiveTextStyle(context, 20).copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Enter the 6-digit code sent to ',
            style: _responsiveTextStyle(context, 14).copyWith(color: Colors.grey.shade600),
            children: [
              TextSpan(
                text: widget.phoneNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isDesktop ? 40 : isTablet ? 20 : 12), // Further reduced for mobile

        // OTP Input with Shake Animation
        AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(10 * sin(4 * pi * _shakeController.value), 0),
              child: child,
            );
          },
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: isDesktop ? 60 : 50,
              fieldWidth: isDesktop ? 60 : 50,
              activeColor: _isError ? Colors.red : Colors.green,
              inactiveColor: Colors.grey[300],
              selectedColor: Colors.green,
              activeFillColor: Colors.grey[50],
              inactiveFillColor: Colors.grey[50],
              selectedFillColor: Colors.grey[50],
              borderWidth: 1,
            ),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            enableActiveFill: true,
            onCompleted: (value) => _verifyOTP(),
          ),
        ),
        SizedBox(height: isDesktop ? 40 : isTablet ? 30 : 20),

        // Verify Button
        SizedBox(
          width: isDesktop ? 400 : double.infinity,
          height: isDesktop ? 60 : 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Text(
              'Verify & Continue',
              style: _responsiveTextStyle(context, 16)
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),

        // Resend OTP
        Padding(
          padding: EdgeInsets.only(top: isDesktop ? 30 : 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive code? ",
                style: _responsiveTextStyle(context, 12).copyWith(color: Colors.grey.shade600),
              ),
              TextButton(
                onPressed: _resendCooldown > 0
                    ? null
                    : () {
                  setState(() => _resendCooldown = 30);
                  _startResendTimer();
                },
                child: Text(
                  _resendCooldown > 0 ? "Resend in $_resendCooldown sec" : "Resend now",
                  style: _responsiveTextStyle(context, 12).copyWith(
                    fontWeight: FontWeight.w600,
                    color: _resendCooldown > 0 ? Colors.grey : Colors.green[700],
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