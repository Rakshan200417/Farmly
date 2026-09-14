import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';

class ShopHomeScreen extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const ShopHomeScreen({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
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
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: FarmlyColors.textPrimary, size: 26),
                    onPressed: () {},
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: FarmlyColors.lightAmberOverlay,
                      shape: BoxShape.circle,
                      border: Border.all(color: FarmlyColors.warmAmber, width: 1.5),
                    ),
                    child: const Icon(Icons.storefront, color: FarmlyColors.warmAmber, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Greeting
              Text(
                'Good morning, ${user?.name.split(' ').first ?? 'Perera Agri'}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Dambulla Branch • Verified Agro-Dealer',
                style: TextStyle(fontSize: 13, color: FarmlyColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // 2x2 Grid of Action Cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.inventory_2,
                      iconBg: FarmlyColors.lightGreenOverlay,
                      iconColor: FarmlyColors.leafGreen,
                      title: 'My Products',
                      subtitle: '24 listed items',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.question_answer,
                      iconBg: FarmlyColors.lightTealOverlay,
                      iconColor: FarmlyColors.deepTeal,
                      title: 'Inquiries',
                      subtitle: '3 new requests',
                      onTap: () => onNavigateToTab(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.add_circle_outline,
                      iconBg: FarmlyColors.lightAmberOverlay,
                      iconColor: FarmlyColors.warmAmber,
                      title: 'Add Product',
                      subtitle: 'List treatment/seed',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.store,
                      iconBg: Colors.grey.shade100,
                      iconColor: FarmlyColors.textPrimary,
                      title: 'Shop Profile',
                      subtitle: 'Hours & location',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Low Stock Alerts Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: FarmlyColors.alertRed.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: FarmlyColors.alertRed, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'Low Stock Alerts',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: FarmlyColors.alertRed),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStockRow('Knapsack Sprayer 16L', 'Only 2 units left'),
                    const Divider(height: 16),
                    _buildStockRow('Copper Oxychloride 500g', '5 packs remaining'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Inquiries List Preview
              const Text(
                'Recent Farmer Inquiries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildInquiryItem('Suneth Perera (Thirappane)', 'Asked about Neem Oil Extract availability', '10m ago'),
              _buildInquiryItem('Kamal Wickrama (Galewela)', 'Requested bulk price for Bio-Compost 50kg', '45m ago'),
              _buildInquiryItem('Malini D. (Matale)', 'Do you have Trichoderma bio-fungicide in stock?', '2h ago'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildStockRow(String product, String stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(product, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: FarmlyColors.alertRedLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            stock,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FarmlyColors.alertRed),
          ),
        ),
      ],
    );
  }

  Widget _buildInquiryItem(String farmer, String text, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: FarmlyColors.lightGreenOverlay,
            child: const Icon(Icons.person_outline, color: FarmlyColors.leafGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(farmer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(fontSize: 11, color: FarmlyColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(text, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
