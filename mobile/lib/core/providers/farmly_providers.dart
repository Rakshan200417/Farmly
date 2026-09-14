import 'package:flutter/material.dart';
import '../models/farmly_models.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String langCode) {
    _currentLanguage = langCode;
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  UserRole _selectedRole = UserRole.farmer;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  UserRole get selectedRole => _selectedRole;

  void setSelectedRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  // 1-Click Examiner Demo Mode Login
  void loginWithDemoRole(UserRole role) {
    switch (role) {
      case UserRole.farmer:
        _currentUser = UserModel(
          id: 'demo-farmer-01',
          name: 'Suneth Perera',
          phone: '+94 77 123 4567',
          role: UserRole.farmer,
          district: 'Anuradhapura',
          locationName: 'Thirappane, Anuradhapura',
          lat: 8.3114,
          lng: 80.4037,
          rating: 4.8,
          reviewsCount: 112,
        );
        _selectedRole = UserRole.farmer;
        break;
      case UserRole.buyer:
        _currentUser = UserModel(
          id: 'demo-buyer-01',
          name: 'Priyashantha Wholesale',
          phone: '+94 71 987 6543',
          role: UserRole.buyer,
          district: 'Colombo',
          locationName: 'Pettah Wholesale Market, Colombo',
          lat: 6.9360,
          lng: 79.8530,
          rating: 4.9,
          reviewsCount: 88,
        );
        _selectedRole = UserRole.buyer;
        break;
      case UserRole.shop:
        _currentUser = UserModel(
          id: 'demo-shop-01',
          name: 'Perera Agri Inputs & Seeds',
          phone: '+94 76 555 1234',
          role: UserRole.shop,
          district: 'Matale',
          locationName: 'Dambulla Road, Dambulla',
          lat: 7.8731,
          lng: 80.6511,
          rating: 4.8,
          reviewsCount: 95,
        );
        _selectedRole = UserRole.shop;
        break;
      case UserRole.admin:
        _currentUser = UserModel(
          id: 'demo-admin-01',
          name: 'Platform Overseer (Admin)',
          phone: '+94 70 000 0000',
          role: UserRole.admin,
          district: 'Colombo',
          locationName: 'Headquarters, Colombo',
          lat: 6.9271,
          lng: 79.8612,
        );
        _selectedRole = UserRole.admin;
        break;
    }
    _isAuthenticated = true;
    notifyListeners();
  }

  void loginWithPhone(String phone) {
    _currentUser = UserModel(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Suneth',
      phone: phone,
      role: _selectedRole,
      district: 'Anuradhapura',
      locationName: 'Anuradhapura, Sri Lanka',
      lat: 8.3114,
      lng: 80.4037,
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

class FarmlyDataProvider extends ChangeNotifier {
  List<CropPriceModel> prices = [
    CropPriceModel(
      id: 'price-paddy',
      cropName: 'Paddy (Rice)',
      category: 'Grains',
      pricePerKg: 110.0,
      changePercent: 5.0,
      isPositive: true,
      sparklinePoints: [98, 102, 100, 104, 106, 108, 110],
      iconType: 'grain',
    ),
    CropPriceModel(
      id: 'price-red-onion',
      cropName: 'Red Onion',
      category: 'Vegetables',
      pricePerKg: 240.0,
      changePercent: -2.0,
      isPositive: false,
      sparklinePoints: [255, 250, 248, 252, 246, 243, 240],
      iconType: 'onion',
    ),
    CropPriceModel(
      id: 'price-big-onion',
      cropName: 'Big Onion',
      category: 'Vegetables',
      pricePerKg: 185.0,
      changePercent: 1.0,
      isPositive: true,
      sparklinePoints: [180, 182, 181, 184, 183, 184, 185],
      iconType: 'onion',
    ),
    CropPriceModel(
      id: 'price-tomato',
      cropName: 'Tomato',
      category: 'Vegetables',
      pricePerKg: 320.0,
      changePercent: 12.0,
      isPositive: true,
      sparklinePoints: [280, 290, 285, 305, 310, 315, 320],
      iconType: 'tomato',
    ),
    CropPriceModel(
      id: 'price-chili',
      cropName: 'Green Chili',
      category: 'Spices',
      pricePerKg: 650.0,
      changePercent: -4.0,
      isPositive: false,
      sparklinePoints: [690, 680, 675, 670, 665, 655, 650],
      iconType: 'chili',
    ),
  ];

  List<ProduceListingModel> listings = [
    ProduceListingModel(
      id: 'list-01',
      cropName: 'Roma Tomatoes',
      variety: 'Roma Organic',
      category: 'Vegetables',
      pricePerKg: 450.0,
      availableQty: 50.0,
      minOrderQty: 5.0,
      qualityGrade: 'Grade A • Organic',
      harvestDate: 'Oct 12, 2026',
      location: 'Dambulla, Central Province',
      distanceKm: 3.2,
      farmerName: 'Suneth P.',
      farmerRating: 4.8,
      farmerReviewCount: 112,
      farmerPhone: '+94771234567',
      imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600',
      description: 'Hand-picked organic Roma tomatoes grown in rich red soil. No synthetic pesticides used.',
    ),
    ProduceListingModel(
      id: 'list-02',
      cropName: 'Green Chilies',
      variety: 'Kochchi Variety',
      category: 'Spices',
      pricePerKg: 850.0,
      availableQty: 15.0,
      minOrderQty: 1.0,
      qualityGrade: 'Grade A',
      harvestDate: 'Oct 14, 2026',
      location: 'Galewela, Matale',
      distanceKm: 5.1,
      farmerName: 'Malini D.',
      farmerRating: 4.5,
      farmerReviewCount: 89,
      farmerPhone: '+94712345678',
      imageUrl: 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600',
      description: 'Extremely fresh and pungent native Kochchi green chilies, harvested early morning.',
    ),
    ProduceListingModel(
      id: 'list-03',
      cropName: 'Long Beans',
      variety: 'Polonnaruwa Green',
      category: 'Vegetables',
      pricePerKg: 180.0,
      availableQty: 120.0,
      minOrderQty: 10.0,
      qualityGrade: 'Standard Quality',
      harvestDate: 'Oct 13, 2026',
      location: 'Polonnaruwa',
      distanceKm: 8.0,
      farmerName: 'Kamal W.',
      farmerRating: 4.2,
      farmerReviewCount: 45,
      farmerPhone: '+94761234567',
      imageUrl: 'https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=600',
      description: 'Crisp green long beans perfect for wholesale distribution.',
    ),
    ProduceListingModel(
      id: 'list-04',
      cropName: 'Premium Organic Carrots',
      variety: 'Nantes',
      category: 'Vegetables',
      pricePerKg: 450.0,
      availableQty: 500.0,
      minOrderQty: 25.0,
      qualityGrade: 'Grade A • Organic Certified',
      harvestDate: 'Oct 24, 2026',
      location: 'Nuwara Eliya, Central Province',
      distanceKm: 14.5,
      farmerName: 'Sunil Perera',
      farmerRating: 4.8,
      farmerReviewCount: 124,
      farmerPhone: '+94779876543',
      imageUrl: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600',
      description: 'High-quality, organically grown Nantes carrots from the cool climates of Nuwara Eliya. Washed and ready for transport.',
    ),
  ];

  DiagnosisModel sampleDiagnosis = DiagnosisModel(
    id: 'diag-01',
    cropName: 'Paddy (Rice)',
    diseaseName: 'Bacterial Leaf Blight',
    scientificName: 'Xanthomonas oryzae pv. oryzae',
    severity: 'SEVERE',
    confidencePercent: 87.0,
    warningBanner: 'High incidence of Blight reported in your area.',
    description: 'Identified based on water-soaked to yellowish stripes on leaf blades or starting at leaf tips with a wavy margin.',
    organicTreatments: [
      TreatmentItem(
        name: 'Neem Oil Extract',
        instruction: '5ml per 1 Liter of water. Apply early morning before sunlight turns intense.',
        dosagePerLiter: '5ml / L',
        standardPerchDosageGrams: 20.0,
      ),
      TreatmentItem(
        name: 'Copper Hydroxide (Organic Approved)',
        instruction: 'Follow local agricultural guidelines for concentration. Do not apply in high heat.',
        dosagePerLiter: '2g / L',
        standardPerchDosageGrams: 10.0,
      ),
    ],
    chemicalTreatments: [
      TreatmentItem(
        name: 'Streptomycin Sulphate + Tetracycline',
        instruction: '1.5g per 10 Liters of water. Spray immediately on infected leaf patches.',
        dosagePerLiter: '0.15g / L',
        standardPerchDosageGrams: 5.0,
      ),
      TreatmentItem(
        name: 'Copper Oxychloride',
        instruction: '2.5g per 1 Liter of water. Do not spray right before heavy rain.',
        dosagePerLiter: '2.5g / L',
        standardPerchDosageGrams: 15.0,
      ),
    ],
  );

  List<ShopModel> shops = [
    ShopModel(
      id: 'shop-01',
      name: 'Perera Agri Inputs & Seeds',
      address: 'No. 45, Dambulla Market Rd, Dambulla',
      distanceKm: 1.2,
      rating: 4.8,
      reviewsCount: 142,
      phone: '+94765551234',
      lat: 7.8731,
      lng: 80.6511,
      tags: ['Seeds', 'Organic', 'Tools', 'Fertilizer'],
      products: [
        ShopProductItem(name: 'Neem Oil Extract (500ml)', category: 'Organic', price: 950.0, unit: '500ml bottle', stockStatus: 'in_stock'),
        ShopProductItem(name: 'Copper Oxychloride 50 WP', category: 'Chemical', price: 1400.0, unit: '500g pack', stockStatus: 'in_stock'),
        ShopProductItem(name: 'Bio-Compost Grade A', category: 'Organic', price: 450.0, unit: '20kg bag', stockStatus: 'in_stock'),
        ShopProductItem(name: 'Knapsack Sprayer 16L', category: 'Equipment', price: 6500.0, unit: '1 unit', stockStatus: 'low_stock'),
      ],
    ),
    ShopModel(
      id: 'shop-02',
      name: 'Govi Setha Agricultural Center',
      address: 'Kurunegala Junction, Galewela',
      distanceKm: 3.5,
      rating: 4.6,
      reviewsCount: 88,
      phone: '+94772223344',
      lat: 7.8500,
      lng: 80.6200,
      tags: ['Organic', 'Pesticides', 'Chemical'],
      products: [
        ShopProductItem(name: 'Streptomycin Sulphate 90%', category: 'Chemical', price: 1850.0, unit: '100g pack', stockStatus: 'in_stock'),
        ShopProductItem(name: 'Trichoderma Bio-Fungicide', category: 'Organic', price: 850.0, unit: '1kg bag', stockStatus: 'in_stock'),
      ],
    ),
    ShopModel(
      id: 'shop-03',
      name: 'Lanka Agro Chemicals & Equipment',
      address: 'Main St, Kekirawa',
      distanceKm: 6.8,
      rating: 4.4,
      reviewsCount: 62,
      phone: '+94714445566',
      lat: 7.9100,
      lng: 80.5900,
      tags: ['Chemical', 'Equipment'],
      products: [
        ShopProductItem(name: 'Copper Oxychloride 50 WP', category: 'Chemical', price: 1450.0, unit: '500g pack', stockStatus: 'in_stock'),
      ],
    ),
  ];

  List<AiMessage> aiChatMessages = [
    AiMessage(
      id: 'ai-init',
      text: 'ආයුබෝවන්! வணக்கங்கள்! Hello!\nI am Farmly AI ("Govi Sahakaru"), your personal Sri Lankan agricultural advisor. How can I assist your farm today? You can ask about crop diseases, dosage, Maha/Yala seasons, or market price trends.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  // Farmly AI Assistant response generation
  void sendAiMessage(String userText, {String? attachedContext}) {
    aiChatMessages.add(
      AiMessage(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        text: userText,
        isUser: true,
        timestamp: DateTime.now(),
        attachedContext: attachedContext,
      ),
    );
    notifyListeners();

    // Generate smart Sri Lankan contextual response
    Future.delayed(const Duration(milliseconds: 900), () {
      String reply = _generateLocalAgriReply(userText, attachedContext);
      aiChatMessages.add(
        AiMessage(
          id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }

  String _generateLocalAgriReply(String query, String? context) {
    final lower = query.toLowerCase();

    if (context != null && context.contains('Bacterial Leaf Blight')) {
      return 'Regarding Bacterial Leaf Blight on Paddy:\n\n'
          '1. **Immediate Action:** Drain excess standing water from the paddy field for 2–3 days to slow bacterial transmission.\n'
          '2. **Organic Remedy:** Spray Neem Seed Kernel Extract (5%) early in the morning.\n'
          '3. **Chemical Treatment:** If severity is high, apply Copper Oxychloride (2.5g/L) or Streptomycin formulation.\n'
          '4. **Caution:** Avoid excessive urea/nitrogen top-dressing as high nitrogen aggravates leaf blight.\n'
          'Would you like to calculate exact sprayer quantities for your field acreage?';
    }

    if (lower.contains('මිරිස්') || lower.contains('chili') || lower.contains('மிளகாய்')) {
      return 'For Chili cultivation in Sri Lanka:\n\n'
          '• **Leaf Curl Virus:** Primarily spread by thrips and whiteflies. Keep yellow sticky traps across the plot (10–12 traps per acre).\n'
          '• **Treatment:** Spray Neem oil (5ml/L) or botanical bio-pesticides. For severe pest attacks, use Imidacloprid as recommended by the Department of Agriculture.\n'
          '• **Current Market:** Green Chili is fetching Rs. 650/kg at Dambulla Wholesale Centre.';
    }

    if (lower.contains('මිල') || lower.contains('price') || lower.contains('விலை')) {
      return '📊 **Latest Economic Centre Highlights:**\n\n'
          '• **Paddy (Samba):** Rs. 110/kg (↑ 5% this week)\n'
          '• **Green Chili:** Rs. 650/kg\n'
          '• **Roma Tomato:** Rs. 320/kg (High demand)\n'
          '• **Carrot (Nuwara Eliya):** Rs. 450/kg\n'
          'Prices are verified from Dambulla and Pettah daily market bulletins.';
    }

    return 'Thank you for your question! As your Sri Lankan farming companion:\n\n'
        '• For pest/disease concerns, remember to inspect leaf undersides early morning.\n'
        '• Follow safe withholding periods (minimum 7–14 days before harvest after spraying).\n'
        '• Check the "Prices" tab for daily wholesale trends to plan your harvest timing.\n'
        'You can also scan any affected leaf using the "Scan" tab for instant diagnosis!';
  }

  // Dosage calculator logic (Acres / Perches to required treatment)
  Map<String, String> calculateDosage({
    required double landAmount,
    required bool isAcres,
    required double perchGrams,
  }) {
    // 1 Acre = 160 Perches
    double totalPerches = isAcres ? landAmount * 160 : landAmount;
    double totalGramsOrMl = totalPerches * perchGrams;
    double sprayTanks16L = (totalPerches * 0.5).clamp(1.0, 999.0); // approx 1 knapsack tank per 2 perches

    String weightLabel = totalGramsOrMl >= 1000
        ? '${(totalGramsOrMl / 1000).toStringAsFixed(2)} kg / Liters'
        : '${totalGramsOrMl.toStringAsFixed(0)} g / ml';

    return {
      'totalProduct': weightLabel,
      'waterVolume': '${(sprayTanks16L * 16).toStringAsFixed(0)} Liters',
      'sprayTanks': '${sprayTanks16L.toStringAsFixed(1)} Knapsack Tanks (16L)',
      'landSummary': isAcres ? '$landAmount Acres ($totalPerches Perches)' : '$landAmount Perches',
    };
  }
}
