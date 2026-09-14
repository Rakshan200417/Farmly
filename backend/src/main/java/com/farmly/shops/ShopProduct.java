package com.farmly.shops;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "shop_products")
public class ShopProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shop_id", nullable = false)
    @JsonIgnore
    private Shop shop;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String category; // Organic, Chemical, Equipment, Seeds

    @Column(nullable = false)
    private Double price;

    private String unit = "500ml bottle";

    private String stockStatus = "in_stock"; // in_stock, low_stock, out_of_stock

    private String activeIngredient;

    public ShopProduct() {}

    public ShopProduct(Shop shop, String name, String category, Double price, String unit, String stockStatus, String activeIngredient) {
        this.shop = shop;
        this.name = name;
        this.category = category;
        this.price = price;
        this.unit = unit;
        this.stockStatus = stockStatus;
        this.activeIngredient = activeIngredient;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public Shop getShop() { return shop; }
    public void setShop(Shop shop) { this.shop = shop; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getStockStatus() { return stockStatus; }
    public void setStockStatus(String stockStatus) { this.stockStatus = stockStatus; }

    public String getActiveIngredient() { return activeIngredient; }
    public void setActiveIngredient(String activeIngredient) { this.activeIngredient = activeIngredient; }
}
