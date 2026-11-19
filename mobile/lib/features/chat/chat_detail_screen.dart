import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';
import '../../core/services/api_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String? recipientId;
  final String userPhone;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    this.recipientId,
    this.userPhone = '+94771234567',
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessageModel> _messages = [];
  bool _isLoading = true;

  String get _effectiveRecipientId {
    if (widget.recipientId != null && widget.recipientId!.isNotEmpty) {
      return widget.recipientId!;
    }
    return widget.userName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final currentUser = context.read<AuthProvider>().currentUser;
    final currentUserId = currentUser?.id ?? 'guest_user';

    final history = await ApiService.getChatHistory(currentUserId, _effectiveRecipientId);
    if (mounted) {
      setState(() {
        _messages = history;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
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

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final currentUser = context.read<AuthProvider>().currentUser;
    final senderId = currentUser?.id ?? 'usr-${DateTime.now().millisecondsSinceEpoch}';
    final senderName = currentUser?.name ?? 'Farmer';

    _msgController.clear();

    // Optimistically add to list
    final tempMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: senderId,
      senderName: senderName,
      recipientId: _effectiveRecipientId,
      recipientName: widget.userName,
      content: text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.add(tempMsg);
    });
    _scrollToBottom();

    // Send to MySQL backend
    final saved = await ApiService.sendChatMessage(
      senderId: senderId,
      senderName: senderName,
      recipientId: _effectiveRecipientId,
      recipientName: widget.userName,
      content: text,
    );

    if (saved != null && mounted) {
      setState(() {
        _messages.removeLast();
        _messages.add(saved);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;
    final currentUserId = currentUser?.id ?? '';

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
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Online • Sri Lanka Market',
                    style: TextStyle(fontSize: 11, color: FarmlyColors.leafGreen, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android, color: Color(0xFF25D366)),
            onPressed: _openWhatsApp,
            tooltip: 'WhatsApp',
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: FarmlyColors.leafGreen),
            onPressed: _call,
            tooltip: 'Call Phone',
          ),
        ],
      ),
      body: Column(
        children: [
          // Live Chat Messages
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: FarmlyColors.leafGreen))
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 48, color: FarmlyColors.textSecondary.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'Start conversation with ${widget.userName}',
                              style: const TextStyle(color: FarmlyColors.textSecondary, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Real-time messages are stored securely in MySQL',
                              style: TextStyle(color: FarmlyColors.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final m = _messages[index];
                          final isMe = m.senderId == currentUserId ||
                              (currentUserId.isEmpty && m.senderName == (currentUser?.name ?? 'Farmer'));

                          final timeStr =
                              '${m.createdAt.hour.toString().padLeft(2, '0')}:${m.createdAt.minute.toString().padLeft(2, '0')}';

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.content,
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
                                      timeStr,
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
                      color: FarmlyColors.leafGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
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
