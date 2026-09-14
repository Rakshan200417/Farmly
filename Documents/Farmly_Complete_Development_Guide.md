# Farmly — Complete Development Guide

**Purpose of this document:** This is the finalized single reference document for building Farmly directly in code (Flutter + Spring Boot + FastAPI + React/TS). It contains the brand system, requirements, architectural flows, and implementation specifications for core modules including the **Farmly AI Assistant**, **Disease Detection**, **Market Prices**, **Marketplace**, and **Shop Discovery**.

---

## PART 1 — BRAND & COLOR SYSTEM

This palette is final and must be maintained across all mobile and web screens:

| Role | Hex | Usage |
|---|---|---|
| Primary — Fresh Leaf Green | `#3C8D40` | Primary buttons, active nav icon/tab, headers, positive price trends, verified badge |
| Secondary — Warm Amber | `#F5A623` | Main call-to-action buttons ("Scan Crop", "Ask Farmly AI", "Publish Listing"), highlight badges |
| Accent — Deep Teal | `#00695C` | Links, chat elements, secondary icon buttons, selected filter chips |
| Background | `#FAF9F6` | All screen backgrounds |
| Card Background | `#FFFFFF` | Elevated cards, list items |
| Text Primary — Charcoal | `#2B2B2B` | Headings, primary body text |
| Text Secondary | `#6B6B68` | Captions, timestamps, helper text |
| Alert / Disease — Terracotta Red | `#C0533A` | Disease warnings, negative price trends, errors, destructive actions |
| Success — Muted Green | `#7CB342` | Confirmations, verified badges, completed statuses |
| Border / Divider | `#E4E2DA` | Card borders, list dividers |

**Component Rules:**
- 12px corner radius on cards, 8px on buttons/inputs, full pill radius on status chips/badges.
- Clean sans-serif typography: `Inter` or `Poppins` (min 14px body text, 1.5x line height).
- Flat design: No heavy shadows, max 2px blur at 5% opacity. Outline icons (24px).

---

## PART 2 — NEW & ENHANCED FEATURE SPECIFICATIONS

### 2.1 Farmly AI Assistant ("Govi Sahakaru")
- **Floating AI Trigger:** Floating circular action button on the Farmer Home Dashboard and Scan view (Leaf Green with glowing Amber spark/chat icon).
- **Post-Diagnosis Deep Dive:** On the Diagnosis Result card, include a prominent button: **"💬 Ask Farmly AI about this disease"**, which opens the AI chat with the diagnosed crop, disease name, and severity pre-loaded in context.
- **Trilingual Speech/Text Support:** Support Sinhala, Tamil, and English. The assistant prompt is instructed to reply in the user's selected language using simple, respectful Sri Lankan agricultural phrasing.
- **Backend Orchestration:** Mobile client calls `POST /api/v1/ai/assistant/chat`. Spring Boot backend securely binds the conversation with the Google Gemini 1.5 Flash API using system prompt grounding.

### 2.2 Sri Lankan Land & Dosage Calculator
- Integrated into the Diagnosis Result screen.
- Farmers enter land size: **Acres** (with fraction/decimals or Perches, e.g., *20 Perches* or *1.5 Acres*).
- System computes exact dilution or weight (e.g., *"150g of Mancozeb in 16L knapsack sprayer"* or *"5L of concentrated Neem extract"*).

### 2.3 Examiner / Viva Demo Mode
- A discrete pill toggle on the Login Screen: **"🎓 Examiner Demo Mode"**.
- Tapping it bypasses SMS OTP and presents 4 instant preset roles:
  1. **Sunil (Farmer - Anuradhapura)**: Has active paddy listings, sample scan history.
  2. **Perera (Buyer - Colombo)**: Ready to browse and test contact actions.
  3. **AgroChem Lanka (Shop - Dambulla)**: Has organic/chemical treatments in stock.
  4. **System Administrator**: Direct access to the admin dashboard.

### 2.4 Market Price Feed & Bulletin Import
- Daily price list organized by Sri Lankan Dedicated Economic Centres (**Dambulla, Pettah, Keppetipola, Meegoda**).
- Admin panel includes a **"Import Daily Bulletin"** action that pre-populates the day's average wholesale and retail prices from HARTI bulletins for quick 1-click verification.

---

## PART 3 — SYSTEM WORKFLOW & USER JOURNEYS

### 3.1 First-Time User Journey
1. **Splash Screen** $\rightarrow$ **Language Selection** (Sinhala / Tamil / English).
2. **Login Screen**: Enter phone number for Firebase SMS OTP, or tap **"Examiner Demo Mode"** to load a test profile immediately.
3. **Role Selection**: Pick **Farmer**, **Buyer**, or **Shop**.
4. **Profile Setup**: Name, profile photo, location (GPS auto-detection with manual district/town override), and role-specific crops/business details.
5. User lands on their role-specific dashboard.

