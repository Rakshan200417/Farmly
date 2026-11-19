import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../chat/chat_detail_screen.dart';

class ShopDetailScreen extends StatelessWidget {
  final ShopModel shop;

  const ShopDetailScreen({super.key, required this.shop});

  void _callShop(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp(String phone, String shopName) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=Hello%20$shopName,%20I%20saw%20your%20treatment%20stock%20on%20Farmly.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          shop.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: FarmlyColors.textPrimary),
            onPressed: () {},
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
                  // Shop Banner Photo
                  Image.network(
                    'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Name & Verified Badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                shop.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: FarmlyColors.lightGreenOverlay,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, color: FarmlyColors.leafGreen, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(color: FarmlyColors.leafGreen, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Rating & Distance
                        Row(
                          children: [
                            const Icon(Icons.star, color: FarmlyColors.warmAmber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${shop.rating} (${shop.reviewsCount} reviews)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Text('•  ${shop.distanceKm} km away', style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Address & Hours
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 15, color: FarmlyColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                shop.address,
                                style: const TextStyle(fontSize: 13, color: FarmlyColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.access_time, size: 15, color: FarmlyColors.textSecondary),
                            SizedBox(width: 4),
                            Text('Open today: 7:30 AM - 6:00 PM', style: TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Treatment Match Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: FarmlyColors.lightGreenOverlay,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: FarmlyColors.leafGreen.withValues(alpha: 0.4)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 22),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Recommended treatments for Bacterial Leaf Blight are currently in stock at this shop!',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: FarmlyColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Product Catalog
                        const Text(
                          'Available Products & Stock',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                        ),
                        const SizedBox(height: 12),

                        ...shop.products.map((p) => _buildProductRow(p)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Contact Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: FarmlyColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
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
                              builder: (_) => ChatDetailScreen(
                                recipientId: shop.id,
                                userName: shop.name,
                                userPhone: shop.phone,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        onPressed: () => _openWhatsApp(shop.phone, shop.name),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        onPressed: () => _callShop(shop.phone),
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

  Widget _buildProductRow(ShopProductItem p) {
    final isInStock = p.stockStatus == 'in_stock';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${p.category} • ${p.unit}', style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${p.price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: FarmlyColors.deepTeal),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isInStock ? FarmlyColors.lightGreenOverlay : FarmlyColors.alertRedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isInStock ? 'In Stock' : 'Low Stock',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isInStock ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
