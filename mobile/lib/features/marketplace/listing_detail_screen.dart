import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../chat/chat_detail_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  final ProduceListingModel listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  bool _isFavorite = false;

  void _callFarmer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phone, String crop) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=Hello,%20I%20am%20interested%20in%20your%20$crop%20listing%20on%20Farmly.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.listing;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Farmly',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: FarmlyColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? FarmlyColors.alertRed : FarmlyColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full-width Hero Image with Indicators
                  Stack(
                    children: [
                      Image.network(
                        item.imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Crop Name & Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.cropName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.textPrimary,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs. ${item.pricePerKg.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: FarmlyColors.deepTeal,
                                  ),
                                ),
                                Text(
                                  'per ${item.unit}',
                                  style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: FarmlyColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              item.location,
                              style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Chips
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: FarmlyColors.lightGreenOverlay,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: FarmlyColors.leafGreen),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.eco, size: 14, color: FarmlyColors.leafGreen),
                                  SizedBox(width: 4),
                                  Text(
                                    'Organic Certified',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: FarmlyColors.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: FarmlyColors.border),
                              ),
                              child: const Text(
                                'Freshly Harvested',
                                style: TextStyle(fontSize: 11, color: FarmlyColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 2x2 Listing Details Grid
                        const Text(
                          'Listing Details',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildDetailCard(Icons.scale, 'AVAILABLE QTY', '${item.availableQty.toInt()} ${item.unit}')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildDetailCard(Icons.category, 'VARIETY', item.variety)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildDetailCard(Icons.star_border, 'GRADE', 'Grade A')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildDetailCard(Icons.calendar_today, 'HARVESTED', item.harvestDate)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FarmlyColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary, height: 1.45),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Seller Information Card
                        const Text(
                          'Seller Information',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FarmlyColors.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: FarmlyColors.lightGreenOverlay,
                                child: const Icon(Icons.person, color: FarmlyColors.leafGreen, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(item.farmerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified, color: FarmlyColors.leafGreen, size: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: FarmlyColors.warmAmber, size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${item.farmerRating} (${item.farmerReviewCount} reviews) • Member since 2021',
                                          style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: FarmlyColors.textSecondary),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Pickup Location Map Preview
                        const Text(
                          'Pickup Location',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FarmlyColors.border),
                            image: const DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: FarmlyColors.border),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map, size: 16, color: FarmlyColors.leafGreen),
                                  SizedBox(width: 6),
                                  Text(
                                    'Approximate Location',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Bar with 3 Channels
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: FarmlyColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Chat
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FarmlyColors.lightTealOverlay,
                          foregroundColor: FarmlyColors.deepTeal,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(userName: item.farmerName),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // WhatsApp
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8F8EE),
                          foregroundColor: const Color(0xFF25D366),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.phone_android, size: 18),
                        label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _openWhatsApp(item.farmerPhone, item.cropName),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Call
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FarmlyColors.leafGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Call', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () => _callFarmer(item.farmerPhone),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: FarmlyColors.textSecondary),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: FarmlyColors.textSecondary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary)),
        ],
      ),
    );
  }
}
