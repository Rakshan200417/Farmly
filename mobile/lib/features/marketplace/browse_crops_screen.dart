import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import 'listing_detail_screen.dart';
import '../chat/chat_detail_screen.dart';

class BrowseCropsScreen extends StatefulWidget {
  const BrowseCropsScreen({super.key});

  @override
  State<BrowseCropsScreen> createState() => _BrowseCropsScreenState();
}

class _BrowseCropsScreenState extends State<BrowseCropsScreen> {
  String _searchQuery = '';
  String _selectedSort = 'Nearest';

  void _callFarmer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phone, String crop) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=Hi,%20I%20am%20interested%20in%20your%20$crop%20listing%20on%20Farmly.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<FarmlyDataProvider>().listings;

    final filtered = listings.where((item) {
      return item.cropName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.variety.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.farmerName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
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
                ],
              ),
            ),

            // Search Bar with Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: FarmlyColors.border),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Browse fresh crops...',
                          prefixIcon: Icon(Icons.search, color: FarmlyColors.textSecondary),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: FarmlyColors.border),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: FarmlyColors.textPrimary),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Count & Sort Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found ${filtered.length} listings nearby',
                    style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Text('Sort: ', style: TextStyle(fontSize: 13, color: FarmlyColors.textSecondary)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSort,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: FarmlyColors.leafGreen,
                          ),
                          items: ['Nearest', 'Price: Low to High', 'Recently Listed'].map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedSort = val;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Produce Listings Feed
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return _buildListingCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, ProduceListingModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: item)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Header with Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      item.imageUrl,
                      height: 165,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // "Fresh Picked" Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FarmlyColors.leafGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Fresh Picked',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Distance Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${item.distanceKm} km away',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.cropName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rs. ${item.pricePerKg.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.deepTeal),
                            ),
                            Text('per ${item.unit}', style: const TextStyle(fontSize: 11, color: FarmlyColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.qualityGrade,
                      style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary),
                    ),
                    const SizedBox(height: 10),

                    // Qty Pills
                    Row(
                      children: [
                        _buildPill('Qty: ${item.availableQty.toInt()} ${item.unit} available'),
                        const SizedBox(width: 8),
                        _buildPill('Min. order: ${item.minOrderQty.toInt()} ${item.unit}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Farmer Info & 3-way Contact Pattern
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: FarmlyColors.lightGreenOverlay,
                          child: const Icon(Icons.person, color: FarmlyColors.leafGreen, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.farmerName,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 14),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: FarmlyColors.warmAmber, size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${item.farmerRating} (${item.farmerReviewCount})',
                                    style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Standardized 3-Way Quick Contact Action Buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // In-App Chat
                            _buildQuickActionBtn(
                              icon: Icons.chat_bubble_outline,
                              color: FarmlyColors.deepTeal,
                              bg: FarmlyColors.lightTealOverlay,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatDetailScreen(
                                      recipientId: item.farmerId,
                                      userName: item.farmerName,
                                      userPhone: item.farmerPhone,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            // WhatsApp
                            _buildQuickActionBtn(
                              icon: Icons.phone_android,
                              color: const Color(0xFF25D366),
                              bg: const Color(0xFFE8F8EE),
                              onTap: () => _openWhatsApp(item.farmerPhone, item.cropName),
                            ),
                            const SizedBox(width: 6),
                            // Direct Call
                            _buildQuickActionBtn(
                              icon: Icons.phone,
                              color: Colors.white,
                              bg: FarmlyColors.leafGreen,
                              onTap: () => _callFarmer(item.farmerPhone),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildQuickActionBtn({required IconData icon, required Color color, required Color bg, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: FarmlyColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: FarmlyColors.textPrimary, fontWeight: FontWeight.w500)),
    );
  }
}
