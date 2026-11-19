import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'manage_users_screen.dart';
import 'marketplace_approvals_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Analytics Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Users', '4 Seed / Live', Icons.people, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Platform Volume', 'Rs. 240k', Icons.monetization_on, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Active Listings', '4 Live Crops', Icons.store, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('System Status', 'All Online', Icons.verified_user, Colors.teal)),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
            ),
            const SizedBox(height: 12),

            _buildActionItem(
              context: context,
              title: 'Manage Users',
              subtitle: 'View, verify, and filter Farmers, Buyers, and Shops',
              icon: Icons.manage_accounts,
              iconColor: Colors.blue,
              destination: const ManageUsersScreen(),
            ),

            _buildActionItem(
              context: context,
              title: 'Marketplace Approvals',
              subtitle: 'Review & approve farmer crop listings',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              destination: const MarketplaceApprovalsScreen(),
            ),

            _buildActionItem(
              context: context,
              title: 'System & API Settings',
              subtitle: 'Spring Boot Backend: http://10.0.2.2:8081/api/v1',
              icon: Icons.settings,
              iconColor: FarmlyColors.deepTeal,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('System Info'),
                    content: const Text(
                      'Backend: Spring Boot 3.3.4 (Port 8081)\nDatabase: MySQL (HikariCP Pool: Active)\nMobile Gateway: http://10.0.2.2:8081/api/v1\nAI Model: Gemini 2.5 Flash / Crop Diagnostic ML',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: FarmlyColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: FarmlyColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? destination,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FarmlyColors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: FarmlyColors.textSecondary),
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );
          } else if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}
