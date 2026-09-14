package com.farmly.prices;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/prices")
@CrossOrigin(origins = "*")
public class MarketPriceController {

    private final CropPriceRepository cropPriceRepository;

    public MarketPriceController(CropPriceRepository cropPriceRepository) {
        this.cropPriceRepository = cropPriceRepository;
    }

    @GetMapping
    public ResponseEntity<List<CropPrice>> getAllPrices(@RequestParam(required = false) String category) {
        if (category != null && !category.equalsIgnoreCase("All")) {
            return ResponseEntity.ok(cropPriceRepository.findByCategoryIgnoreCase(category));
        }
        return ResponseEntity.ok(cropPriceRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<CropPrice> getPriceById(@PathVariable String id) {
        return cropPriceRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/bulletin-import")
    public ResponseEntity<?> importDailyBulletin(@RequestBody List<CropPrice> bulletinPrices) {
        bulletinPrices.forEach(p -> p.setRecordedAt(LocalDateTime.now()));
        List<CropPrice> saved = cropPriceRepository.saveAll(bulletinPrices);
        return ResponseEntity.ok(Map.of("message", "Daily bulletin imported and published successfully", "count", saved.size()));
    }
}
