import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/localization/app_localizations.dart';
import '../shops/nearby_shops_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../onboarding/phone_login_screen.dart';

class FarmerHomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const FarmerHomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final langCode = context.watch<LanguageProvider>().currentLanguage;
    final loc = AppLocalizations(langCode);

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Farmly Brand, Notifications & Avatar
              Row(
                children: [
                  const Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'Farmly',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FarmlyColors.leafGreen,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Notification Bell
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: FarmlyColors.textPrimary, size: 26),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications: No new disease outbreak alerts.')),
                          );
                        },
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: FarmlyColors.alertRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // User Avatar
                  InkWell(
                    onTap: () {
                      _showProfileModal(context, user?.name ?? 'Suneth', user?.role.name.toUpperCase() ?? 'FARMER');
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: FarmlyColors.lightGreenOverlay,
                        shape: BoxShape.circle,
                        border: Border.all(color: FarmlyColors.leafGreen, width: 1.5),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date
              const Text(
                'Friday, September 4, 2026',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: FarmlyColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),

              // Greeting
              Text(
                '${loc.tr('good_morning')}, ${user?.name.split(' ').first ?? 'Suneth'}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 18),

              // Horizontal Price Ticker Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTickerChip(label: 'Rice', change: '↑ 5%', isPositive: true),
                    const SizedBox(width: 10),
                    _buildTickerChip(label: 'Onion', change: '↓ 2%', isPositive: false),
                    const SizedBox(width: 10),
                    _buildTickerChip(label: 'Tomato', change: '↑ 1.5%', isPositive: true),
                    const SizedBox(width: 10),
                    _buildTickerChip(label: 'Chili', change: '↓ 4%', isPositive: false),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 2-Column Action Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Check Prices + My Listings
                  Expanded(
                    child: Column(
                      children: [
                        // Card 1: Check Prices
                        _buildSmallCard(
                          icon: Icons.trending_up,
                          iconBg: FarmlyColors.lightGreenOverlay,
                          iconColor: FarmlyColors.leafGreen,
                          title: loc.tr('check_prices'),
                          subtitle: loc.tr('todays_market_rates'),
                          onTap: () => onNavigateToTab(1),
                        ),
                        const SizedBox(height: 16),
                        // Card 2: My Listings
                        _buildSmallCard(
                          icon: Icons.inventory_2_outlined,
                          iconBg: FarmlyColors.lightGreenOverlay,
                          iconColor: FarmlyColors.leafGreen,
                          title: loc.tr('my_listings'),
                          subtitle: loc.tr('manage_produce'),
                          onTap: () => onNavigateToTab(3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Column: Big Featured "Scan crop" Amber Card
                  Expanded(
                    child: Material(
                      color: FarmlyColors.warmAmber,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => onNavigateToTab(2),
                        child: Container(
                          height: 250,
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: FarmlyColors.warmAmber.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.35),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.qr_code_scanner,
                                  color: FarmlyColors.textPrimary,
                                  size: 26,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                loc.tr('scan_crop'),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                loc.tr('scan_crop_desc'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: FarmlyColors.textPrimary.withOpacity(0.85),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Full Width Card: Nearby Shops
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NearbyShopsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: FarmlyColors.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: FarmlyColors.lightGreenOverlay,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: FarmlyColors.leafGreen,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tr('nearby_shops'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                loc.tr('find_treatment_nearby'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: FarmlyColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: FarmlyColors.textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bonus Farmly AI Assistant Card
              Material(
                color: FarmlyColors.deepTeal,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: FarmlyColors.warmAmber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Farmly AI ("Govi Sahakaru")',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ask in Sinhala, Tamil, or English',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: FarmlyColors.warmAmber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: FarmlyColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTickerChip({required String label, required String change, required bool isPositive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: FarmlyColors.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            change,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 117,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FarmlyColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: FarmlyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileModal(BuildContext context, String name, String role) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: FarmlyColors.lightGreenOverlay,
                child: const Icon(Icons.person, size: 40, color: FarmlyColors.leafGreen),
              ),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: FarmlyColors.lightGreenOverlay,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: FarmlyColors.deepTeal),
                title: const Text('Switch Role / Demo Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: FarmlyColors.alertRed),
                title: const Text('Logout', style: TextStyle(color: FarmlyColors.alertRed)),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
