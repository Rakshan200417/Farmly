import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {
        'name': 'Sunil Perera (Farmer)',
        'lastMessage': 'For the entire 500kg lot, we can do Rs. 420 per kg.',
        'time': '10:45 AM',
        'unread': 2,
        'role': 'Farmer • Nuwara Eliya',
      },
      {
        'name': 'Priyashantha Wholesale',
        'lastMessage': 'Can you supply 200kg of big onion by this Friday?',
        'time': 'Yesterday',
        'unread': 0,
        'role': 'Buyer • Colombo',
      },
      {
        'name': 'Perera Agri Inputs & Seeds',
        'lastMessage': 'Neem Oil Extract 500ml is now back in stock.',
        'time': 'Oct 10',
        'unread': 0,
        'role': 'Shop • Dambulla',
      },
      {
        'name': 'Malini D. (Chili Grower)',
        'lastMessage': 'Thank you! The payment slip was received.',
        'time': 'Oct 8',
        'unread': 0,
        'role': 'Farmer • Matale',
      },
    ];

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          // Search Conversation
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
              child: const TextField(
                decoration: InputDecoration(
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

          // Chat List
          Expanded(
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
              itemBuilder: (context, index) {
                final c = conversations[index];
                final hasUnread = (c['unread'] as int) > 0;

                return ListTile(
                  tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(userName: c['name'] as String),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: FarmlyColors.lightGreenOverlay,
                    child: const Icon(Icons.person, color: FarmlyColors.leafGreen, size: 28),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        c['name'] as String,
                        style: TextStyle(
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        c['time'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread ? FarmlyColors.leafGreen : FarmlyColors.textSecondary,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        c['lastMessage'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: hasUnread ? FarmlyColors.textPrimary : FarmlyColors.textSecondary,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  trailing: hasUnread
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: FarmlyColors.warmAmber,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${c['unread']}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
