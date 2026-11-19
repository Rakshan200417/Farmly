package com.farmly.diagnosis;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/diagnosis")
@CrossOrigin(origins = "*")
public class DiagnosisController {

    private final DiseaseRepository diseaseRepository;

    public DiagnosisController(DiseaseRepository diseaseRepository) {
        this.diseaseRepository = diseaseRepository;
    }

    @PostMapping("/scan")
    public ResponseEntity<?> diagnoseCrop(@RequestBody Map<String, String> request) {
        String cropName = request.getOrDefault("cropName", "Paddy (Rice)").trim();

        DiseaseTreatmentMapping diagnosis = diseaseRepository.findAll().stream()
                .filter(d -> d.getCropName().equalsIgnoreCase(cropName) ||
                             cropName.toLowerCase().contains(d.getCropName().toLowerCase()) ||
                             d.getCropName().toLowerCase().contains(cropName.toLowerCase().split(" ")[0]))
                .findFirst()
                .orElseGet(() -> diseaseRepository.findAll().stream().findFirst().orElse(null));

        if (diagnosis == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(diagnosis);
    }

    @PostMapping("/dosage-calc")
    public ResponseEntity<Map<String, Object>> calculateDosage(@RequestBody Map<String, Object> request) {
        double landAmount = Double.parseDouble(request.getOrDefault("landAmount", "1.0").toString());
        boolean isAcres = Boolean.parseBoolean(request.getOrDefault("isAcres", "true").toString());
        double perchGrams = Double.parseDouble(request.getOrDefault("perchGrams", "15.0").toString());

        // 1 Acre = 160 Perches in Sri Lanka
        double totalPerches = isAcres ? landAmount * 160.0 : landAmount;
        double totalGramsOrMl = totalPerches * perchGrams;
        double sprayTanks16L = Math.max(1.0, totalPerches * 0.5);

        String productLabel = totalGramsOrMl >= 1000
                ? String.format("%.2f kg / Liters", totalGramsOrMl / 1000.0)
                : String.format("%.0f g / ml", totalGramsOrMl);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("landSummary", isAcres ? String.format("%.1f Acres (%.0f Perches)", landAmount, totalPerches) : String.format("%.0f Perches", landAmount));
        response.put("totalProduct", productLabel);
        response.put("waterVolumeLiters", Math.round(sprayTanks16L * 16.0));
        response.put("sprayTanks", String.format("%.1f Knapsack Tanks (16L)", sprayTanks16L));

        return ResponseEntity.ok(response);
    }
}
