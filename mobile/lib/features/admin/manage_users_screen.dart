import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  bool _isLoading = true;
  List<dynamic> _users = [];
  String _selectedRoleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _users = data;
          _isLoading = false;
        });
      } else {
        _loadFallbackUsers();
      }
    } catch (e) {
      _loadFallbackUsers();
    }
  }

  void _loadFallbackUsers() {
    setState(() {
      _users = [
        {
          'id': 'usr-01',
          'name': 'Suneth Perera',
          'phone': '+94 77 123 4567',
          'role': 'FARMER',
          'district': 'Anuradhapura',
          'isVerified': true,
        },
        {
          'id': 'usr-02',
          'name': 'Priyashantha Wholesale',
          'phone': '+94 71 987 6543',
          'role': 'BUYER',
          'district': 'Colombo',
          'isVerified': true,
        },
        {
          'id': 'usr-03',
          'name': 'Perera Agri Inputs & Seeds',
          'phone': '+94 76 555 1234',
          'role': 'SHOP',
          'district': 'Matale',
          'isVerified': true,
        },
        {
          'id': 'usr-04',
          'name': 'Platform Admin',
          'phone': '+94 70 000 0000',
          'role': 'ADMIN',
          'district': 'Colombo',
          'isVerified': true,
        },
      ];
      _isLoading = false;
    });
  }

  Future<void> _toggleVerification(String userId, int index) async {
    try {
      final response = await http.put(Uri.parse('${ApiService.baseUrl}/users/$userId/verify'));
      if (response.statusCode == 200) {
        final updated = jsonDecode(response.body);
        setState(() {
          _users[index]['isVerified'] = updated['isVerified'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_users[index]['name']} verification updated!'),
            backgroundColor: FarmlyColors.leafGreen,
          ),
        );
      }
    } catch (_) {
      setState(() {
        _users[index]['isVerified'] = !(_users[index]['isVerified'] == true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _selectedRoleFilter == 'All'
        ? _users
        : _users.where((u) => u['role'].toString().toUpperCase() == _selectedRoleFilter).toList();

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
          'Manage Users',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: FarmlyColors.leafGreen),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'FARMER', 'BUYER', 'SHOP', 'ADMIN'].map((role) {
                  final isSelected = _selectedRoleFilter == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        role == 'All' ? 'All Roles' : role,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? FarmlyColors.textPrimary : FarmlyColors.textSecondary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: FarmlyColors.warmAmber,
                      backgroundColor: FarmlyColors.background,
                      onSelected: (_) => setState(() => _selectedRoleFilter = role),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: FarmlyColors.leafGreen))
                : filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found for this role',
                          style: TextStyle(color: FarmlyColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final role = user['role']?.toString().toUpperCase() ?? 'FARMER';
                          final isVerified = user['isVerified'] == true;

                          Color roleColor;
                          IconData roleIcon;
                          switch (role) {
                            case 'ADMIN':
                              roleColor = Colors.purple;
                              roleIcon = Icons.admin_panel_settings;
                              break;
                            case 'SHOP':
                              roleColor = Colors.orange;
                              roleIcon = Icons.storefront;
                              break;
                            case 'BUYER':
                              roleColor = FarmlyColors.deepTeal;
                              roleIcon = Icons.shopping_cart;
                              break;
                            default:
                              roleColor = FarmlyColors.leafGreen;
                              roleIcon = Icons.agriculture;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: FarmlyColors.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: roleColor.withOpacity(0.12),
                                  child: Icon(roleIcon, color: roleColor, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              user['name'] ?? 'Unnamed User',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: FarmlyColors.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isVerified) ...[
                                            const SizedBox(width: 6),
                                            const Icon(Icons.verified, color: Colors.blue, size: 16),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${user['phone'] ?? 'No phone'} • ${user['district'] ?? 'Sri Lanka'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: FarmlyColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: roleColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: roleColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () => _toggleVerification(user['id'] ?? '', index),
                                      child: Text(
                                        isVerified ? 'Unverify' : 'Verify',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isVerified ? Colors.red : Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
