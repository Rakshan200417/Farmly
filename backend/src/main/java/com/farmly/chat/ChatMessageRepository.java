package com.farmly.chat;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, String> {

    @Query("SELECT m FROM ChatMessage m WHERE (m.senderId = :u1 AND m.recipientId = :u2) OR (m.senderId = :u2 AND m.recipientId = :u1) ORDER BY m.createdAt ASC")
    List<ChatMessage> findConversationBetween(@Param("u1") String u1, @Param("u2") String u2);

    @Query("SELECT m FROM ChatMessage m WHERE m.senderId = :userId OR m.recipientId = :userId ORDER BY m.createdAt DESC")
    List<ChatMessage> findAllForUser(@Param("userId") String userId);
}
