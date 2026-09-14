import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';

class PriceDetailScreen extends StatefulWidget {
  final CropPriceModel cropPrice;

  const PriceDetailScreen({super.key, required this.cropPrice});

  @override
  State<PriceDetailScreen> createState() => _PriceDetailScreenState();
}

class _PriceDetailScreenState extends State<PriceDetailScreen> {
  String _selectedPeriod = '7D';
  String _selectedMarket = 'Dambulla Dedicated Economic Centre';

  final List<String> _markets = [
    'Dambulla Dedicated Economic Centre',
    'Pettah Wholesale Market (Colombo)',
    'Keppetipola Economic Centre',
    'Meegoda Dedicated Economic Centre',
  ];

  @override
  Widget build(BuildContext context) {
    final item = widget.cropPrice;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.cropName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: FarmlyColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Market Dropdown Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedMarket,
                  icon: const Icon(Icons.keyboard_arrow_down, color: FarmlyColors.textPrimary),
                  items: _markets.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMarket = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Price Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Wholesale Rate',
                            style: TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rs. ${item.pricePerKg.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: FarmlyColors.textPrimary,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' / kg',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: FarmlyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.isPositive ? FarmlyColors.successGreenLight : FarmlyColors.alertRedLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.isPositive ? Icons.trending_up : Icons.trending_down,
                              size: 16,
                              color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.changePercent > 0 ? '+' : ''}${item.changePercent.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats Row (High / Average / Low)
                  Row(
                    children: [
                      _buildStatBox('High', 'Rs. ${(item.pricePerKg * 1.15).toStringAsFixed(0)}', FarmlyColors.leafGreen),
                      const SizedBox(width: 10),
                      _buildStatBox('Average', 'Rs. ${(item.pricePerKg * 0.98).toStringAsFixed(0)}', FarmlyColors.deepTeal),
                      const SizedBox(width: 10),
                      _buildStatBox('Low', 'Rs. ${(item.pricePerKg * 0.88).toStringAsFixed(0)}', FarmlyColors.alertRed),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Period Tabs (7D, 1M, 3M)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: ['7D', '1M', '3M'].map((period) {
                      final isSelected = _selectedPeriod == period;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPeriod = period;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? FarmlyColors.deepTeal : FarmlyColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: FarmlyColors.border),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : FarmlyColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // fl_chart Interactive LineChart
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: 1,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(item.sparklinePoints.length, (i) {
                              return FlSpot(i.toDouble(), item.sparklinePoints[i]);
                            }),
                            isCurved: true,
                            color: item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: (item.isPositive ? FarmlyColors.leafGreen : FarmlyColors.alertRed).withOpacity(0.12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Regional Market Comparison
            const Text(
              'Other Regional Wholesale Centres',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _buildMarketComparisonRow('Pettah Market (Colombo)', item.pricePerKg * 1.08),
            _buildMarketComparisonRow('Keppetipola Centre', item.pricePerKg * 0.94),
            _buildMarketComparisonRow('Meegoda Economic Centre', item.pricePerKg * 1.02),
            const SizedBox(height: 16),

            // Source Attribution
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FarmlyColors.lightGreenOverlay,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: FarmlyColors.leafGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Verified with Sri Lanka HARTI Daily Wholesale Bulletins.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: FarmlyColors.leafGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: FarmlyColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FarmlyColors.border),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: FarmlyColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketComparisonRow(String market, double price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(market, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(
            'Rs. ${price.toStringAsFixed(0)} / kg',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: FarmlyColors.deepTeal),
          ),
        ],
      ),
    );
  }
}
