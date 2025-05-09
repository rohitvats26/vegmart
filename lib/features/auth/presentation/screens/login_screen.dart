import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vegmart/features/auth/presentation/screens/otp_verification_screen.dart';

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
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpVerificationScreen(phoneNumber: '$_countryCode${_mobileController.text}'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    setState(() => _isLoading = false);
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter mobile number';
    if (value.length != 10) return 'Must be 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only digits allowed';
    return null;
  }

  // Responsive sizing based on screen width
  double _responsiveSize(BuildContext context, double small, double medium, double large, double xlarge) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 395) return small;        // Small mobile
    if (width < 480) return medium;       // Normal mobile
    if (width < 600) return large;        // Large mobile
    if (width <= 1024) return xlarge;      // Tablet
    return xlarge * 1.2;                  // Desktop
  }

  // Responsive padding based on screen width
  EdgeInsets _responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);  // Small mobile
    if (width < 480) return const EdgeInsets.symmetric(horizontal: 20, vertical: 24);  // Normal mobile
    if (width < 600) return const EdgeInsets.symmetric(horizontal: 30, vertical: 30);  // Large mobile
    if (width < 1024) return const EdgeInsets.symmetric(horizontal: 60, vertical: 40); // Tablet
    return const EdgeInsets.symmetric(horizontal: 120, vertical: 60);                  // Desktop
  }

  Widget _buildSocialButton(String assetPath, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = _responsiveSize(context, 48, 56, 60, 70);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? null : [
          BoxShadow(
          color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4)
          ),
      ],
    ),
    child: SvgPicture.asset(assetPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Responsive background circle
          Positioned(
            top: -screenWidth * 0.3,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.green.withOpacity(0.05)
                      : Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle
              ),
            ),
          ),

          // Main content with responsive padding
          SafeArea(
            child: Center(
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : SingleChildScrollView(
                child: Padding(
                  padding: _responsivePadding(context),
                  child: _buildMobileTabletLayout(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: _responsivePadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: _responsiveSize(context, 150, 180, 200, 500),
            ),
          ),
          SizedBox(width: _responsiveSize(context, 20, 30, 40, 80)),
          Expanded(
            child: _buildLoginForm(context, true),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabletLayout(BuildContext context) {
    return _buildLoginForm(context, false);
  }

  Widget _buildLoginForm(BuildContext context, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSmallMobile = MediaQuery.of(context).size.width < 360;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo (hidden on desktop as it's shown in the row)
        if (!isDesktop)
          SvgPicture.asset(
            'assets/logo.svg',
            height: _responsiveSize(context, 250, 300, 300, 380),
          ),
        SizedBox(height: _responsiveSize(context, 20, 30, 40, 60)),

        // Title
        Text(
          'Enter your Phone Number',
          style: TextStyle(
            fontSize: _responsiveSize(context, 18, 20, 22, 24),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: isSmallMobile ? 4 : 8),
        Text(
          'We will send you a 6 digit verification code',
          style: TextStyle(
            fontSize: _responsiveSize(context, 12, 14, 16, 16),
            color: isDark ? Colors.grey[400] : Colors.grey.shade600,
          ),
        ),
        SizedBox(height: _responsiveSize(context, 20, 30, 40, 40)),

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
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        _responsiveSize(context, 10, 12, 14, 16)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: _responsiveSize(context, 16, 20, 22, 24),
                      right: _responsiveSize(context, 10, 12, 14, 16),
                      top: isSmallMobile ? 10 : 14,
                      bottom: isSmallMobile ? 10 : 16,
                    ),
                    child: Text(
                      _countryCode,
                      style: TextStyle(
                        fontSize: _responsiveSize(context, 14, 16, 18, 18),
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: isDesktop
                        ? _responsiveSize(context, 16, 18, 20, 22)
                        : _responsiveSize(context, 12, 14, 16, 18),
                    horizontal: _responsiveSize(context, 12, 16, 18, 20),
                  ),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: _responsiveSize(context, 14, 16, 16, 18),
                  ),
                ),
                style: TextStyle(
                  fontSize: _responsiveSize(context, 14, 16, 18, 18),
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: _responsiveSize(context, 20, 30, 40, 40)),

              // Continue Button
              SizedBox(
                width: isDesktop
                    ? _responsiveSize(context, 300, 350, 400, 400)
                    : double.infinity,
                height: _responsiveSize(context, 48, 52, 56, 60),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          _responsiveSize(context, 12, 14, 16, 16)),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                    width: _responsiveSize(context, 20, 24, 24, 24),
                    height: _responsiveSize(context, 20, 24, 24, 24),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: _responsiveSize(context, 14, 16, 18, 18),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Terms and Conditions
        Padding(
          padding: EdgeInsets.only(top: _responsiveSize(context, 16, 20, 30, 30)),
          child: Text.rich(
            TextSpan(
              text: 'By continuing, you agree to our ',
              style: TextStyle(
                fontSize: _responsiveSize(context, 10, 12, 12, 14),
                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
              ),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: _responsiveSize(context, 10, 12, 12, 14),
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: _responsiveSize(context, 10, 12, 12, 14),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Divider
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: _responsiveSize(context, 16, 20, 30, 30)),
          child: Row(
            children: [
              Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey.shade300)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: _responsiveSize(context, 8, 16, 16, 16)),
                child: Text(
                  'Or continue with',
                  style: TextStyle(
                    fontSize: _responsiveSize(context, 12, 14, 14, 16),
                    color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey.shade300)),
            ],
          ),
        ),

        // Social Login Buttons
        Wrap(
          alignment: WrapAlignment.center,
          spacing: _responsiveSize(context, 16, 20, 30, 30),
          runSpacing: _responsiveSize(context, 16, 20, 20, 20),
          children: [
            _buildSocialButton('assets/google_icon.svg', context),
            _buildSocialButton('assets/facebook_icon.svg', context),
            _buildSocialButton('assets/apple_icon.svg', context),
          ],
        ),
        SizedBox(height: _responsiveSize(context, 16, 20, 30, 40)),
      ],
    );
  }
}