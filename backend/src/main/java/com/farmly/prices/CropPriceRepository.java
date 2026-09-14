package com.farmly.prices;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CropPriceRepository extends JpaRepository<CropPrice, String> {
    List<CropPrice> findByCategoryIgnoreCase(String category);
    List<CropPrice> findByCropNameContainingIgnoreCase(String cropName);
}
