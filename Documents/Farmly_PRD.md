# Farmly — Product Requirements Document (PRD)

**Version:** 2.0 (Enhanced with Farmly AI Assistant & Smart Agri Features)  
**Author:** Kukarakshan Panchadsaram (Rakshan)  
**Type:** Final Year Project — Software Engineering, NSBM Green University  
**Platform:** Android mobile application (primary, Flutter), with a companion web-based admin dashboard (React + TypeScript)  

---

## 1. Executive Summary

Farmly is a mobile-first platform that connects farmers, buyers, and agro-input shops across Sri Lanka. It solves core challenges in Sri Lanka's agricultural sector: lack of access to real-time crop market prices, late crop disease diagnosis, absence of trusted direct buyer connections, and language/literacy hurdles in obtaining agricultural advice. Farmly combines on-device/cloud computer vision for disease detection, an AI conversational agricultural assistant powered by Google Gemini, geospatial shop discovery (PostGIS), and a direct connection marketplace.

## 2. Problem Statement

- **Price Asymmetry:** Farmers frequently sell produce at a loss because they lack access to current, reliable wholesale market prices (Dambulla, Pettah, Keppetipola) and rely on middlemen.
- **Disease & Late Intervention:** Crop diseases cause massive yield losses due to delayed or inaccurate diagnosis. Furthermore, farmers struggle to find which local shop stocks the exact treatment.
- **Agricultural Advisory Gap:** Access to agrarian extension officers is limited. Farmers need instant, conversational advice in Sinhala, Tamil, or English tailored to Sri Lankan conditions (Maha/Yala seasons, local soils).
- **Inefficient Discovery:** Deals happen informally without price transparency or easy ways to locate nearby stock.

## 3. Goals and Objectives

- Give farmers fast, reliable access to current crop prices backed by daily market bulletins (e.g., HARTI).
- Allow farmers to self-diagnose crop diseases using AI and calculate safe chemical/organic dosages based on land size (Acres/Perches).
- Provide an on-demand, multilingual conversational **Farmly AI Assistant** for farming advice.
- Connect farmers directly with buyers and nearby shops using PostGIS geolocation, cutting out middlemen.
- Enable an **Examiner / Viva Demo Mode** for seamless university grading and testing.
- Ship a production-ready, demoable Android app installable via the Google Play Store.

## 4. Target Users / Personas

| Persona | Description | Primary Need |
|---|---|---|
| **Farmer** | Small to mid-scale crop grower, moderate digital literacy, mostly Android, intermittent connectivity | Check prices, diagnose disease, consult AI assistant, sell produce, find treatment |
| **Buyer** | Trader, wholesaler, retailer, or exporter | Find reliable farmers with the right crop/variety/quantity nearby |
| **Shop owner** | Organic/chemical agro-input supplier | Get discovered by farmers who need their stock based on diagnoses |
| **Market administrator** | Limited-access role, oversees price data | Review and publish daily market price feeds with minimal manual entry |
| **Platform admin** | Oversees the whole system | Verify users, moderate content, monitor platform health, broadcast alerts |

## 5. Scope

**In scope (v1):**
- Farmer, buyer, and shop mobile app (Android, Flutter)
- AI crop disease detection with organic + chemical treatment options
- Conversational **Farmly AI Assistant** (Google Gemini 1.5 Flash) with Sinhala, Tamil, and English support
- Dosage & acreage calculator (Acres, Roods, Perches)
- Real-time/near real-time market price module with bulletin import assistant
- Farmer–buyer produce marketplace (discovery + direct contact via Phone, WhatsApp, and in-app chat)
- Farmer–shop geospatial discovery (treatment product matching via PostGIS)
- Weather & regional disease outbreak alerts
- Examiner / Viva Demo Mode (1-click role switching with preset accounts)
- Admin web dashboard (React + TypeScript) for verification, moderation, price feeds, and analytics

**Out of scope (v1):**
- In-app payments or escrow (direct transaction only)
- Dedicated iOS release (Android-first, though Flutter enables iOS future builds)
- Built-in logistics and delivery fleet management
- International markets (Sri Lanka-focused)

## 6. Functional Requirements

### 6.1 Market Price Module
- View current prices by crop and market/region (Dambulla, Pettah, Keppetipola, Narahenpita, etc.)
- Price trend history (charts: 7-day, 1-month, 3-month views)
- High/Average/Low price statistics
- Market administrators review and approve daily price bulletins (semi-automated import/parser)

