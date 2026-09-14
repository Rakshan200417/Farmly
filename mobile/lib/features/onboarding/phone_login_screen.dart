import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/localization/app_localizations.dart';
import 'otp_verification_screen.dart';
import '../home/main_navigation_wrapper.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '71 234 5678');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showExaminerDemoSheet(BuildContext context, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: FarmlyColors.lightGreenOverlay,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school, color: FarmlyColors.leafGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.tr('examiner_demo_mode'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FarmlyColors.textPrimary,
                          ),
                        ),
                        Text(
                          loc.tr('examiner_demo_subtitle'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: FarmlyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                loc.tr('select_demo_role'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: FarmlyColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),

              // Demo Farmer: Sunil Perera
              _buildDemoPersonaTile(
                context: context,
                icon: Icons.agriculture,
                name: 'Suneth Perera (Farmer)',
                district: 'Anuradhapura • Paddy & Veg',
                color: FarmlyColors.leafGreen,
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AuthProvider>().loginWithDemoRole(UserRole.farmer);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                    (route) => false,
                  );
                },
              ),

              // Demo Buyer: Priyashantha
              _buildDemoPersonaTile(
                context: context,
                icon: Icons.storefront,
                name: 'Priyashantha Wholesale (Buyer)',
                district: 'Pettah Wholesale Market, Colombo',
                color: FarmlyColors.deepTeal,
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AuthProvider>().loginWithDemoRole(UserRole.buyer);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                    (route) => false,
                  );
                },
              ),

              // Demo Shop: Perera Agri Inputs
              _buildDemoPersonaTile(
                context: context,
                icon: Icons.local_florist,
                name: 'Perera Agri Inputs (Shop)',
                district: 'Dambulla • Agro-chemicals & Organic',
                color: FarmlyColors.warmAmber,
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AuthProvider>().loginWithDemoRole(UserRole.shop);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDemoPersonaTile({
    required BuildContext context,
    required IconData icon,
    required String name,
    required String district,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        tileColor: FarmlyColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: FarmlyColors.border),
        ),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(district, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: FarmlyColors.textSecondary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LanguageProvider>().currentLanguage;
    final loc = AppLocalizations(langCode);

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Farmly Green Leaf Mark
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: FarmlyColors.lightGreenOverlay,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.eco,
                    size: 38,
                    color: FarmlyColors.leafGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                loc.tr('login_with_phone'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.leafGreen,
                ),
              ),
              const SizedBox(height: 32),

              // White Card Form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: FarmlyColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.tr('phone_number'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phone input with +94
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
                              hintText: '71 234 5678',
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
                    const SizedBox(height: 12),
                    Text(
                      loc.tr('phone_helper'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: FarmlyColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Send OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FarmlyColors.warmAmber,
                          foregroundColor: FarmlyColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OTPVerificationScreen(
                                phoneNumber: '+94 ${_phoneController.text}',
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              loc.tr('send_otp'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider: or
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontSize: 13,
                              color: FarmlyColors.textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Examiner Demo Mode Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FarmlyColors.deepTeal,
                          side: const BorderSide(color: FarmlyColors.deepTeal, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.school, size: 20),
                        label: Text(
                          loc.tr('examiner_demo_mode'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => _showExaminerDemoSheet(context, loc),
                      ),
                    ),
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
