import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/models/farmly_models.dart';

class MarketplaceApprovalsScreen extends StatefulWidget {
  const MarketplaceApprovalsScreen({super.key});

  @override
  State<MarketplaceApprovalsScreen> createState() => _MarketplaceApprovalsScreenState();
}

class _MarketplaceApprovalsScreenState extends State<MarketplaceApprovalsScreen> {
  final Set<String> _approvedListingIds = {};

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<FarmlyDataProvider>().listings;

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
          'Marketplace Approvals',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
      ),
      body: listings.isEmpty
          ? const Center(
              child: Text(
                'No pending listings to review',
                style: TextStyle(color: FarmlyColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                final isApproved = _approvedListingIds.contains(item.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: FarmlyColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: FarmlyColors.background,
                                child: const Icon(Icons.image_not_supported, color: FarmlyColors.textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.cropName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'By ${item.farmerName} • ${item.location}',
                                  style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rs. ${item.pricePerKg.toStringAsFixed(0)}/kg • ${item.quantityKg} kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FarmlyColors.leafGreen,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isApproved ? FarmlyColors.lightGreenOverlay : Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isApproved ? 'Approved & Live' : 'Pending Review',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isApproved ? FarmlyColors.leafGreen : Colors.orange[800],
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Listing ${item.cropName} flagged for moderation review.')),
                              );
                            },
                            child: const Text('Reject', style: TextStyle(color: Colors.red, fontSize: 13)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApproved ? Colors.grey[300] : FarmlyColors.leafGreen,
                              foregroundColor: isApproved ? Colors.black54 : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () {
                              setState(() {
                                if (isApproved) {
                                  _approvedListingIds.remove(item.id);
                                } else {
                                  _approvedListingIds.add(item.id);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isApproved ? 'Approval revoked.' : 'Listing Approved! Live on Marketplace.'),
                                  backgroundColor: FarmlyColors.leafGreen,
                                ),
                              );
                            },
                            child: Text(isApproved ? 'Undo' : 'Approve', style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
