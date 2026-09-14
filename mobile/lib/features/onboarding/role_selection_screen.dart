import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/localization/app_localizations.dart';
import '../home/main_navigation_wrapper.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.farmer;

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LanguageProvider>().currentLanguage;
    final loc = AppLocalizations(langCode);

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: FarmlyColors.border),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.tr('role_selection_title'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: FarmlyColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.tr('role_selection_subtitle'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: FarmlyColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Role 1: Farmer
                    _buildRoleCard(
                      role: UserRole.farmer,
                      icon: Icons.eco_outlined,
                      iconBg: FarmlyColors.lightGreenOverlay,
                      iconColor: FarmlyColors.leafGreen,
                      title: loc.tr('role_farmer'),
                      description: loc.tr('role_farmer_desc'),
                    ),
                    const SizedBox(height: 16),

                    // Role 2: Buyer
                    _buildRoleCard(
                      role: UserRole.buyer,
                      icon: Icons.shopping_cart_outlined,
                      iconBg: FarmlyColors.lightTealOverlay,
                      iconColor: FarmlyColors.deepTeal,
                      title: loc.tr('role_buyer'),
                      description: loc.tr('role_buyer_desc'),
                    ),
                    const SizedBox(height: 16),

                    // Role 3: Shop
                    _buildRoleCard(
                      role: UserRole.shop,
                      icon: Icons.storefront_outlined,
                      iconBg: FarmlyColors.lightAmberOverlay,
                      iconColor: FarmlyColors.warmAmber,
                      title: loc.tr('role_shop'),
                      description: loc.tr('role_shop_desc'),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Continue Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: FarmlyColors.border)),
              ),
              child: SizedBox(
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
                    context.read<AuthProvider>().setSelectedRole(_selectedRole);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loc.tr('continue'),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedRole == role;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.border,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: FarmlyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: FarmlyColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.border,
                    width: isSelected ? 6 : 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
