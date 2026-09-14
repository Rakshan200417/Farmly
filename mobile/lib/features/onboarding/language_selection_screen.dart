import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import 'phone_login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Leaf Icon
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
              const SizedBox(height: 24),
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your preferred language to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: FarmlyColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // Language Option: Sinhala
              _buildLanguageCard(
                context: context,
                code: 'si',
                title: 'සිංහල',
                subtitle: 'Sinhala',
              ),
              const SizedBox(height: 16),

              // Language Option: Tamil
              _buildLanguageCard(
                context: context,
                code: 'ta',
                title: 'தமிழ்',
                subtitle: 'Tamil',
              ),
              const SizedBox(height: 16),

              // Language Option: English
              _buildLanguageCard(
                context: context,
                code: 'en',
                title: 'English',
                subtitle: 'English',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String code,
    required String title,
    required String subtitle,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.read<LanguageProvider>().setLanguage(code);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FarmlyColors.border, width: 1.2),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: FarmlyColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
