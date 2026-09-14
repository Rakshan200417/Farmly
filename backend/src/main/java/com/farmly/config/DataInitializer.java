package com.farmly.config;

import com.farmly.users.User;
import com.farmly.users.UserRepository;
import com.farmly.users.UserRole;
import com.farmly.prices.CropPrice;
import com.farmly.prices.CropPriceRepository;
import com.farmly.marketplace.ProduceListing;
import com.farmly.marketplace.ListingRepository;
import com.farmly.shops.Shop;
import com.farmly.shops.ShopProduct;
import com.farmly.shops.ShopRepository;
import com.farmly.diagnosis.DiseaseTreatmentMapping;
import com.farmly.diagnosis.DiseaseRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final CropPriceRepository cropPriceRepository;
    private final ListingRepository listingRepository;
    private final ShopRepository shopRepository;
    private final DiseaseRepository diseaseRepository;

    public DataInitializer(
            UserRepository userRepository,
            CropPriceRepository cropPriceRepository,
            ListingRepository listingRepository,
            ShopRepository shopRepository,
            DiseaseRepository diseaseRepository) {
        this.userRepository = userRepository;
        this.cropPriceRepository = cropPriceRepository;
        this.listingRepository = listingRepository;
        this.shopRepository = shopRepository;
        this.diseaseRepository = diseaseRepository;
    }

    @Override
    public void run(String... args) {
        if (userRepository.count() > 0) return;

        // 1. Seed Demo Personas (for Viva / Grading)
        User suneth = new User("Suneth Perera", "+94 77 123 4567", UserRole.FARMER, "Anuradhapura", "Thirappane, Anuradhapura", 8.3114, 80.4037);
        suneth.setIsDemoUser(true);
        User priyashantha = new User("Priyashantha Wholesale", "+94 71 987 6543", UserRole.BUYER, "Colombo", "Pettah Wholesale Market, Colombo", 6.9360, 79.8530);
        priyashantha.setIsDemoUser(true);
        User pereraShop = new User("Perera Agri Inputs & Seeds", "+94 76 555 1234", UserRole.SHOP, "Matale", "Dambulla Road, Dambulla", 7.8731, 80.6511);
        pereraShop.setIsDemoUser(true);
        User admin = new User("Platform Admin", "+94 70 000 0000", UserRole.ADMIN, "Colombo", "Headquarters, Colombo", 6.9271, 79.8612);
        admin.setIsDemoUser(true);
        userRepository.saveAll(List.of(suneth, priyashantha, pereraShop, admin));

        // 2. Seed Live Market Prices (HARTI Sri Lanka)
        CropPrice paddy = new CropPrice("Paddy (Rice)", "Grains", "Dambulla Economic Centre", 110.0, 5.0, true, "98,102,100,104,106,108,110");
        CropPrice redOnion = new CropPrice("Red Onion", "Vegetables", "Dambulla Economic Centre", 240.0, -2.0, false, "255,250,248,252,246,243,240");
        CropPrice bigOnion = new CropPrice("Big Onion", "Vegetables", "Dambulla Economic Centre", 185.0, 1.0, true, "180,182,181,184,183,184,185");
        CropPrice tomato = new CropPrice("Tomato", "Vegetables", "Dambulla Economic Centre", 320.0, 12.0, true, "280,290,285,305,310,315,320");
        CropPrice chili = new CropPrice("Green Chili", "Spices", "Dambulla Economic Centre", 650.0, -4.0, false, "690,680,675,670,665,655,650");
        cropPriceRepository.saveAll(List.of(paddy, redOnion, bigOnion, tomato, chili));

        // 3. Seed Produce Listings
        ProduceListing l1 = new ProduceListing("Suneth P.", "+94771234567", "Roma Tomatoes", "Roma Organic", "Vegetables", 450.0, 50.0, "Grade A • Organic", "Oct 12, 2026", "Dambulla, Central Province", 7.8731, 80.6511, "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600", "Hand-picked organic Roma tomatoes grown in rich red soil.");
        ProduceListing l2 = new ProduceListing("Malini D.", "+94712345678", "Green Chilies", "Kochchi Variety", "Spices", 850.0, 15.0, "Grade A", "Oct 14, 2026", "Galewela, Matale", 7.8500, 80.6200, "https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600", "Pungent native Kochchi green chilies harvested early morning.");
        ProduceListing l3 = new ProduceListing("Kamal W.", "+94761234567", "Long Beans", "Polonnaruwa Green", "Vegetables", 180.0, 120.0, "Standard Quality", "Oct 13, 2026", "Polonnaruwa", 7.9403, 81.0188, "https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=600", "Crisp green long beans perfect for wholesale distribution.");
        ProduceListing l4 = new ProduceListing("Sunil Perera", "+94779876543", "Premium Organic Carrots", "Nantes", "Vegetables", 450.0, 500.0, "Grade A • Organic Certified", "Oct 24, 2026", "Nuwara Eliya, Central Province", 6.9497, 80.7891, "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600", "Organically grown Nantes carrots from the cool climates of Nuwara Eliya. Washed and ready for transport.");
        listingRepository.saveAll(List.of(l1, l2, l3, l4));

        // 4. Seed Agro Shops and Inventory
        Shop shop1 = new Shop("Perera Agri Inputs & Seeds", "No. 45, Dambulla Market Rd, Dambulla", 7.8731, 80.6511, "+94765551234", "Seeds, Organic, Tools, Fertilizer");
        Shop shop2 = new Shop("Govi Setha Agricultural Center", "Kurunegala Junction, Galewela", 7.8500, 80.6200, "+94772223344", "Organic, Pesticides, Chemical");
        Shop shop3 = new Shop("Lanka Agro Chemicals & Equipment", "Main St, Kekirawa", 7.9100, 80.5900, "+94714445566", "Chemical, Equipment");
        shopRepository.saveAll(List.of(shop1, shop2, shop3));

        ShopProduct p1 = new ShopProduct(shop1, "Neem Oil Extract (500ml)", "Organic", 950.0, "500ml bottle", "in_stock", "Azadirachtin");
        ShopProduct p2 = new ShopProduct(shop1, "Copper Oxychloride 50 WP", "Chemical", 1400.0, "500g pack", "in_stock", "Copper Oxychloride");
        ShopProduct p3 = new ShopProduct(shop1, "Bio-Compost Grade A", "Organic", 450.0, "20kg bag", "in_stock", "Organic matter");
        shop1.getProducts().addAll(List.of(p1, p2, p3));
        shopRepository.save(shop1);

        // 5. Seed Crop Disease Knowledge
        DiseaseTreatmentMapping blight = new DiseaseTreatmentMapping(
                "Paddy (Rice)",
                "Bacterial Leaf Blight",
                "Xanthomonas oryzae pv. oryzae",
                "SEVERE",
                87.0,
                "High incidence of Blight reported in your area.",
                "Identified based on water-soaked to yellowish stripes on leaf blades or starting at leaf tips with a wavy margin.",
                "1. Neem Oil Extract (5ml per 1 Liter)\n2. Copper Hydroxide (Follow local organic concentration)",
                "1. Streptomycin Sulphate + Tetracycline (1.5g per 10 Liters)\n2. Copper Oxychloride (2.5g per 1 Liter)",
                15.0
        );
        diseaseRepository.save(blight);

        System.out.println(">>> Farmly Sri Lankan seed data successfully initialized in database!");
    }
}
