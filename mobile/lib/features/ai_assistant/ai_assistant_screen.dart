import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/farmly_models.dart';
import '../../core/providers/farmly_providers.dart';

class AiAssistantScreen extends StatefulWidget {
  final String? initialPrompt;
  final String? diseaseContext;

  const AiAssistantScreen({super.key, this.initialPrompt, this.diseaseContext});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    '🌾 Paddy blast symptoms & care',
    '🌶️ Chili leaf curl organic remedy',
    '📊 Dambulla wholesale market outlook',
    '🧪 Fertilizer dosage for 1 acre paddy',
    '🌧️ Is it safe to spray before rain?',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FarmlyDataProvider>().sendAiMessage(
          widget.initialPrompt!,
          attachedContext: widget.diseaseContext,
        );
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? prompt]) {
    final text = prompt ?? _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    context.read<FarmlyDataProvider>().sendAiMessage(
      text,
      attachedContext: widget.diseaseContext,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<FarmlyDataProvider>().aiChatMessages;

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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: FarmlyColors.lightGreenOverlay,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: FarmlyColors.leafGreen, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Farmly AI ("Govi Sahakaru")',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
                ),
                Text(
                  'Online • Sri Lanka Agri Advisor',
                  style: TextStyle(fontSize: 11, color: FarmlyColors.leafGreen, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: FarmlyColors.textSecondary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('About Farmly AI'),
                  content: const Text(
                    'Farmly AI ("Govi Sahakaru") is powered by Google Gemini 1.5 Flash. It is specialized in Sri Lankan agricultural practices, Maha/Yala seasons, and Department of Agriculture recommendations.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Prompts Scroll Strip
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickPrompts.length,
              itemBuilder: (context, index) {
                final p = _quickPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    backgroundColor: FarmlyColors.background,
                    side: const BorderSide(color: FarmlyColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () => _sendMessage(p),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: FarmlyColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Mic Voice Button
                  IconButton(
                    icon: const Icon(Icons.mic, color: FarmlyColors.deepTeal),
                    onPressed: () {
                      _sendMessage('මිරිස් වගාවේ කොළ ചുරුලන් රෝගයට හොඳම කාබනික ප්‍රතිකාරය කුමක්ද?');
                    },
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
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Ask in Sinhala, Tamil, or English...',
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
                  // Send Button (Warm Amber)
                  Container(
                    decoration: const BoxDecoration(
                      color: FarmlyColors.warmAmber,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: FarmlyColors.textPrimary, size: 20),
                      onPressed: () => _sendMessage(),
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

  Widget _buildMessageBubble(AiMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isUser ? FarmlyColors.leafGreen : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          border: msg.isUser ? null : Border.all(color: FarmlyColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: FarmlyColors.leafGreen, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Farmly AI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: FarmlyColors.leafGreen,
                    ),
                  ),
                ],
              ),
            if (!msg.isUser) const SizedBox(height: 6),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: msg.isUser ? Colors.white : FarmlyColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
