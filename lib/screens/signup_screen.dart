import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegmart/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  final bool isNewUser; // Passed from OTP verification
  const SignupScreen({super.key, required this.isNewUser});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;
  bool _isHovering = false;
  bool _isButtonPressed = false;

  // List of avatar URLs (placeholders; replace with local assets if needed)
  final List<String> _avatars = [
    'avatars/avatar1.png',
    'avatars/avatar2.png',
    'avatars/avatar3.png',
    'avatars/avatar4.png',
    'avatars/avatar5.png',
    'avatars/avatar6.png',
  ];

  // Selected avatar (initially null)
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _controller.forward();
    _loadAvatar(); // Load saved avatar on init
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Load selected avatar
  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAvatar = prefs.getString('selected_avatar');
    });
  }

  // Save selected avatar to shared preferences
  Future<void> _saveAvatar(String? avatar) async {
    final prefs = await SharedPreferences.getInstance();
    if (avatar != null) {
      await prefs.setString('selected_avatar', avatar);
    } else {
      await prefs.remove('selected_avatar');
    }
  }

  // Show bottom sheet with avatar selection
  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select an Avatar",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 16),
                    // Avatar grid
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: _avatars.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAvatar = _avatars[index];
                              });
                              this.setState(() {
                                _selectedAvatar = _avatars[index];
                              });
                              _saveAvatar(_avatars[index]); // Save the selected avatar
                            },
                            child:
                                AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: _selectedAvatar == _avatars[index] ? 1.1 : 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            _selectedAvatar == _avatars[index]
                                                ? const Color(0xFF00C853)
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        _avatars[index],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: const Color(0xFFD3D3D3),
                                            child: const Icon(Icons.person, size: 40, color: Color(0xFF666666)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Clear selection button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedAvatar = null;
                        });
                        this.setState(() {
                          _selectedAvatar = null;
                        });
                        _saveAvatar(null); // Clear the saved avatar
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Clear Selection",
                        style: TextStyle(fontSize: 16, color: Color(0xFF00C853), fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(), primaryColor: const Color(0xFF00C853)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    "Complete Your Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF333333)),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Privacy Text
                      Text(
                        "Don't worry, only you can see your personal data. No one else will be able to see it.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: const Color(0xFF666666), height: 1.5),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 24),

                      // Premium Profile Avatar
                      Center(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTap: _showAvatarSelection, // Show avatar selection on tap
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: _isHovering ? 1.05 : 1.0,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _selectedAvatar != null ? const Color(0xFF00C853) : Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // Display selected avatar or default placeholder
                                          _selectedAvatar != null
                                              ? Image.asset(
                                                _selectedAvatar!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: const Color(0xFFD3D3D3),
                                                    child: const Icon(
                                                      Icons.person,
                                                      size: 100,
                                                      color: Color(0xFF666666),
                                                    ),
                                                  );
                                                },
                                              )
                                              : Container(
                                                color: const Color(0xFFD3D3D3),
                                                child: const Icon(Icons.person, size: 100, color: Color(0xFF666666)),
                                              ),
                                          // Subtle gradient overlay
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.1)],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF00C853),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().scale(delay: 200.ms),
                      const SizedBox(height: 24),

                      // Form Fields
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Field
                            _buildSectionLabel("NAME"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _nameController,
                              validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                            ).animate().fadeIn(delay: 300.ms),
                            const SizedBox(height: 16),

                            // Gender Field
                            _buildSectionLabel("GENDER"),
                            const SizedBox(height: 8),
                            _buildGenderDropdown().animate().fadeIn(delay: 500.ms),
                            const SizedBox(height: 24),

                            // Submit Button
                            MouseRegion(
                              onEnter: (_) => setState(() => _isHovering = true),
                              onExit:
                                  (_) => setState(() {
                                    _isHovering = false;
                                    _isButtonPressed = false;
                                  }),
                              child: GestureDetector(
                                onTapDown: (_) => setState(() => _isButtonPressed = true),
                                onTapUp: (_) {
                                  setState(() => _isButtonPressed = false);
                                  _submitForm();
                                },
                                onTapCancel: () => setState(() => _isButtonPressed = false),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: _isButtonPressed ? 0.98 : 1.0,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [const Color(0xFF00C853), const Color(0xFF00E676)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00C853).withOpacity(_isHovering ? 0.4 : 0.2),
                                          blurRadius: _isHovering ? 20 : 10,
                                          offset: Offset(0, _isButtonPressed ? 2 : 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child:
                                          _isLoading
                                              ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                              )
                                              : const Text(
                                                "Complete Profile",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: 600.ms),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF666666), letterSpacing: 1.2),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String? Function(String?)? validator}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00C853), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
        border: _selectedGender != null ? Border.all(color: const Color(0xFF00C853), width: 1.5) : null,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        validator: (value) => value == null ? 'Please select gender' : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00C853), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: "Select",
          hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 16),
        ),
        items: [
          DropdownMenuItem(
            value: "Male",
            child: Row(
              children: [
                Icon(Icons.male, size: 20, color: const Color(0xFF00C853)),
                const SizedBox(width: 8),
                const Text("Male"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "Female",
            child: Row(
              children: [
                Icon(Icons.female, size: 20, color: const Color(0xFF00C853)),
                const SizedBox(width: 8),
                const Text("Female"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "Other",
            child: Row(
              children: [
                Icon(Icons.transgender, size: 20, color: const Color(0xFF00C853)),
                const SizedBox(width: 8),
                const Text("Other"),
              ],
            ),
          ),
        ],
        onChanged: (value) => setState(() => _selectedGender = value),
        style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF666666)),
        menuMaxHeight: 200,
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
      ),
    ).animate().scale(duration: 300.ms);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAvatar == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an avatar")));
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
