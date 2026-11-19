package com.farmly.chat;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/v1/chat")
@CrossOrigin(origins = "*")
public class ChatController {

    private final ChatMessageRepository chatMessageRepository;

    public ChatController(ChatMessageRepository chatMessageRepository) {
        this.chatMessageRepository = chatMessageRepository;
    }

    @GetMapping("/history")
    public ResponseEntity<List<ChatMessage>> getHistory(
            @RequestParam String user1,
            @RequestParam String user2) {
        return ResponseEntity.ok(chatMessageRepository.findConversationBetween(user1, user2));
    }

    @GetMapping("/conversations")
    public ResponseEntity<List<Map<String, Object>>> getConversations(@RequestParam String userId) {
        List<ChatMessage> all = chatMessageRepository.findAllForUser(userId);
        Map<String, Map<String, Object>> convos = new LinkedHashMap<>();

        for (ChatMessage m : all) {
            String otherId = m.getSenderId().equals(userId) ? m.getRecipientId() : m.getSenderId();
            String otherName = m.getSenderId().equals(userId) ? m.getRecipientName() : m.getSenderName();

            if (!convos.containsKey(otherId)) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("otherUserId", otherId);
                map.put("otherUserName", otherName != null ? otherName : "User");
                map.put("lastMessage", m.getContent());
                map.put("lastTimestamp", m.getCreatedAt().toString());
                convos.put(otherId, map);
            }
        }

        return ResponseEntity.ok(new ArrayList<>(convos.values()));
    }

    @PostMapping("/send")
    public ResponseEntity<ChatMessage> sendMessage(@RequestBody Map<String, String> request) {
        String senderId = request.getOrDefault("senderId", "anonymous");
        String senderName = request.getOrDefault("senderName", "User");
        String recipientId = request.getOrDefault("recipientId", "receiver");
        String recipientName = request.getOrDefault("recipientName", "Farmer / Shop");
        String content = request.getOrDefault("content", "").trim();

        if (content.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        ChatMessage message = new ChatMessage(senderId, senderName, recipientId, recipientName, content);
        ChatMessage saved = chatMessageRepository.save(message);
        return ResponseEntity.ok(saved);
    }
}