### 3.2 Farmer Disease Scan $\rightarrow$ AI Consultation $\rightarrow$ Shop Flow
1. Farmer taps **"Scan Crop"** $\rightarrow$ Camera viewfinder opens.
2. Photo captured $\rightarrow$ TensorFlow Lite executes on-device inference.
3. If confidence is high ($\ge 75\%$), display instant diagnosis; otherwise, stream to FastAPI fallback service.
4. **Diagnosis Result:**
   - Disease name, severity rating, and confidence score.
   - Recommended Organic and Chemical treatments.
   - **Dosage Calculator:** Enter land acreage $\rightarrow$ shows exact dosage.
   - **Action 1: "Ask Farmly AI"** $\rightarrow$ opens chat to ask questions like *"Can I spray this while raining?"*
   - **Action 2: "Find Nearby Shops"** $\rightarrow$ queries PostGIS for shops within 25km stocking the recommended treatment.
5. Farmer views nearby shops on a Google Map / list, sorted by distance, with phone, WhatsApp, and in-app chat buttons.

### 3.3 Marketplace Produce Listing & Direct Deal Flow
1. Farmer taps **"My Listings"** $\rightarrow$ **"+"** button.
2. Selects crop (e.g. *Paddy - Samba*), quantity (*50 Bags / 2,500 kg*), quality grade, harvest date, and asking price per kg.
3. Listing becomes active and searchable by Buyers.
4. Buyer filters produce by crop and radius, reviews farmer ratings, and initiates direct communication via WhatsApp or phone call.

---

## PART 4 — PROJECT STRUCTURE & IMPLEMENTATION ROADMAP

```
farmly/
├── mobile/                  # Flutter application
│   ├── lib/
│   │   ├── core/            # Theme, constants, networking, localization (si/ta/en)
│   │   ├── features/
│   │   │   ├── auth/        # Phone OTP & Demo mode
│   │   │   ├── home/        # Role-based dashboards
│   │   │   ├── prices/      # Live prices & trend charts
│   │   │   ├── diagnosis/   # TFLite camera scanner & dosage calc
│   │   │   ├── ai_assistant/# Farmly AI conversational chat
│   │   │   ├── marketplace/ # Produce listings & search
│   │   │   ├── shops/       # PostGIS shop discovery & map
│   │   │   └── chat/        # In-app messaging
│   │   └── main.dart
│
├── backend/                 # Spring Boot REST API
│   ├── src/main/java/com/farmly/
│   │   ├── auth/            # Firebase auth filter & demo token provider
│   │   ├── ai/              # Google Gemini 1.5 Flash client & prompt templates
│   │   ├── prices/          # Price feeds & HARTI bulletin parser
│   │   ├── diagnosis/       # Disease treatment mappings & dosage service
│   │   ├── marketplace/     # Produce listings & buyer queries
│   │   ├── shops/           # PostGIS geospatial shop repository
│   │   └── admin/           # Role-gated moderation & analytics
│
├── ai-service/              # FastAPI Python service
│   ├── app/
│   │   ├── model/           # PyTorch / TFLite plant pathology weights
│   │   └── main.py          # /inference endpoint for cloud fallback
│
└── admin-dashboard/         # React + TypeScript (Vite)
    ├── src/
    │   ├── pages/           # Dashboard, User Verification, Moderation, Price Feeds
    │   └── components/      # Tables, Charts, Sidebar
```

---

## PART 5 — DEVELOPMENT EXECUTION PHASES

1. **Phase 1: Foundation & Backend Services**
   - Setup PostgreSQL with PostGIS extension.
   - Spring Boot skeleton with JPA repositories and REST controllers.
   - Integrate Google Gemini 1.5 Flash service for Farmly AI Assistant.
   - Implement mock/demo auth provider and seed realistic Sri Lankan crop and price data.

2. **Phase 2: Core Mobile Application (Flutter)**
   - Implement Farmly design system (colors, typography, cards, buttons).
   - Auth screens with Examiner Demo Mode toggle.
   - Farmer, Buyer, and Shop home dashboards.
   - Market Price browser with interactive historical charts.

3. **Phase 3: AI Assistant & Disease Detection**
   - Farmly AI chat interface with Sinhala/Tamil/English prompt selector.
   - Camera scan viewfinder with on-device TFLite model integration.
   - Diagnosis result screen with dosage calculator.

4. **Phase 4: Marketplace & Geospatial Shop Discovery**
   - Farmer listing creation and buyer search with PostGIS distance calculation.
   - Shop discovery map view (Google Maps) and product stock status.
   - Direct contact buttons (WhatsApp, Phone call, In-app chat).

5. **Phase 5: Admin Web Dashboard & Play Store Readiness**
   - React + TypeScript admin panel for user verification, moderation, and announcements.
   - Build Android release APK / App Bundle and finalize testing checklist.
