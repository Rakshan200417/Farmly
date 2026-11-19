import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import '../marketplace/listing_detail_screen.dart';
import '../profile/profile_screen.dart';

class BuyerHomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const BuyerHomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final listings = context.watch<FarmlyDataProvider>().listings;

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
                  Image.asset(
                    'assets/images/logo.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
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
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: FarmlyColors.textPrimary, size: 26),
                    onPressed: () {},
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: FarmlyColors.lightTealOverlay,
                        shape: BoxShape.circle,
                        border: Border.all(color: FarmlyColors.deepTeal, width: 1.5),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Greeting
              Text(
                'Good morning, ${user?.name.split(' ').first ?? 'Priyashantha'}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: FarmlyColors.border),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search fresh crops...',
                    prefixIcon: const Icon(Icons.search, color: FarmlyColors.textSecondary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onSubmitted: (val) => onNavigateToTab(3),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Filter 2-Column Grid
              Row(
                children: [
                  Expanded(child: _buildCategoryCard(context, 'Vegetables', Icons.eco, FarmlyColors.leafGreen)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCategoryCard(context, 'Fruits', Icons.apple, FarmlyColors.alertRed)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildCategoryCard(context, 'Grains', Icons.grain, FarmlyColors.warmAmber)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCategoryCard(context, 'Spices', Icons.local_fire_department, FarmlyColors.deepTeal)),
                ],
              ),
              const SizedBox(height: 28),

              // "Recommended for you" Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended for you',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab(3),
                    child: const Text('See All', style: TextStyle(color: FarmlyColors.deepTeal, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Horizontal Scroll of Listing Cards
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final item = listings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: item)),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: FarmlyColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                              child: Image.network(
                                item.imageUrl,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.cropName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rs. ${item.pricePerKg.toStringAsFixed(0)} / kg',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.deepTeal, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📍 ${item.distanceKm} km • ${item.farmerName}',
                                    style: const TextStyle(fontSize: 11, color: FarmlyColors.textSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: FarmlyColors.lightGreenOverlay,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Qty: ${item.availableQty.toInt()} kg',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Saved Farmers Strip
              const Text(
                'Favorite Farmers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFarmerAvatar('Suneth P.', 'Anuradhapura', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'),
                    const SizedBox(width: 14),
                    _buildFarmerAvatar('Malini D.', 'Matale', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100'),
                    const SizedBox(width: 14),
                    _buildFarmerAvatar('Kamal W.', 'Polonnaruwa', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100'),
                    const SizedBox(width: 14),
                    _buildFarmerAvatar('Sunil Perera', 'Nuwara Eliya', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=100'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: FarmlyColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerAvatar(String name, String district, String imgUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(imgUrl),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(district, style: const TextStyle(fontSize: 10, color: FarmlyColors.textSecondary)),
      ],
    );
  }
}
