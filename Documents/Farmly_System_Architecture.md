# Farmly — System Architecture & Database Design

## 1. High-Level Architecture

```
                       ┌─────────────────────────┐
                       │       Mobile App        │
                       │    (Flutter, Android)   │
                       │  Farmer / Buyer / Shop  │
                       └────────────┬────────────┘
                                    │ REST (HTTPS)
                                    ▼
                       ┌─────────────────────────┐
                       │      Backend API        │
                       │     (Spring Boot)       │
                       └──┬─────────┬─────────┬──┘
                          │         │         │
              ┌───────────┘         │         └───────────┐
              ▼                     ▼                     ▼
    ┌──────────────────┐  ┌──────────────────┐  ┌────────────────────┐
    │ PostgreSQL +     │  │ Firebase         │  │ AI Services        │
    │ PostGIS          │  │ (Auth + Demo     │  │ 1. FastAPI Fallback│
    │ (Relational &    │  │  Bypass, Chat,   │  │    (Disease Vision)│
    │  Geospatial)     │  │  FCM, Storage)   │  │ 2. Google Gemini   │
    └──────────────────┘  └──────────────────┘  │    1.5 Flash (LLM) │
                                                └────────────────────┘
                       ┌─────────────────────────┐
                       │    Admin Dashboard      │
                       │  (React + TypeScript)   │
                       └────────────┬────────────┘
                                    │ REST (role-gated)
                                    └──────────► Backend API
```

## 2. Component Responsibilities

- **Mobile App (Flutter):** Provides role-specific views (Farmer, Buyer, Shop); captures images and executes on-device TensorFlow Lite classification; renders conversational AI interface with Sinhala/Tamil/English localization; queries nearby entities using device GPS.
- **Backend API (Spring Boot):** The single source of truth and orchestration layer. Exposes REST endpoints for users, listings, prices, shops, and ratings; securely communicates with Google Gemini API using server-side API keys; executes PostGIS spatial queries.
- **PostgreSQL + PostGIS:** Relational storage for all profiles, listings, market price histories, and disease mappings. PostGIS handles spatial queries (`ST_DWithin`, `ST_Distance`) for finding nearby shops and produce listings.
- **AI Services:**
  1. *Edge Vision:* TFLite running directly on the Android device for instant, zero-cost classification.
  2. *Cloud Vision Fallback:* Python FastAPI service running a heavier deep learning model when on-device confidence is below 70%.
  3. *Generative AI Assistant:* Google Gemini 1.5 Flash API invoked server-side for natural language farming advice, disease follow-ups, and dosage calculations.
- **Firebase:** Manages phone OTP verification, live Firestore messages between users, Firebase Cloud Messaging (FCM) for push notifications, and image cloud storage.
- **Admin Dashboard (React + TypeScript):** Web-based portal for platform oversight: user verification, listing moderation, bulletin price approval, disease-treatment mapping, and regional announcement broadcasting.

## 3. Database Schema (Core Entities)

### users
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| phone_number | varchar | Unique, used for OTP login |
| role | enum | farmer / buyer / shop / market_admin / admin |
| name | varchar | Full name |
| profile_photo_url | varchar | Firebase storage URL |
| location | geography(point, 4326) | PostGIS spatial point (lon, lat) |
| district | varchar | Anuradhapura, Kandy, Colombo, etc. |
| language_preference | varchar | si / ta / en |
| verified | boolean | Admin verification flag |
| is_demo_user | boolean | Marker for viva demo accounts |
| rating_avg | decimal | Computed aggregate (1.00 - 5.00) |
| rating_count | int | Total ratings received |
| created_at | timestamp | |

### listings (Produce Marketplace)
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| farmer_id | UUID | FK → users.id |
| crop_type | varchar | Paddy, Chili, Tomato, etc. |
| variety | varchar | Samba, Keeri Samba, MI-2, etc. |
| quantity | decimal | Amount available |
| unit | varchar | kg / 50kg_bag / tons |
| quality_grade | enum | premium / standard / economy |
| price_expectation | decimal | Price per unit (LKR) |
| harvest_date | date | Expected / harvested date |
| location | geography(point, 4326) | PostGIS location of produce |
| status | enum | active / sold / draft / pending |
| photos | text[] | Image URLs |
| created_at | timestamp | |

### shop_products & inventory
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| shop_id | UUID | FK → users.id |
| product_name | varchar | Neem Oil, Mancozeb, Compost, etc. |
| category | enum | organic / chemical |
| unit_price | decimal | Price in LKR |
| unit_measurement | varchar | 500ml / 1kg / 5L |
| stock_status | enum | in_stock / low_stock / out_of_stock |
| active_ingredient | varchar | Linked to treatment mapping |

