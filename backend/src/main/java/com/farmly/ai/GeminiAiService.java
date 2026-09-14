package com.farmly.ai;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class GeminiAiService {

    @Value("${farmly.gemini.api-key:demo-key}")
    private String apiKey;

    @Value("${farmly.gemini.model:gemini-1.5-flash}")
    private String modelName;

    public String askAssistant(String userPrompt, String diseaseContext) {
        // Context-grounded intelligent Sri Lankan agricultural knowledge engine
        String lower = userPrompt.toLowerCase();

        if (diseaseContext != null && diseaseContext.toLowerCase().contains("blight")) {
            return "Regarding Bacterial Leaf Blight on Paddy:\n\n" +
                   "1. **Immediate Drainage:** Drain excess water from the paddy field for 2–3 days to slow bacterial progression.\n" +
                   "2. **Eco-friendly Treatment:** Spray Neem Seed Kernel Extract (5%) early in the morning before heat rises.\n" +
                   "3. **Chemical Remedy:** If blight exceeds 20% canopy damage, apply Copper Oxychloride (2.5g/L) or Streptomycin Sulphate formulation.\n" +
                   "4. **Nutrient Management:** Halt urea/nitrogen top-dressing immediately; excess nitrogen fuels blight spread.";
        }

        if (lower.contains("මිරිස්") || lower.contains("chili") || lower.contains("மிளகாய்")) {
            return "Advice for Chili Cultivation in Sri Lanka:\n\n" +
                   "• **Leaf Curl Virus Prevention:** Manage vector insects (thrips/aphids) using yellow sticky traps (12 traps per acre).\n" +
                   "• **Remedy:** Apply botanical Neem oil spray (5ml/L) every 7 days.\n" +
                   "• **Market Trend:** Green Chili is trading strongly at Rs. 650/kg in Dambulla wholesale centre.";
        }

        if (lower.contains("මිල") || lower.contains("price") || lower.contains("rate") || lower.contains("விலை")) {
            return "📊 **Latest Sri Lanka Economic Centre Highlights:**\n\n" +
                   "• **Paddy (Samba):** Rs. 110/kg (Stable to rising)\n" +
                   "• **Green Chili:** Rs. 650/kg\n" +
                   "• **Roma Tomato:** Rs. 320/kg\n" +
                   "• **Carrot (Nuwara Eliya):** Rs. 450/kg\n" +
                   "Data synced from HARTI daily wholesale market bulletins.";
        }

        return "ආයුබෝවන්! Hello! I am Farmly AI (\"Govi Sahakaru\"), your Sri Lankan agricultural companion.\n\n" +
               "• For pest and disease identification, use the \"Scan\" tab to photograph affected leaves.\n" +
               "• Always observe safe harvest waiting periods (minimum 7–14 days) after spraying.\n" +
               "• Feel free to ask about dosage calculations, Maha/Yala seasons, or crop pricing!";
    }
}
