import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';

import '../home/main_navigation_wrapper.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '77 123 4567');
  final TextEditingController _nameController = TextEditingController(text: 'Suneth Perera');
  UserRole _selectedRole = UserRole.farmer;
  String _selectedDistrict = 'Anuradhapura';
  bool _isLoading = false;

  final List<String> _districts = [
    'Anuradhapura',
    'Polonnaruwa',
    'Matale',
    'Kandy',
    'Nuwara Eliya',
    'Kurunegala',
    'Colombo',
    'Gampaha',
    'Badulla',
    'Hambantota',
    'Jaffna',
    'Ampara',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleDirectLogin() async {
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final formattedPhone = rawPhone.startsWith('+94') ? rawPhone : '+94 $rawPhone';
    final name = _nameController.text.trim().isEmpty ? 'Farmer' : _nameController.text.trim();

    setState(() => _isLoading = true);

    final success = await context.read<AuthProvider>().loginWithPhone(
      formattedPhone,
      name: name,
      role: _selectedRole,
      district: _selectedDistrict,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Reload fresh database items from XAMPP MySQL
      context.read<FarmlyDataProvider>().loadAllData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, $name! Connected to live database.'),
          backgroundColor: FarmlyColors.leafGreen,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
        (route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();


    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: FarmlyColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: langProvider.currentLanguage,
                icon: const Icon(Icons.language, size: 18, color: FarmlyColors.leafGreen),
                style: const TextStyle(
                  color: FarmlyColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'si', child: Text('සිංහල')),
                  DropdownMenuItem(value: 'ta', child: Text('தமிழ்')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    langProvider.setLanguage(val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branding Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Farmly Sri Lanka',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: FarmlyColors.leafGreen,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Direct Phone Login & Database Access',
                  style: TextStyle(
                    fontSize: 13,
                    color: FarmlyColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Form Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: FarmlyColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone Number Input
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: FarmlyColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: FarmlyColors.border),
                          ),
                          child: const Text(
                            '+94',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: FarmlyColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: FarmlyColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: '77 123 4567',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: FarmlyColors.border),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Full Name
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: FarmlyColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Suneth Perera',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: FarmlyColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // District Selection
                    const Text(
                      'Agricultural District',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: FarmlyColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDistrict,
                          isExpanded: true,
                          items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedDistrict = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role Selector
                    const Text(
                      'I am a:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('🌾 Farmer'),
                            selected: _selectedRole == UserRole.farmer,
                            selectedColor: FarmlyColors.warmAmber,
                            onSelected: (_) => setState(() => _selectedRole = UserRole.farmer),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('🛒 Buyer'),
                            selected: _selectedRole == UserRole.buyer,
                            selectedColor: FarmlyColors.warmAmber,
                            onSelected: (_) => setState(() => _selectedRole = UserRole.buyer),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('🏪 Shop'),
                            selected: _selectedRole == UserRole.shop,
                            selectedColor: FarmlyColors.warmAmber,
                            onSelected: (_) => setState(() => _selectedRole = UserRole.shop),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Direct Login Button (No OTP!)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FarmlyColors.warmAmber,
                          foregroundColor: FarmlyColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleDirectLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: FarmlyColors.textPrimary),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue to Farmly',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
