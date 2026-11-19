import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/utils/localization.dart';
import '../onboarding/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedDistrict = 'Anuradhapura';
  bool _isSaving = false;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

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
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      if (_districts.contains(user.district)) {
        _selectedDistrict = user.district;
      }
      _base64Image = user.profilePhoto;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      district: _selectedDistrict,
      locationName: '$_selectedDistrict, Sri Lanka',
      profilePicture: _base64Image,
    );
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Profile updated successfully!' : 'Could not save profile.'),
          backgroundColor: success ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.translate(lang.currentLanguage, 'profileSettings'),
          style: const TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: FarmlyColors.leafGreen.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: FarmlyColors.leafGreen, width: 2),
                        image: _base64Image != null && _base64Image!.isNotEmpty
                            ? DecorationImage(
                                image: MemoryImage(base64Decode(_base64Image!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _base64Image == null || _base64Image!.isEmpty
                          ? Center(
                              child: Text(
                                (user?.name.isNotEmpty == true) ? user!.name[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.leafGreen,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user?.name ?? 'Farmer',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, size: 18, color: FarmlyColors.leafGreen),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email.isNotEmpty == true ? user!.email : 'No email registered',
                          style: const TextStyle(
                            fontSize: 13,
                            color: FarmlyColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: FarmlyColors.deepTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user?.role.name.toUpperCase() ?? 'FARMER',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: FarmlyColors.deepTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Profile Edit Form Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: FarmlyColors.deepTeal, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.translate(lang.currentLanguage, 'editPersonalDetails'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: FarmlyColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Name
                  Text(AppLocalizations.translate(lang.currentLanguage, 'fullName'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: FarmlyColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: FarmlyColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: FarmlyColors.border)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Phone
                  Text(AppLocalizations.translate(lang.currentLanguage, 'phoneNumber'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: FarmlyColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: FarmlyColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: FarmlyColors.border)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // District
                  Text(AppLocalizations.translate(lang.currentLanguage, 'agriculturalDistrict'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
                        items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedDistrict = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Save Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FarmlyColors.leafGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(AppLocalizations.translate(lang.currentLanguage, 'saveProfileChanges'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),


            // Language Selection Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: FarmlyColors.deepTeal, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.translate(lang.currentLanguage, 'languagePreferences'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: FarmlyColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      _buildLangOption('English', 'en', lang.currentLanguage == 'en'),
                      const SizedBox(width: 8),
                      _buildLangOption('සිංහල', 'si', lang.currentLanguage == 'si'),
                      const SizedBox(width: 8),
                      _buildLangOption('தமிழ்', 'ta', lang.currentLanguage == 'ta'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),


            // Logout Button
            OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: FarmlyColors.alertRed),
              label: Text(
                AppLocalizations.translate(lang.currentLanguage, 'logoutFromFarmly'),
                style: const TextStyle(color: FarmlyColors.alertRed, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: FarmlyColors.alertRed),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                auth.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(String label, String code, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<LanguageProvider>().setLanguage(code);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? FarmlyColors.leafGreen.withOpacity(0.12) : FarmlyColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