### disease_treatment_mapping
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| crop_type | varchar | Paddy, Chili, Tomato, etc. |
| disease_name | varchar | Blast, Leaf Curl, Early Blight, etc. |
| scientific_name | varchar | Magnaporthe oryzae, etc. |
| description | text | Symptoms and identification guide |
| severity | enum | mild / moderate / severe |
| organic_treatment | text | Step-by-step eco-friendly treatment |
| chemical_treatment | text | Approved chemical solutions |
| dosage_per_perch | text | Recommended dosage per perch/acre |
| withholding_period_days | int | Safe harvest waiting period |

### crop_prices (Market Price History)
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| crop_type | varchar | Paddy, Big Onion, Carrot, etc. |
| variety | varchar | |
| market_name | varchar | Dambulla, Pettah, Keppetipola, Meegoda |
| wholesale_price | decimal | LKR per kg |
| retail_price | decimal | LKR per kg |
| price_trend | enum | rising / falling / stable |
| source | varchar | HARTI / Market Admin / Manual |
| recorded_at | timestamp | Date of price feed |

### ai_assistant_conversations
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| user_id | UUID | FK → users.id |
| session_title | varchar | Summary of conversation topic |
| language | varchar | si / ta / en |
| created_at | timestamp | |

### ai_assistant_messages
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| conversation_id | UUID | FK → ai_assistant_conversations.id |
| sender | enum | user / assistant |
| content | text | Message text |
| image_url | varchar | Optional leaf photo reference |
| context_metadata | jsonb | Attached diagnosisId or crop data |
| sent_at | timestamp | |

### regional_announcements & weather_alerts
| Field | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| title | varchar | Headline |
| message | text | Detailed alert |
| target_districts | text[] | Target Sri Lankan districts |
| target_crops | text[] | Specific crops impacted (optional) |
| priority | enum | normal / urgent / outbreak_warning |
| created_by | UUID | Admin ID |
| created_at | timestamp | |

## 4. Key API Endpoints

```
-- Auth & Profiles --
POST   /api/v1/auth/otp/send
POST   /api/v1/auth/otp/verify
POST   /api/v1/auth/demo-login        (Viva / Examiner 1-click login)
GET    /api/v1/users/me
PUT    /api/v1/users/me

-- Market Prices --
GET    /api/v1/prices                 (Filter by crop, market, category)
GET    /api/v1/prices/{cropId}/trends (Historical 7d, 1m, 3m trends)
POST   /api/v1/prices/bulletin-import (Market Admin semi-automated HARTI import)

-- AI Vision Disease Detection --
POST   /api/v1/diagnosis/scan         (Upload leaf image → diagnosis)
GET    /api/v1/diagnosis/{id}/shops   (PostGIS nearby shops for diagnosis)
POST   /api/v1/diagnosis/dosage-calc  (Land area [Acres/Perches] → required dosage)

-- Farmly AI Assistant (LLM) --
POST   /api/v1/ai/assistant/chat      (Conversational advisory with Gemini)
GET    /api/v1/ai/assistant/history   (Retrieve past conversations)

-- Marketplace --
GET    /api/v1/listings               (Search by crop, PostGIS radius, price, variety)
POST   /api/v1/listings               (Farmer creates produce listing)
PUT    /api/v1/listings/{id}
DELETE /api/v1/listings/{id}

-- Shop Discovery --
GET    /api/v1/shops/nearby           (PostGIS ST_DWithin search with product filter)
GET    /api/v1/shops/{id}

-- Admin Management --
GET    /api/v1/admin/users
PUT    /api/v1/admin/users/{id}/verify
GET    /api/v1/admin/listings/moderation
POST   /api/v1/admin/announcements
GET    /api/v1/admin/analytics/overview
```

## 5. Geospatial PostGIS Query Pattern

Example query for finding nearby shops stocking a specific treatment product within $20\text{ km}$:

```sql
SELECT 
    s.id AS shop_id,
    s.name AS shop_name,
    p.product_name,
    p.unit_price,
    p.stock_status,
    ROUND((ST_Distance(s.location, ST_SetSRID(ST_MakePoint(:farmerLng, :farmerLat), 4326)::geography) / 1000)::numeric, 2) AS distance_km
FROM users s
JOIN shop_products p ON p.shop_id = s.id
WHERE s.role = 'shop'
  AND s.verified = true
  AND p.stock_status != 'out_of_stock'
  AND (p.product_name ILIKE :treatmentKeyword OR p.active_ingredient ILIKE :treatmentKeyword)
  AND ST_DWithin(s.location, ST_SetSRID(ST_MakePoint(:farmerLng, :farmerLat), 4326)::geography, :radiusMeters)
ORDER BY distance_km ASC;
```
