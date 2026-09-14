package com.farmly.diagnosis;

import jakarta.persistence.*;

@Entity
@Table(name = "disease_treatment_mappings")
public class DiseaseTreatmentMapping {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String cropName;

    @Column(nullable = false)
    private String diseaseName;

    private String scientificName;

    private String severity = "SEVERE"; // MILD, MODERATE, SEVERE

    private Double confidencePercent = 87.0;

    private String warningBanner;

    @Column(length = 1000)
    private String description;

    @Column(length = 1000)
    private String organicTreatment;

    @Column(length = 1000)
    private String chemicalTreatment;

    private Double standardPerchGrams = 15.0;

    public DiseaseTreatmentMapping() {}

    public DiseaseTreatmentMapping(String cropName, String diseaseName, String scientificName, String severity, Double confidencePercent, String warningBanner, String description, String organicTreatment, String chemicalTreatment, Double standardPerchGrams) {
        this.cropName = cropName;
        this.diseaseName = diseaseName;
        this.scientificName = scientificName;
        this.severity = severity;
        this.confidencePercent = confidencePercent;
        this.warningBanner = warningBanner;
        this.description = description;
        this.organicTreatment = organicTreatment;
        this.chemicalTreatment = chemicalTreatment;
        this.standardPerchGrams = standardPerchGrams;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }

    public String getDiseaseName() { return diseaseName; }
    public void setDiseaseName(String diseaseName) { this.diseaseName = diseaseName; }

    public String getScientificName() { return scientificName; }
    public void setScientificName(String scientificName) { this.scientificName = scientificName; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public Double getConfidencePercent() { return confidencePercent; }
    public void setConfidencePercent(Double confidencePercent) { this.confidencePercent = confidencePercent; }

    public String getWarningBanner() { return warningBanner; }
    public void setWarningBanner(String warningBanner) { this.warningBanner = warningBanner; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getOrganicTreatment() { return organicTreatment; }
    public void setOrganicTreatment(String organicTreatment) { this.organicTreatment = organicTreatment; }

    public String getChemicalTreatment() { return chemicalTreatment; }
    public void setChemicalTreatment(String chemicalTreatment) { this.chemicalTreatment = chemicalTreatment; }

    public Double getStandardPerchGrams() { return standardPerchGrams; }
    public void setStandardPerchGrams(Double standardPerchGrams) { this.standardPerchGrams = standardPerchGrams; }
}
