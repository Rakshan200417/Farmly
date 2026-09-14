-- ====================================================================
-- FARMLY DATABASE SCHEMA & SEED DATA (PostgreSQL + PostGIS)
-- Sri Lanka Mobile-First Agriculture Ecosystem
-- ====================================================================

-- 1. Enable PostGIS Extension (if running on PostgreSQL)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Drop existing tables if re-initializing
DROP TABLE IF EXISTS shop_products CASCADE;
DROP TABLE IF EXISTS shops CASCADE;
DROP TABLE IF EXISTS produce_listings CASCADE;
DROP TABLE IF EXISTS crop_prices CASCADE;
DROP TABLE IF EXISTS disease_treatment_mappings CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- --------------------------------------------------------------------
-- TABLE: USERS (Farmers, Buyers, Shops, Admins)
-- --------------------------------------------------------------------
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    role VARCHAR(30) NOT NULL, -- FARMER, BUYER, SHOP, MARKET_ADMIN, ADMIN
    district VARCHAR(100),
    location_name VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    rating DOUBLE PRECISION DEFAULT 4.8,
    reviews_count INT DEFAULT 112,
    is_verified BOOLEAN DEFAULT TRUE,
    is_demo_user BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- TABLE: CROP_PRICES (Real-Time & Historical Wholesale Rates)