### 6.2 AI Crop Disease Detection Module
- Capture photo via camera or upload from gallery
- Hybrid inference: On-device TensorFlow Lite first; FastAPI cloud fallback for edge cases
- Output: Disease name, confidence score, severity grade (mild/moderate/severe)
- Treatment recommendations: Curated organic and approved chemical treatments
- Sri Lankan dosage calculator: Input land area (Acres/Perches) to estimate treatment quantity
- "Ask Farmly AI" quick action: Seamlessly hand off diagnosis results to the conversational assistant
- "Find Nearby Shops" action: Instant PostGIS search for shops stocking the prescribed product

### 6.3 Farmly AI Assistant ("Govi Sahakaru")
- Conversational chat powered by Google Gemini 1.5 Flash (securely routed via backend)
- Full trilingual support: Sinhala (සිංහල), Tamil (தமிழ்), English
- Grounded in Sri Lankan agriculture: Maha & Yala cropping seasons, agro-climatic zones (Dry, Wet, Intermediate), and Dept. of Agriculture guidelines
- Multimodal capability: Ingests leaf photos and diagnosis results for contextual Q&A
- Quick-prompt suggestions (e.g., *"How to treat paddy blast"*, *"Best fertilizer schedule for chili"*, *"Market price advice"*)

### 6.4 Farmer–Buyer Marketplace
- Farmers create, edit, and manage produce listings (crop, variety, quantity, unit, quality grade, price expectation, harvest date, location, photos)
- Standardized staple varieties (e.g., Paddy: Samba, Keeri Samba, Nadu; Chili: MI-2, etc.)
- Buyers search/filter listings by crop, location radius, price range, and quantity
- Star rating system for mutual trust after completed deals
- Direct contact tri-channel: In-app chat, WhatsApp deep link, and native phone call

### 6.5 Farmer–Shop Discovery
- Direct search or auto-suggested shop matching based on diagnosed disease
- Map view (Google Maps) and list view with distance calculation
- Shop profile: Inventory with real-time stock status (in stock, low stock, out of stock) and pricing
- Same tri-channel contact options (Chat, WhatsApp, Phone call)

### 6.6 Admin & Oversight Module
- Account verification for farmers, buyers, and shops
- Listing and product moderation queue
- Disease-to-treatment mapping database management
- Market price bulletin feed review and approval
- Regional broadcast alerts & weather notifications
- Analytics: Active users, popular crops, regional disease hotspots

### 6.7 Examiner / Viva Demo Mode
- Login screen toggle allowing academic evaluators to bypass SMS OTP
- One-click login as preset personas:
  - *Sunil (Verified Farmer - Anuradhapura)*
  - *Perera (Produce Buyer - Colombo)*
  - *AgroChem Lanka (Verified Shop - Dambulla)*
  - *System Admin*

## 7. Non-Functional Requirements

- **Usability:** High-contrast design, 14px+ typography, large touch targets, icon-supported navigation for low-digital-literacy users
- **Multilingual:** Dynamic switching between Sinhala, Tamil, and English
- **Offline Resilience:** Local caching of recent market prices and shop listings; offline scan queuing
- **Performance:** On-device inference < 1.5 seconds; API responses < 300ms
- **Location-Based Accuracy:** PostGIS spatial queries returning shops/buyers within accurate kilometer radiuses
- **Security & Trust:** Role-Based Access Control (RBAC), phone verification, server-side secret management (Gemini API keys never exposed in mobile app)

## 8. Tech Stack Architecture

| Layer | Technology |
|---|---|
| Mobile App | Flutter (Android-first) |
| Backend API | Spring Boot 3+ (Java 17) |
| Database | PostgreSQL 15+ with PostGIS extension |
| Generative AI | Google Gemini 1.5 Flash (via Backend API) |
| Vision AI Inference | TensorFlow Lite (edge) + FastAPI (cloud fallback) |
| Real-time Messaging | Firebase Firestore |
| Auth & Push Notifications | Firebase Auth (Phone OTP + Demo bypass) & FCM |
| Mapping & Geolocation | Google Maps SDK & PostGIS ST_DWithin |
| Admin Web Dashboard | React + TypeScript (Vite) |
| Hosting & Cloud | Railway / Render (backend + DB), Vercel (admin dashboard) |

## 9. Success Metrics (for University Project Evaluation)

- Complete end-to-end user journeys demonstrated without runtime failure
- Conversational AI Assistant answering domain-specific queries accurately in Sinhala and Tamil
- PostGIS spatial matching returning verified nearby shops within 5km - 25km
- AI disease classification achieving $\ge 85\%$ accuracy on benchmark validation sets
- Successful deployment to Google Play Console Internal Testing track
