import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/services/api_service.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ConversationItemModel> _conversations = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Default directory of platform contacts for instant chatting
  final List<Map<String, String>> _platformContacts = [
    {
      'id': 'usr-002',
      'name': 'Priyashantha Wholesale',
      'role': 'Buyer • Colombo Dedicated Economic Centre',
      'phone': '+94 71 987 6543',
    },
    {
      'id': 'usr-001',
      'name': 'Suneth Perera (Farmer)',
      'role': 'Farmer • Anuradhapura / Polonnaruwa',
      'phone': '+94 77 123 4567',
    },
    {
      'id': 'usr-003',
      'name': 'Perera Agri Inputs & Seeds',
      'role': 'Agro Shop • Matale & Dambulla',
      'phone': '+94 76 555 1234',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchConversations() async {
    final user = context.read<AuthProvider>().currentUser;
    final userId = user?.id ?? 'usr-001';

    final convs = await ApiService.getConversations(userId);
    if (mounted) {
      setState(() {
        _conversations = convs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredConversations = _conversations.where((c) {
      return c.otherUserName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: FarmlyColors.textPrimary),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchConversations();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: FarmlyColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: Icon(Icons.search, color: FarmlyColors.textSecondary, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // Main Conversation List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: FarmlyColors.leafGreen))
                : _conversations.isEmpty
                    ? _buildEmptyStateWithContacts()
                    : ListView.separated(
                        itemCount: filteredConversations.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                        itemBuilder: (context, index) {
                          final c = filteredConversations[index];
                          final timeStr =
                              '${c.lastMessageTime.hour.toString().padLeft(2, '0')}:${c.lastMessageTime.minute.toString().padLeft(2, '0')}';

                          return ListTile(
                            tileColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatDetailScreen(
                                    recipientId: c.otherUserId,
                                    userName: c.otherUserName,
                                  ),
                                ),
                              );
                              _fetchConversations();
                            },
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: FarmlyColors.lightGreenOverlay,
                              child: Text(
                                c.otherUserName.isNotEmpty ? c.otherUserName[0].toUpperCase() : 'U',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: FarmlyColors.leafGreen,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    c.otherUserName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: FarmlyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              c.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: FarmlyColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWithContacts() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Icon(Icons.forum_outlined, size: 54, color: FarmlyColors.leafGreen.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Text(
                'No conversations yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Start a real-time chat with a verified buyer, farmer, or agro-dealer below:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: FarmlyColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Direct Agriculture Contacts',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: FarmlyColors.deepTeal),
        ),
        const SizedBox(height: 10),
        ..._platformContacts.map((contact) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: FarmlyColors.border),
            ),
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: FarmlyColors.lightGreenOverlay,
                child: const Icon(Icons.person, color: FarmlyColors.leafGreen),
              ),
              title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(contact['role']!, style: const TextStyle(fontSize: 12, color: FarmlyColors.textSecondary)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FarmlyColors.deepTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatDetailScreen(
                        recipientId: contact['id'],
                        userName: contact['name']!,
                        userPhone: contact['phone']!,
                      ),
                    ),
                  );
                  _fetchConversations();
                },
                child: const Text('Chat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }),
      ],
    );
  }
}
