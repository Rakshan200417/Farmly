package com.farmly.marketplace;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/listings")
@CrossOrigin(origins = "*")
public class ListingController {

    private final ListingRepository listingRepository;

    public ListingController(ListingRepository listingRepository) {
        this.listingRepository = listingRepository;
    }

    @GetMapping
    public ResponseEntity<List<ProduceListing>> getAllListings(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String query) {

        if (category != null && !category.equalsIgnoreCase("All")) {
            return ResponseEntity.ok(listingRepository.findByCategoryIgnoreCase(category));
        }

        if (query != null && !query.trim().isEmpty()) {
            return ResponseEntity.ok(listingRepository.findByCropNameContainingIgnoreCase(query.trim()));
        }

        return ResponseEntity.ok(listingRepository.findByStatusOrderByCreatedAtDesc("ACTIVE"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProduceListing> getListingById(@PathVariable String id) {
        return listingRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProduceListing> createListing(@RequestBody ProduceListing listing) {
        ProduceListing saved = listingRepository.save(listing);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProduceListing> updateListing(@PathVariable String id, @RequestBody ProduceListing updated) {
        return listingRepository.findById(id).map(existing -> {
            existing.setCropName(updated.getCropName());
            existing.setVariety(updated.getVariety());
            existing.setPricePerKg(updated.getPricePerKg());
            existing.setAvailableQty(updated.getAvailableQty());
            existing.setMinOrderQty(updated.getMinOrderQty());
            existing.setStatus(updated.getStatus());
            existing.setDescription(updated.getDescription());
            return ResponseEntity.ok(listingRepository.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteListing(@PathVariable String id) {
        if (listingRepository.existsById(id)) {
            listingRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
