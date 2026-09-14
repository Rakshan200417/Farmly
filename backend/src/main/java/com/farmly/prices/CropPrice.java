package com.farmly.prices;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "crop_prices")
public class CropPrice {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String cropName;

    @Column(nullable = false)
    private String category; // Grains, Vegetables, Spices, Fruits

    @Column(nullable = false)
    private String marketName;

    @Column(nullable = false)
    private Double pricePerKg;

    private Double changePercent = 0.0;

    private Boolean isPositive = true;

    private String historicalTrend; // Comma separated prices

    private String source = "HARTI Sri Lanka Daily Bulletin";

    private LocalDateTime recordedAt = LocalDateTime.now();

    public CropPrice() {}

    public CropPrice(String cropName, String category, String marketName, Double pricePerKg, Double changePercent, Boolean isPositive, String historicalTrend) {
        this.cropName = cropName;
        this.category = category;
        this.marketName = marketName;
        this.pricePerKg = pricePerKg;
        this.changePercent = changePercent;
        this.isPositive = isPositive;
        this.historicalTrend = historicalTrend;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getMarketName() { return marketName; }
    public void setMarketName(String marketName) { this.marketName = marketName; }

    public Double getPricePerKg() { return pricePerKg; }
    public void setPricePerKg(Double pricePerKg) { this.pricePerKg = pricePerKg; }

    public Double getChangePercent() { return changePercent; }
    public void setChangePercent(Double changePercent) { this.changePercent = changePercent; }

    public Boolean getIsPositive() { return isPositive; }
    public void setIsPositive(Boolean positive) { isPositive = positive; }

    public String getHistoricalTrend() { return historicalTrend; }
    public void setHistoricalTrend(String historicalTrend) { this.historicalTrend = historicalTrend; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public LocalDateTime getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDateTime recordedAt) { this.recordedAt = recordedAt; }
}
