import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    this.userPhone = '+94771234567',
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! Are your organic carrots still available for wholesale purchase?',
      'isMe': true,
      'time': '10:32 AM',
    },
    {
      'text': 'Yes, we have 500 kg freshly harvested in Nuwara Eliya. We can arrange transport or farm pickup.',
      'isMe': false,
      'time': '10:35 AM',
    },
    {
      'text': 'Great, what would be the best wholesale rate for the full 500kg lot?',
      'isMe': true,
      'time': '10:40 AM',
    },
    {
      'text': 'For the entire 500kg lot, we can do Rs. 420 per kg. Washed and packed in 25kg gunny sacks.',
      'isMe': false,
      'time': '10:45 AM',
    },
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _call() async {
    final uri = Uri.parse('tel:${widget.userPhone}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openWhatsApp() async {
    final cleanPhone = widget.userPhone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': 'Now',
      });
      _msgController.clear();
    });
  }

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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: FarmlyColors.lightGreenOverlay,
              child: const Icon(Icons.person, color: FarmlyColors.leafGreen, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                  ),
                  const Text(
                    'Online • Sri Lanka',
                    style: TextStyle(fontSize: 11, color: FarmlyColors.leafGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Pinned WhatsApp shortcut in header
          IconButton(
            icon: const Icon(Icons.phone_android, color: Color(0xFF25D366)),
            onPressed: _openWhatsApp,
          ),
          // Pinned Phone call shortcut in header
          IconButton(
            icon: const Icon(Icons.phone, color: FarmlyColors.leafGreen),
            onPressed: _call,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = m['isMe'] as bool;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? FarmlyColors.deepTeal : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isMe ? 14 : 2),
                        bottomRight: Radius.circular(isMe ? 2 : 14),
                      ),
                      border: isMe ? null : Border.all(color: FarmlyColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['text'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: isMe ? Colors.white : FarmlyColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            m['time'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe ? Colors.white70 : FarmlyColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_camera_outlined, color: FarmlyColors.textSecondary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: FarmlyColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: FarmlyColors.border),
                      ),
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: FarmlyColors.warmAmber,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: FarmlyColors.textPrimary, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
