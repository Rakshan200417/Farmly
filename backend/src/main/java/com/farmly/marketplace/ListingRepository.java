package com.farmly.marketplace;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ListingRepository extends JpaRepository<ProduceListing, String> {
    List<ProduceListing> findByStatusOrderByCreatedAtDesc(String status);
    List<ProduceListing> findByFarmerId(String farmerId);
    List<ProduceListing> findByCategoryIgnoreCase(String category);
    List<ProduceListing> findByCropNameContainingIgnoreCase(String cropName);
}
