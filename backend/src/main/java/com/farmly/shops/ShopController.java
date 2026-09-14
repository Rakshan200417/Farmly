package com.farmly.shops;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/shops")
@CrossOrigin(origins = "*")
public class ShopController {

    private final ShopRepository shopRepository;

    public ShopController(ShopRepository shopRepository) {
        this.shopRepository = shopRepository;
    }

    @GetMapping
    public ResponseEntity<List<Shop>> getAllShops() {
        return ResponseEntity.ok(shopRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Shop> getShopById(@PathVariable String id) {
        return shopRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/nearby")
    public ResponseEntity<List<Map<String, Object>>> getNearbyShops(
            @RequestParam(defaultValue = "8.3114") Double lat,
            @RequestParam(defaultValue = "80.4037") Double lng,
            @RequestParam(defaultValue = "50.0") Double radiusKm,
            @RequestParam(required = false) String product) {

        List<Shop> allShops = shopRepository.findByIsVerifiedTrue();

        List<Map<String, Object>> results = allShops.stream().map(shop -> {
            double dist = calculateDistanceKm(lat, lng, shop.getLatitude(), shop.getLongitude());
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", shop.getId());
            map.put("name", shop.getName());
            map.put("address", shop.getAddress());
            map.put("phone", shop.getPhone());
            map.put("rating", shop.getRating());
            map.put("reviewsCount", shop.getReviewsCount());
            map.put("latitude", shop.getLatitude());
            map.put("longitude", shop.getLongitude());
            map.put("tags", shop.getTags());
            map.put("distanceKm", Math.round(dist * 10.0) / 10.0);
            map.put("productsCount", shop.getProducts().size());
            return map;
        })
        .filter(m -> ((Double) m.get("distanceKm")) <= radiusKm)
        .sorted(Comparator.comparingDouble(m -> (Double) m.get("distanceKm")))
        .collect(Collectors.toList());

        return ResponseEntity.ok(results);
    }

    // Haversine formula for exact distance in kilometers
    private double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Earth radius in km
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}
