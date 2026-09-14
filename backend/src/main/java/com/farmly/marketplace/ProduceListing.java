package com.farmly.marketplace;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "produce_listings")
public class ProduceListing {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String farmerId;

    @Column(nullable = false)
    private String farmerName;

    @Column(nullable = false)
    private String farmerPhone;

    @Column(nullable = false)
    private String cropName;

    private String variety;

    private String category;

    @Column(nullable = false)
    private Double pricePerKg;

    @Column(nullable = false)
    private Double availableQty;

    private Double minOrderQty = 1.0;

    private String unit = "kg";

    private String qualityGrade = "Grade A";

    private String harvestDate;

    private String location;

    private Double latitude;

    private Double longitude;

    private String imageUrl;

    @Column(length = 1000)
    private String description;

    private String status = "ACTIVE"; // ACTIVE, SOLD, DRAFT

    private LocalDateTime createdAt = LocalDateTime.now();

    public ProduceListing() {}

    public ProduceListing(String farmerName, String farmerPhone, String cropName, String variety, String category, Double pricePerKg, Double availableQty, String qualityGrade, String harvestDate, String location, Double latitude, Double longitude, String imageUrl, String description) {
        this.farmerName = farmerName;
        this.farmerPhone = farmerPhone;
        this.cropName = cropName;
        this.variety = variety;
        this.category = category;
        this.pricePerKg = pricePerKg;
        this.availableQty = availableQty;
        this.qualityGrade = qualityGrade;
        this.harvestDate = harvestDate;
        this.location = location;
        this.latitude = latitude;
        this.longitude = longitude;
        this.imageUrl = imageUrl;
        this.description = description;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getFarmerId() { return farmerId; }
    public void setFarmerId(String farmerId) { this.farmerId = farmerId; }

    public String getFarmerName() { return farmerName; }
    public void setFarmerName(String farmerName) { this.farmerName = farmerName; }

    public String getFarmerPhone() { return farmerPhone; }
    public void setFarmerPhone(String farmerPhone) { this.farmerPhone = farmerPhone; }

    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }

    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Double getPricePerKg() { return pricePerKg; }
    public void setPricePerKg(Double pricePerKg) { this.pricePerKg = pricePerKg; }

    public Double getAvailableQty() { return availableQty; }
    public void setAvailableQty(Double availableQty) { this.availableQty = availableQty; }

    public Double getMinOrderQty() { return minOrderQty; }
    public void setMinOrderQty(Double minOrderQty) { this.minOrderQty = minOrderQty; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }

    public String getHarvestDate() { return harvestDate; }
    public void setHarvestDate(String harvestDate) { this.harvestDate = harvestDate; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
