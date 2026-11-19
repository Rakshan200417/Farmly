import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/utils/localization.dart';
import '../home/main_navigation_wrapper.dart';
import '../admin/admin_dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsSignUp;

  const AuthScreen({super.key, this.initialIsSignUp = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isSignUp;

  // Sign In Controllers
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Sign Up Controllers
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpPhoneController = TextEditingController();

  UserRole _selectedRole = UserRole.farmer;
  String _selectedDistrict = 'Anuradhapura';
  bool _obscureSignInPassword = true;
  bool _obscureSignUpPassword = true;
  String? _errorMessage;

  static const List<String> _districts = [
    'Anuradhapura',
    'Polonnaruwa',
    'Matale',
    'Kurunegala',
    'Kandy',
    'Nuwara Eliya',
    'Badulla',
    'Monaragala',
    'Ratnapura',
    'Kegalle',
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Puttalam',
  ];

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsSignUp;
  }

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpPhoneController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    final user = context.read<AuthProvider>().currentUser;
    if (user?.role == UserRole.admin) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
        (route) => false,
      );
    }
  }

  Future<void> _handleSignIn() async {
    final email = _signInEmailController.text.trim();
    final password = _signInPasswordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password.');
      return;
    }

    setState(() => _errorMessage = null);
    final auth = context.read<AuthProvider>();
    final result = await auth.signIn(email: email, password: password);

    if (!mounted) return;

    if (result['success'] == true) {
      _navigateToHome();
    } else {
      setState(() {
        _errorMessage = result['error']?.toString() ?? 'Sign in failed. Check your email and password.';
      });
    }
  }

  Future<void> _handleSignUp() async {
    final name = _signUpNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text;
    final phone = _signUpPhoneController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name.');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _errorMessage = null);
    final auth = context.read<AuthProvider>();
    final result = await auth.signUp(
      name: name,
      email: email,
      password: password,
      role: _selectedRole,
      district: _selectedDistrict,
      phone: phone.isNotEmpty ? phone : '+94771234567',
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully for $name!'),
          backgroundColor: FarmlyColors.leafGreen,
        ),
      );
      _navigateToHome();
    } else {
      setState(() {
        _errorMessage = result['error']?.toString() ?? 'Sign up failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final langCode = context.watch<LanguageProvider>().currentLanguage;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.deepTeal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Logo & Title
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 68,
                          height: 68,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Farmly',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: FarmlyColors.deepTeal,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isSignUp
                              ? AppLocalizations.translate(langCode, 'createAccountMsg')
                              : AppLocalizations.translate(langCode, 'welcomeBack'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: FarmlyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mode Toggle Tab (Sign In vs Sign Up)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: FarmlyColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSignUp = false;
                                _errorMessage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isSignUp ? FarmlyColors.deepTeal : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.translate(langCode, 'signIn'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !_isSignUp ? Colors.white : FarmlyColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSignUp = true;
                                _errorMessage = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isSignUp ? FarmlyColors.leafGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.translate(langCode, 'signUp'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isSignUp ? Colors.white : FarmlyColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error Message Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: FarmlyColors.alertRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: FarmlyColors.alertRed.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: FarmlyColors.alertRed, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: FarmlyColors.alertRed,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Form Container Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: FarmlyColors.border),
                    ),
                    child: _isSignUp ? _buildSignUpForm(isLoading) : _buildSignInForm(isLoading),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Sign In Form ---
  Widget _buildSignInForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signInEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'e.g. suneth@farmly.lk',
            prefixIcon: const Icon(Icons.email_outlined, color: FarmlyColors.textSecondary, size: 20),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Password',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signInPasswordController,
          obscureText: _obscureSignInPassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline, color: FarmlyColors.textSecondary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignInPassword ? Icons.visibility_off : Icons.visibility,
                color: FarmlyColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscureSignInPassword = !_obscureSignInPassword);
              },
            ),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Primary Sign In Button
        ElevatedButton(
          onPressed: isLoading ? null : _handleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: FarmlyColors.deepTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),

        const SizedBox(height: 18),
        const Divider(height: 1),
        const SizedBox(height: 14),

        // "Create Account" button under the bottom of the form
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(color: FarmlyColors.textSecondary, fontSize: 13),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = true;
                  _errorMessage = null;
                });
              },
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: FarmlyColors.leafGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Sign Up Form ---
  Widget _buildSignUpForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Role Selector
        const Text(
          'I am joining as a:',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRoleChip('Farmer', UserRole.farmer, Icons.grass),
            const SizedBox(width: 8),
            _buildRoleChip('Buyer', UserRole.buyer, Icons.storefront),
            const SizedBox(width: 8),
            _buildRoleChip('Shop', UserRole.shop, Icons.local_pharmacy),
          ],
        ),
        const SizedBox(height: 16),

        // Full Name
        const Text(
          'Full Name',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpNameController,
          decoration: InputDecoration(
            hintText: 'e.g. Suneth Perera',
            prefixIcon: const Icon(Icons.person_outline, color: FarmlyColors.textSecondary, size: 20),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Email Address
        const Text(
          'Email Address',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'e.g. suneth@farmly.lk',
            prefixIcon: const Icon(Icons.email_outlined, color: FarmlyColors.textSecondary, size: 20),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Password
        const Text(
          'Password (min. 6 characters)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpPasswordController,
          obscureText: _obscureSignUpPassword,
          decoration: InputDecoration(
            hintText: 'Create secure password',
            prefixIcon: const Icon(Icons.lock_outline, color: FarmlyColors.textSecondary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSignUpPassword ? Icons.visibility_off : Icons.visibility,
                color: FarmlyColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscureSignUpPassword = !_obscureSignUpPassword);
              },
            ),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // District Dropdown
        const Text(
          'Agricultural District',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: FarmlyColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: FarmlyColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDistrict,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: FarmlyColors.textSecondary),
              items: _districts.map((d) {
                return DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 14)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDistrict = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Phone (Optional)
        const Text(
          'Phone Number (Optional)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FarmlyColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _signUpPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'e.g. +94 77 123 4567',
            prefixIcon: const Icon(Icons.phone_outlined, color: FarmlyColors.textSecondary, size: 20),
            filled: true,
            fillColor: FarmlyColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: FarmlyColors.border),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Create Account Action Button
        ElevatedButton(
          onPressed: isLoading ? null : _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: FarmlyColors.leafGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),

        const SizedBox(height: 18),
        const Divider(height: 1),
        const SizedBox(height: 14),

        // "Sign In" link under bottom of the form
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(color: FarmlyColors.textSecondary, fontSize: 13),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = false;
                  _errorMessage = null;
                });
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: FarmlyColors.deepTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleChip(String label, UserRole role, IconData icon) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? FarmlyColors.leafGreen.withOpacity(0.12) : FarmlyColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.border,
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