-- --------------------------------------------------------------------
CREATE TABLE crop_prices (
    id VARCHAR(36) PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- Grains, Vegetables, Spices, Fruits
    market_name VARCHAR(150) NOT NULL,
    price_per_kg DOUBLE PRECISION NOT NULL,
    change_percent DOUBLE PRECISION DEFAULT 0.0,
    is_positive BOOLEAN DEFAULT TRUE,
    historical_trend TEXT, -- Comma separated 7-day values for charts
    source VARCHAR(100) DEFAULT 'HARTI Sri Lanka Daily Bulletin',
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- TABLE: PRODUCE_LISTINGS (Farmer Marketplace)
-- --------------------------------------------------------------------
CREATE TABLE produce_listings (
    id VARCHAR(36) PRIMARY KEY,
    farmer_id VARCHAR(36),
    farmer_name VARCHAR(150) NOT NULL,
    farmer_phone VARCHAR(30) NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    variety VARCHAR(100),
    category VARCHAR(50),
    price_per_kg DOUBLE PRECISION NOT NULL,
    available_qty DOUBLE PRECISION NOT NULL,
    min_order_qty DOUBLE PRECISION DEFAULT 1.0,
    unit VARCHAR(20) DEFAULT 'kg',
    quality_grade VARCHAR(50) DEFAULT 'Grade A',
    harvest_date VARCHAR(50),
    location VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    image_url TEXT,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, SOLD, DRAFT
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------
-- TABLE: SHOPS (Agro-Input Suppliers)
-- --------------------------------------------------------------------
CREATE TABLE shops (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    phone VARCHAR(30),
    rating DOUBLE PRECISION DEFAULT 4.8,
    reviews_count INT DEFAULT 142,
    is_verified BOOLEAN DEFAULT TRUE,
    tags VARCHAR(255) -- Seeds, Organic, Tools, Fertilizer
);

-- --------------------------------------------------------------------
-- TABLE: SHOP_PRODUCTS (Inventory & Stock Availability)
-- --------------------------------------------------------------------
CREATE TABLE shop_products (
    id VARCHAR(36) PRIMARY KEY,
    shop_id VARCHAR(36) NOT NULL REFERENCES shops(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL, -- Organic, Chemical, Equipment, Seeds
    price DOUBLE PRECISION NOT NULL,
    unit VARCHAR(50) DEFAULT '500ml bottle',
    stock_status VARCHAR(30) DEFAULT 'in_stock', -- in_stock, low_stock, out_of_stock
    active_ingredient VARCHAR(150)
);

-- --------------------------------------------------------------------
-- TABLE: DISEASE_TREATMENT_MAPPINGS (Plant Pathology Knowledge Base)
-- --------------------------------------------------------------------
CREATE TABLE disease_treatment_mappings (
    id VARCHAR(36) PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    disease_name VARCHAR(150) NOT NULL,
    scientific_name VARCHAR(150),
    severity VARCHAR(20) DEFAULT 'SEVERE', -- MILD, MODERATE, SEVERE
    confidence_percent DOUBLE PRECISION DEFAULT 87.0,
    warning_banner VARCHAR(255),
    description TEXT,
    organic_treatment TEXT,
    chemical_treatment TEXT,
    standard_perch_grams DOUBLE PRECISION DEFAULT 15.0
);

-- ====================================================================
-- SEED DATA (Sri Lanka Agricultural Context)
-- ====================================================================

-- 1. Demo Users (Examiner / Viva Testing)
INSERT INTO users (id, name, phone, role, district, location_name, latitude, longitude, rating, reviews_count, is_verified, is_demo_user)
VALUES
('usr-01', 'Suneth Perera', '+94 77 123 4567', 'FARMER', 'Anuradhapura', 'Thirappane, Anuradhapura', 8.3114, 80.4037, 4.8, 112, TRUE, TRUE),
('usr-02', 'Priyashantha Wholesale', '+94 71 987 6543', 'BUYER', 'Colombo', 'Pettah Wholesale Market, Colombo', 6.9360, 79.8530, 4.9, 88, TRUE, TRUE),
('usr-03', 'Perera Agri Inputs & Seeds', '+94 76 555 1234', 'SHOP', 'Matale', 'Dambulla Road, Dambulla', 7.8731, 80.6511, 4.8, 142, TRUE, TRUE),
('usr-04', 'Platform Admin', '+94 70 000 0000', 'ADMIN', 'Colombo', 'Headquarters, Colombo', 6.9271, 79.8612, 5.0, 10, TRUE, TRUE);

-- 2. Daily Market Prices (HARTI Wholesale Benchmarks)
INSERT INTO crop_prices (id, crop_name, category, market_name, price_per_kg, change_percent, is_positive, historical_trend, source)
VALUES
('price-01', 'Paddy (Rice)', 'Grains', 'Dambulla Dedicated Economic Centre', 110.0, 5.0, TRUE, '98,102,100,104,106,108,110', 'HARTI Sri Lanka Daily Bulletin'),
('price-02', 'Red Onion', 'Vegetables', 'Dambulla Dedicated Economic Centre', 240.0, -2.0, FALSE, '255,250,248,252,246,243,240', 'HARTI Sri Lanka Daily Bulletin'),
('price-03', 'Big Onion', 'Vegetables', 'Dambulla Dedicated Economic Centre', 185.0, 1.0, TRUE, '180,182,181,184,183,184,185', 'HARTI Sri Lanka Daily Bulletin'),
('price-04', 'Tomato', 'Vegetables', 'Dambulla Dedicated Economic Centre', 320.0, 12.0, TRUE, '280,290,285,305,310,315,320', 'HARTI Sri Lanka Daily Bulletin'),
('price-05', 'Green Chili', 'Spices', 'Dambulla Dedicated Economic Centre', 650.0, -4.0, FALSE, '690,680,675,670,665,655,650', 'HARTI Sri Lanka Daily Bulletin'),
('price-06', 'Carrot (Nuwara Eliya)', 'Vegetables', 'Keppetipola Economic Centre', 450.0, 8.0, TRUE, '390,410,405,420,435,440,450', 'HARTI Sri Lanka Daily Bulletin'),
('price-07', 'Long Beans', 'Vegetables', 'Meegoda Dedicated Economic Centre', 180.0, -1.5, FALSE, '195,190,188,185,182,180,180', 'HARTI Sri Lanka Daily Bulletin');

-- 3. Produce Listings
INSERT INTO produce_listings (id, farmer_id, farmer_name, farmer_phone, crop_name, variety, category, price_per_kg, available_qty, min_order_qty, unit, quality_grade, harvest_date, location, latitude, longitude, image_url, description, status)
VALUES
('list-01', 'usr-01', 'Suneth P.', '+94771234567', 'Roma Tomatoes', 'Roma Organic', 'Vegetables', 450.0, 50.0, 5.0, 'kg', 'Grade A • Organic', 'Oct 12, 2026', 'Dambulla, Central Province', 7.8731, 80.6511, 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600', 'Hand-picked organic Roma tomatoes grown in rich red soil. No synthetic pesticides used.', 'ACTIVE'),
('list-02', 'usr-01', 'Malini D.', '+94712345678', 'Green Chilies', 'Kochchi Variety', 'Spices', 850.0, 15.0, 1.0, 'kg', 'Grade A', 'Oct 14, 2026', 'Galewela, Matale', 7.8500, 80.6200, 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600', 'Extremely fresh and pungent native Kochchi green chilies, harvested early morning.', 'ACTIVE'),
('list-03', 'usr-01', 'Kamal W.', '+94761234567', 'Long Beans', 'Polonnaruwa Green', 'Vegetables', 180.0, 120.0, 10.0, 'kg', 'Standard Quality', 'Oct 13, 2026', 'Polonnaruwa', 7.9403, 81.0188, 'https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=600', 'Crisp green long beans perfect for wholesale distribution.', 'ACTIVE'),
('list-04', 'usr-01', 'Sunil Perera', '+94779876543', 'Premium Organic Carrots', 'Nantes', 'Vegetables', 450.0, 500.0, 25.0, 'kg', 'Grade A • Organic Certified', 'Oct 24, 2026', 'Nuwara Eliya, Central Province', 6.9497, 80.7891, 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600', 'High-quality, organically grown Nantes carrots from the cool climates of Nuwara Eliya. Washed and ready for transport.', 'ACTIVE');

-- 4. Shops
INSERT INTO shops (id, name, address, latitude, longitude, phone, rating, reviews_count, is_verified, tags)
VALUES
('shop-01', 'Perera Agri Inputs & Seeds', 'No. 45, Dambulla Market Rd, Dambulla', 7.8731, 80.6511, '+94765551234', 4.8, 142, TRUE, 'Seeds, Organic, Tools, Fertilizer'),
('shop-02', 'Govi Setha Agricultural Center', 'Kurunegala Junction, Galewela', 7.8500, 80.6200, '+94772223344', 4.6, 88, TRUE, 'Organic, Pesticides, Chemical'),
('shop-03', 'Lanka Agro Chemicals & Equipment', 'Main St, Kekirawa', 7.9100, 80.5900, '+94714445566', 4.4, 62, TRUE, 'Chemical, Equipment');

-- 5. Shop Products (Treatment stock)
INSERT INTO shop_products (id, shop_id, name, category, price, unit, stock_status, active_ingredient)
VALUES
('prod-01', 'shop-01', 'Neem Oil Extract (500ml)', 'Organic', 950.0, '500ml bottle', 'in_stock', 'Azadirachtin'),
('prod-02', 'shop-01', 'Copper Oxychloride 50 WP', 'Chemical', 1400.0, '500g pack', 'in_stock', 'Copper Oxychloride'),
('prod-03', 'shop-01', 'Bio-Compost Grade A', 'Organic', 450.0, '20kg bag', 'in_stock', 'Organic Matter'),
('prod-04', 'shop-01', 'Knapsack Sprayer 16L', 'Equipment', 6500.0, '1 unit', 'low_stock', 'Manual Pump'),
('prod-05', 'shop-02', 'Streptomycin Sulphate 90%', 'Chemical', 1850.0, '100g pack', 'in_stock', 'Streptomycin'),
('prod-06', 'shop-02', 'Trichoderma Bio-Fungicide', 'Organic', 850.0, '1kg bag', 'in_stock', 'Trichoderma viride');

-- 6. Disease Treatment Mappings
INSERT INTO disease_treatment_mappings (id, crop_name, disease_name, scientific_name, severity, confidence_percent, warning_banner, description, organic_treatment, chemical_treatment, standard_perch_grams)
VALUES
('diag-01', 'Paddy (Rice)', 'Bacterial Leaf Blight', 'Xanthomonas oryzae pv. oryzae', 'SEVERE', 87.0, 'High incidence of Blight reported in your area.', 'Identified based on water-soaked to yellowish stripes on leaf blades or starting at leaf tips with a wavy margin.', 'Neem Oil Extract (5ml/L) applied early morning; Copper Hydroxide (organic approved).', 'Streptomycin Sulphate + Tetracycline (1.5g per 10L); Copper Oxychloride (2.5g per 1L).', 15.0),
('diag-02', 'Tomato', 'Early Blight', 'Alternaria solani', 'MODERATE', 91.0, 'Moderate fungal incidence reported in dry-intermediate zone.', 'Concentric dark brown rings on older lower leaves, often surrounded by a yellow halo.', 'Baking soda spray (5g/L) + horticultural oil; Trichoderma root drench.', 'Mancozeb 75 WP (2g/L) or Chlorothalonil.', 12.0),
('diag-03', 'Green Chili', 'Chili Leaf Curl Virus', 'Begomovirus', 'SEVERE', 85.0, 'High whitefly and thrips activity reported.', 'Upward curling and puckering of leaves with stunted plant growth and reduced fruit set.', 'Yellow sticky traps (12 per acre) + Neem oil soap spray (5ml/L).', 'Imidacloprid 200 SL (0.5ml/L) to control vector insects.', 8.0);
