package com.farmly.diagnosis;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface DiseaseRepository extends JpaRepository<DiseaseTreatmentMapping, String> {
    Optional<DiseaseTreatmentMapping> findByCropNameIgnoreCase(String cropName);
    Optional<DiseaseTreatmentMapping> findByDiseaseNameIgnoreCase(String diseaseName);
}
