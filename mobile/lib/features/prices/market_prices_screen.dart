import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import 'price_detail_screen.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Vegetables', 'Fruits', 'Grains', 'Spices'];

  @override
  Widget build(BuildContext context) {
    final prices = context.watch<FarmlyDataProvider>().prices;

    final filteredPrices = prices.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.cropName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    hintText: 'Search crop...',
                    prefixIcon: Icon(Icons.search, color: FarmlyColors.textSecondary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Category Chips Strip
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : FarmlyColors.textPrimary,
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: FarmlyColors.deepTeal,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? FarmlyColors.deepTeal : FarmlyColors.border,
                        ),
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Price Cards List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: filteredPrices.length,
                itemBuilder: (context, index) {
                  final item = filteredPrices[index];
                  return _buildCropPriceCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropPriceCard(BuildContext context, CropPriceModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FarmlyColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PriceDetailScreen(cropPrice: item)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Crop Icon in Circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: FarmlyColors.lightGreenOverlay,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _getCropIcon(item.iconType),
                  ),
                ),
                const SizedBox(width: 14),

                // Crop Name, Category & Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.cropName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FarmlyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: FarmlyColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rs. ${item.pricePerKg.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: FarmlyColors.textPrimary,
                              ),
                            ),
                            const TextSpan(
                              text: '/kg',
                              style: TextStyle(
                                fontSize: 13,
                                color: FarmlyColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            item.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 13,
                            color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.changePercent > 0 ? '+' : ''}${item.changePercent.toStringAsFixed(0)}% vs last week',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Mini Sparkline Trend Chart
                SizedBox(
                  width: 90,
                  height: 42,
                  child: CustomPaint(
                    painter: SparklinePainter(
                      points: item.sparklinePoints,
                      color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCropIcon(String type) {
    switch (type) {
      case 'grain':
        return const Icon(Icons.grain, color: FarmlyColors.leafGreen, size: 22);
      case 'onion':
        return const Icon(Icons.adjust, color: FarmlyColors.leafGreen, size: 22);
      case 'tomato':
        return const Icon(Icons.radio_button_checked, color: FarmlyColors.alertRed, size: 22);
      case 'chili':
        return const Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 22);
      default:
        return const Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 22);
    }
  }
}

// Custom Painter for Sparkline Curve
class SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final diff = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final path = Path();
    final dx = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final normY = (points[i] - minVal) / diff;
      final x = i * dx;
      final y = size.height - (normY * (size.height - 8)) - 4;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
