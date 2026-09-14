import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import 'add_listing_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<FarmlyDataProvider>().listings;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Listings',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: FarmlyColors.leafGreen,
          unselectedLabelColor: FarmlyColors.textSecondary,
          indicatorColor: FarmlyColors.leafGreen,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Active (3)'),
            Tab(text: 'Sold (12)'),
            Tab(text: 'Drafts (1)'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FarmlyColors.warmAmber,
        foregroundColor: FarmlyColors.textPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Listing', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddListingScreen()),
          );
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Listings
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final item = listings[index];
              return _buildMyListingCard(item);
            },
          ),
          // Sold Tab
          const Center(child: Text('12 Completed Transactions (Archived)')),
          // Drafts Tab
          const Center(child: Text('1 Saved Produce Draft')),
        ],
      ),
    );
  }

  Widget _buildMyListingCard(ProduceListingModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.cropName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text('Rs. ${item.pricePerKg.toStringAsFixed(0)} / ${item.unit}', style: const TextStyle(color: FarmlyColors.deepTeal, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Stock: ${item.availableQty.toInt()} ${item.unit} • ${item.harvestDate}', style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: FarmlyColors.lightGreenOverlay,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Active on Marketplace', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen)),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: FarmlyColors.textSecondary),
            onSelected: (val) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Listing action: $val')));
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'Edit', child: Text('Edit Listing')),
              const PopupMenuItem(value: 'Sold', child: Text('Mark as Sold')),
              const PopupMenuItem(value: 'Delete', child: Text('Delete Listing', style: TextStyle(color: FarmlyColors.alertRed))),
            ],
          ),
        ],
      ),
    );
  }
}
