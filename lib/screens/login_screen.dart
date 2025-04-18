import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegmart/screens/otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool permissionGranted;

  const LoginScreen({super.key, required this.permissionGranted});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _countryCode = '+91';
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _submitPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                OtpVerificationScreen(phoneNumber: '$_countryCode${_mobileController.text}'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    setState(() => _isLoading = false);
    // Navigate to OTP screen in real implementation
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter mobile number';
    if (value.length != 10) return 'Must be 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only digits allowed';
    return null;
  }

  TextStyle _responsiveTextStyle(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    double scaleFactor =
        width < 600
            ? 1.0
            : width < 1024
            ? 1.2
            : 1.4;
    return TextStyle(fontSize: baseSize * scaleFactor);
  }

  Widget _buildSocialButton(String assetPath, double size) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: SvgPicture.asset(assetPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      body: Stack(
        children: [
          // Responsive background circle
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
            child: Center(
              child:
                  isDesktop
                      ? _buildDesktopLayout(context)
                      : SingleChildScrollView(child: _buildMobileTabletLayout(context)),
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
          Expanded(child: _buildLoginForm(context, true)),
        ],
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 24, vertical: 40),
      child: _buildLoginForm(context, false),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isDesktop) {
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        if (!isDesktop)
          SvgPicture.asset(
            'assets/logo.svg',
            height:
                isDesktop
                    ? 200
                    : isTablet
                    ? 180
                    : 150,
          ),
        SizedBox(
          height:
              isDesktop
                  ? 60
                  : isTablet
                  ? 40
                  : 30,
        ),
        // Title
        Text(
          'Enter your Phone Number',
          style: _responsiveTextStyle(context, 20).copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          'We will send you a 6 digit verification code',
          style: _responsiveTextStyle(context, 14).copyWith(color: Colors.grey.shade600),
        ),
        SizedBox(
          height:
              isDesktop
                  ? 40
                  : isTablet
                  ? 30
                  : 20,
        ),

        // Form
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: _validateMobileNumber,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Phone Number',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 12, top: 14, bottom: 16),
                    child: Text(_countryCode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: isDesktop ? 20 : 16, horizontal: 16),
                ),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: isDesktop ? 40 : 30),

              // Continue Button
              SizedBox(
                width: isDesktop ? 400 : double.infinity,
                height: isDesktop ? 60 : 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : Text(
                            'Continue',
                            style: _responsiveTextStyle(
                              context,
                              16,
                            ).copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ),

        // Terms and Conditions
        Padding(
          padding: EdgeInsets.only(top: isDesktop ? 30 : 20),
          child: Text.rich(
            TextSpan(
              text: 'By continuing, you agree to our ',
              style: _responsiveTextStyle(context, 12).copyWith(color: Colors.grey.shade600),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Divider
        Padding(
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 30 : 20),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Or continue with',
                  style: _responsiveTextStyle(context, 14).copyWith(color: Colors.grey.shade600),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
        ),

        // Social Login Buttons
        Wrap(
          alignment: WrapAlignment.center,
          spacing: isDesktop ? 30 : 20,
          runSpacing: 20,
          children: [
            _buildSocialButton('assets/google_icon.svg', isDesktop ? 70 : 56),
            _buildSocialButton('assets/facebook_icon.svg', isDesktop ? 70 : 56),
            _buildSocialButton('assets/apple_icon.svg', isDesktop ? 70 : 56),
          ],
        ),
        SizedBox(height: isDesktop ? 40 : 20),
      ],
    );
  }
}
