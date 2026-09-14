package com.farmly.ai;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/ai/assistant")
@CrossOrigin(origins = "*")
public class AiAssistantController {

    private final GeminiAiService geminiAiService;

    public AiAssistantController(GeminiAiService geminiAiService) {
        this.geminiAiService = geminiAiService;
    }

    @PostMapping("/chat")
    public ResponseEntity<Map<String, String>> chatWithAssistant(@RequestBody Map<String, String> request) {
        String message = request.getOrDefault("message", "");
        String diseaseContext = request.get("diseaseContext");

        String reply = geminiAiService.askAssistant(message, diseaseContext);

        return ResponseEntity.ok(Map.of("reply", reply));
    }
}
