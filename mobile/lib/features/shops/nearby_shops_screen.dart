import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import 'shop_detail_screen.dart';

class NearbyShopsScreen extends StatefulWidget {
  const NearbyShopsScreen({super.key});

  @override
  State<NearbyShopsScreen> createState() => _NearbyShopsScreenState();
}

class _NearbyShopsScreenState extends State<NearbyShopsScreen> {
  bool _isMapView = true;
  String _searchQuery = '';
  int _selectedShopIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shops = context.watch<FarmlyDataProvider>().shops;

    final filtered = shops.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

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
          'Nearby Shops',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: FarmlyColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Map/List Toggle Control
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: FarmlyColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: FarmlyColors.border),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Search organic, seeds, tools...',
                        prefixIcon: Icon(Icons.search, size: 20, color: FarmlyColors.textSecondary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Segmented Toggle
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: FarmlyColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: FarmlyColors.border),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton(
                        icon: Icons.map_outlined,
                        label: 'Map',
                        isActive: _isMapView,
                        onTap: () => setState(() => _isMapView = true),
                      ),
                      _buildToggleButton(
                        icon: Icons.list,
                        label: 'List',
                        isActive: !_isMapView,
                        onTap: () => setState(() => _isMapView = false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main View Content
          Expanded(
            child: _isMapView
                ? _buildMapView(filtered)
                : _buildListView(filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? FarmlyColors.leafGreen : FarmlyColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? FarmlyColors.leafGreen : FarmlyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(List<ShopModel> filtered) {
    final currentShop = filtered.isNotEmpty ? filtered[_selectedShopIndex.clamp(0, filtered.length - 1)] : null;

    return Stack(
      children: [
        // Simulated Sri Lanka Map Background
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1000',
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.9),
            colorBlendMode: BlendMode.screen,
          ),
        ),

        // Interactive Pins
        Positioned(
          top: 80,
          left: 120,
          child: _buildMapPin(index: 0, label: 'Perera Agri'),
        ),
        Positioned(
          top: 170,
          right: 90,
          child: _buildMapPin(index: 1, label: 'Govi Setha'),
        ),
        Positioned(
          top: 260,
          left: 80,
          child: _buildMapPin(index: 2, label: 'Lanka Agro'),
        ),

        // Floating Bottom Shop Preview Card matching Nearby Shops (Map).png
        if (currentShop != null)
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=300',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    currentShop.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: FarmlyColors.leafGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.white, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${currentShop.rating}',
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '🚶 ${currentShop.distanceKm} km away',
                              style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: currentShop.tags.take(3).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: FarmlyColors.background,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: FarmlyColors.border),
                                  ),
                                  child: Text(tag, style: const TextStyle(fontSize: 10, color: FarmlyColors.textSecondary)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FarmlyColors.leafGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: currentShop)),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('View Shop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMapPin({required int index, required String label}) {
    final isSelected = _selectedShopIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedShopIndex = index),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FarmlyColors.border),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
              ],
            ),
            child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 2),
          Icon(
            Icons.store,
            color: isSelected ? FarmlyColors.leafGreen : FarmlyColors.deepTeal,
            size: isSelected ? 36 : 28,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<ShopModel> filtered) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final shop = filtered[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: FarmlyColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=300',
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  shop.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: FarmlyColors.warmAmber, size: 14),
                                  const SizedBox(width: 2),
                                  Text('${shop.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(shop.address, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: FarmlyColors.lightGreenOverlay,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${shop.distanceKm} km away',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FarmlyColors.leafGreen),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('In Stock: Neem Oil, Copper', style: TextStyle(fontSize: 11, color: FarmlyColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
