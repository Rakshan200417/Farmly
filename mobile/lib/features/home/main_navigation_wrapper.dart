import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/localization/app_localizations.dart';
import 'farmer_home_screen.dart';
import 'buyer_home_screen.dart';
import 'shop_home_screen.dart';
import '../prices/market_prices_screen.dart';
import '../diagnosis/crop_scanner_screen.dart';
import '../marketplace/browse_crops_screen.dart';
import '../marketplace/my_listings_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../chat/chat_list_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  final int initialIndex;

  const MainNavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _getHomeScreen(UserRole role) {
    switch (role) {
      case UserRole.farmer:
        return FarmerHomeScreen(
          onNavigateToTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        );
      case UserRole.buyer:
        return BuyerHomeScreen(
          onNavigateToTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        );
      case UserRole.shop:
        return ShopHomeScreen(
          onNavigateToTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        );
      case UserRole.admin:
        return FarmerHomeScreen(
          onNavigateToTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        );
    }
  }

  Widget _getListingsScreen(UserRole role) {
    if (role == UserRole.farmer) {
      return const MyListingsScreen();
    } else {
      return const BrowseCropsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().selectedRole;
    final langCode = context.watch<LanguageProvider>().currentLanguage;
    final loc = AppLocalizations(langCode);

    final List<Widget> screens = [
      _getHomeScreen(role),
      const MarketPricesScreen(),
      const CropScannerScreen(),
      _getListingsScreen(role),
      const ChatListScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FarmlyColors.leafGreen,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.auto_awesome, size: 20, color: FarmlyColors.warmAmber),
        label: Text(
          loc.tr('ask_ai_assistant'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: FarmlyColors.border, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, loc.tr('home')),
                _buildNavItem(1, Icons.trending_up, Icons.trending_up, loc.tr('prices')),
                _buildCenterScanButton(),
                _buildNavItem(3, Icons.inventory_2_outlined, Icons.inventory_2, loc.tr('listings')),
                _buildNavItem(4, Icons.chat_bubble_outline, Icons.chat_bubble, loc.tr('chat')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? FarmlyColors.leafGreen : FarmlyColors.textSecondary;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScanButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2;
        });
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: FarmlyColors.warmAmber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: FarmlyColors.warmAmber.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: FarmlyColors.textPrimary,
          size: 28,
        ),
      ),
    );
  }
}
