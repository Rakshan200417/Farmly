# Farmly

**Farmly** is a mobile-first agriculture platform connecting farmers, buyers, and agro-input shops in Sri Lanka. It helps farmers check real-time crop prices, diagnose crop diseases using AI, consult a multilingual AI agricultural assistant, sell produce directly to buyers, and find nearby shops for treatment products — all from a phone, without needing to visit a website.

## Problem It Solves

Farmers often sell at a loss due to lack of price information, struggle to identify crop diseases early, and have no direct digital channel to reach buyers or find the right treatment nearby. Furthermore, low digital literacy and language barriers make navigating complex agricultural portals difficult. Farmly closes that gap with a unified mobile ecosystem featuring smart AI consultation, local market prices, and community discovery.

## Key Features

- **Live market prices & trends** — current and historical crop prices by market/region (Dambulla, Pettah, Keppetipola, etc.) with semi-automated HARTI bulletin updates.
- **AI crop disease detection** — scan a leaf, get instant edge/cloud diagnosis, severity analysis, and organic + chemical treatment options.
- **Farmly AI Assistant ("Govi Sahakaru")** — conversational agronomist powered by Google Gemini, answering questions in Sinhala, Tamil, and English tailored to Sri Lankan agro-climatic zones and Maha/Yala seasons.
- **Sri Lankan dosage & acreage calculator** — calculates exact organic/chemical quantities needed based on land size (Acres, Roods, Perches).
- **Farmer–buyer marketplace** — list produce, browse listings, and connect directly via phone, WhatsApp, or in-app chat (no in-app payments).
- **Farmer–shop discovery** — find nearby shops stocking the exact treatment needed with real-time PostGIS distance matching.
- **Regional weather & pest alerts** — localized early warnings to prevent disease outbreaks.
- **Examiner / Viva Demo Mode** — instant 1-click role switching for academic evaluations and testing.
- **Admin dashboard** — verification, moderation, price oversight, announcements, and analytics.

## How the App Works

### High-level flow

```
Farmer opens app
   │
   ├── Farmly AI Assistant ──► Multilingual advisory (Sinhala/Tamil/English) & dosage math
   │
   ├── Check Prices ──► Market Price Service (HARTI-backed) ──► current + historical trends
   │
   ├── Scan Crop ──► Photo captured ──► On-device TFLite / Cloud AI fallback
   │                     │
   │                     ├──► Diagnosis + Treatment options
   │                     │        │
   │                     │        ├──► "Ask Farmly AI about this" ──► Interactive Q&A
   │                     │        │
   │                     │        └──► "Find nearby shops" ──► PostGIS Shop Discovery
   │
   ├── List Produce ──► Saved to Marketplace ──► visible to Buyers
   │
   └── Nearby Shops ──► Shop Discovery Service ──► browse/search shops directly
```

### Core modules

1. **Auth & Profile** — phone OTP login (Firebase Auth), 1-click Examiner Demo Mode, role selection (Farmer / Buyer / Shop), profile setup with location.
2. **Farmly AI Assistant Module** — conversational agronomist powered by Google Gemini, offering multimodal follow-ups, local farming knowledge, and dosage calculation.
3. **Market Price Module** — live wholesale & retail price trends by crop and economic centre, with Market Admin bulletin approval.
4. **AI Disease Detection Module** — TensorFlow Lite on-device inference for fast local detection; FastAPI cloud fallback for edge cases; connected to an admin-curated disease-treatment database.
5. **Marketplace Module (Farmer ↔ Buyer)** — listings management, search & filters (crop, variety, location radius, price), rating system, and direct contact (phone, WhatsApp, in-app chat).
6. **Shop Discovery Module (Farmer ↔ Shop)** — geospatial shop search (PostGIS) linking diagnosed treatments directly to local stock availability.
7. **Chat Module** — lightweight real-time messaging (Firebase Firestore) with quick-access call and WhatsApp actions.
8. **Admin Module** — web dashboard (React + TypeScript) for account verification, listing moderation, bulletin imports, disease mapping, and regional broadcast alerts.

### Tech Stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter (Android-first, iOS ready) |
| Backend API | Spring Boot (Java 17+) |
| Database | PostgreSQL + PostGIS |
| AI Disease Detection | TensorFlow Lite (edge) + FastAPI (cloud fallback) |
| Generative AI Assistant | Google Gemini 1.5 Flash (via Backend API) |
| Real-time chat & Auth | Firebase Firestore & Firebase Auth (phone OTP + demo bypass) |
| Maps & Geolocation | Google Maps SDK & PostGIS |
| Admin dashboard | React + TypeScript + Vite |
| Hosting | Railway (backend + DB), Vercel (admin dashboard) |

## Project Structure

```
farmly/
├── mobile/              # Flutter mobile application
├── backend/             # Spring Boot REST API
├── ai-service/          # FastAPI disease inference & Python utilities
├── admin-dashboard/     # React + TypeScript web admin portal
└── Documents/           # PRD, architecture, and development guides
```

## User Roles

- **Farmer** — checks prices, scans crops, chats with Farmly AI, lists produce, contacts buyers and shops
- **Buyer** — browses produce listings, filters by region/variety, contacts farmers directly
- **Shop Owner** — lists inventory, receives inquiries, discovered automatically by diagnosed farmers
- **Market Administrator** — reviews and publishes daily market price feeds
- **Platform Admin** — verifies users, moderates content, manages disease mappings, broadcasts regional alerts

## Author

Kukarakshan Panchadsaram (Rakshan) — Software Engineering undergraduate, NSBM Green University. Final year project.
