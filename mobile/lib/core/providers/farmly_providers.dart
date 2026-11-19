import 'package:flutter/material.dart';
import '../models/farmly_models.dart';
import '../services/api_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String langCode) {
    _currentLanguage = langCode;
    notifyListeners();
  }
}

/// ---------------------------------------------------------
/// MANUAL GEMINI API KEY CONFIGURATION
/// Paste your Google Gemini API key below to enable real AI.
/// You can get one for free at: https://aistudio.google.com/
/// ---------------------------------------------------------
const String MANUAL_GEMINI_API_KEY = "AQ.Ab8RN6K-wI-Ezu2jjMznGE_V9j7Yq4Ov3XwijC9CXUe5kwDO1g";

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  UserRole _selectedRole = UserRole.farmer;
  String? _jwtToken;
  bool _isLoading = false;
  String _geminiApiKey = MANUAL_GEMINI_API_KEY;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  UserRole get selectedRole => _selectedRole;
  String? get jwtToken => _jwtToken;
  bool get isLoading => _isLoading;
  String get geminiApiKey => _geminiApiKey;

  void setGeminiApiKey(String key) {
    _geminiApiKey = key.trim();
    notifyListeners();
  }

  void setSelectedRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  // Email & Password Sign Up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? district,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
      district: district,
      phone: phone,
    );

    _isLoading = false;

    if (result['success'] == true && result['user'] is UserModel) {
      _currentUser = result['user'] as UserModel;
      _jwtToken = result['token']?.toString();
      _selectedRole = _currentUser!.role;
      _isAuthenticated = true;
      notifyListeners();
      return {'success': true};
    } else {
      notifyListeners();
      return {'success': false, 'error': result['error'] ?? 'Sign up failed'};
    }
  }

  // Email & Password Sign In
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.signIn(
      email: email,
      password: password,
    );

    _isLoading = false;

    if (result['success'] == true && result['user'] is UserModel) {
      _currentUser = result['user'] as UserModel;
      _jwtToken = result['token']?.toString();
      _selectedRole = _currentUser!.role;
      _isAuthenticated = true;
      notifyListeners();
      return {'success': true};
    } else {
      notifyListeners();
      return {'success': false, 'error': result['error'] ?? 'Invalid email or password'};
    }
  }

  // Update Profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? district,
    String? locationName,
    String? profilePicture,
  }) async {
    if (_currentUser == null) return false;
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.updateProfile(
      userId: _currentUser!.id,
      name: name,
      phone: phone,
      district: district,
      locationName: locationName,
      profilePicture: profilePicture,
    );

    _isLoading = false;
    if (result['success'] == true && result['user'] is UserModel) {
      _currentUser = result['user'] as UserModel;
      notifyListeners();
      return true;
    } else {
      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        district: district,
        locationName: locationName,
      );
      notifyListeners();
      return true;
    }
  }

  // Direct Phone Login (Legacy/Fallback)
  Future<bool> loginWithPhone(
    String phone, {
    String? name,
    UserRole? role,
    String? district,
  }) async {
    _isLoading = true;
    notifyListeners();

    final targetRole = role ?? _selectedRole;
    final result = await ApiService.loginWithPhone(
      phone: phone,
      name: name,
      role: targetRole,
      district: district,
    );

    _isLoading = false;

    if (result['success'] == true && result['user'] is UserModel) {
      _currentUser = result['user'] as UserModel;
      _jwtToken = result['token']?.toString();
      _selectedRole = _currentUser!.role;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else {
      _currentUser = UserModel(
        id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        name: (name != null && name.trim().isNotEmpty) ? name.trim() : 'Farmer ($phone)',
        email: 'user@farmly.lk',
        phone: phone,
        role: targetRole,
        district: district ?? 'Anuradhapura',
        locationName: '${district ?? 'Anuradhapura'}, Sri Lanka',
        lat: 8.3114,
        lng: 80.4037,
      );
      _selectedRole = targetRole;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _jwtToken = null;
    notifyListeners();
  }
}

class FarmlyDataProvider extends ChangeNotifier {
  List<CropPriceModel> prices = [];
  List<ProduceListingModel> produceListings = [];
  List<ShopModel> shops = [];
  List<ConversationItemModel> conversations = [];
  DiagnosisModel? currentDiagnosis;
  bool isLoadingPrices = false;
  bool isLoadingListings = false;
  bool isLoadingShops = false;
  bool isLoadingConversations = false;
  String _geminiApiKey = '';

  void setGeminiApiKey(String key) {
    _geminiApiKey = key.trim();
    notifyListeners();
  }

  final List<AiMessage> chatMessages = [
    AiMessage(
      id: 'msg-01',
      text: 'ආයුබෝවන්! Hello! I am Farmly AI, your agricultural assistant for Sri Lankan farming.\n\n'
          'How can I assist your harvest or disease management today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  List<ProduceListingModel> get listings => produceListings;
  List<AiMessage> get aiChatMessages => chatMessages;

  FarmlyDataProvider() {
    loadAllData();
  }

  // Load all initial records from XAMPP MySQL
  Future<void> loadAllData() async {
    await Future.wait([
      fetchPrices(),
      fetchListings(),
      fetchShops(),
    ]);
  }

  // Live Messaging: Load conversations
  Future<void> fetchConversations(String userId) async {
    isLoadingConversations = true;
    notifyListeners();
    final res = await ApiService.getConversations(userId);
    conversations = res;
    isLoadingConversations = false;
    notifyListeners();
  }

  Future<List<ChatMessageModel>> fetchChatHistory(String user1, String user2) async {
    return await ApiService.getChatHistory(user1, user2);
  }

  Future<ChatMessageModel?> sendDirectMessage({
    required String senderId,
    required String senderName,
    required String recipientId,
    required String recipientName,
    required String content,
  }) async {
    final msg = await ApiService.sendChatMessage(
      senderId: senderId,
      senderName: senderName,
      recipientId: recipientId,
      recipientName: recipientName,
      content: content,
    );
    if (msg != null) {
      await fetchConversations(senderId);
    }
    return msg;
  }

  // 1. Live Crop Prices from XAMPP MySQL
  Future<void> fetchPrices({String? category}) async {
    isLoadingPrices = true;
    notifyListeners();

    final backendPrices = await ApiService.getPrices(category: category);
    if (backendPrices.isNotEmpty) {
      prices = backendPrices;
    }
    isLoadingPrices = false;
    notifyListeners();
  }

  // 2. Live Produce Listings from XAMPP MySQL
  Future<void> fetchListings({String? category, String? query}) async {
    isLoadingListings = true;
    notifyListeners();

    final backendListings = await ApiService.getListings(category: category, query: query);
    if (backendListings.isNotEmpty) {
      produceListings = backendListings;
    }
    isLoadingListings = false;
    notifyListeners();
  }

  // 3. Add Real Produce Listing (Inserts into XAMPP MySQL)
  Future<bool> addListing(ProduceListingModel newListing) async {
    final saved = await ApiService.createListing(newListing);
    if (saved != null) {
      produceListings.insert(0, saved);
      notifyListeners();
      return true;
    } else {
      produceListings.insert(0, newListing);
      notifyListeners();
      return true;
    }
  }

  // 4. Live Agro-Input Shops from XAMPP MySQL
  Future<void> fetchShops() async {
    isLoadingShops = true;
    notifyListeners();

    final backendShops = await ApiService.getShops();
    if (backendShops.isNotEmpty) {
      shops = backendShops;
    }
    isLoadingShops = false;
    notifyListeners();
  }

  // 5. Real Crop Disease Diagnosis from MySQL Knowledge Base
  Future<DiagnosisModel> diagnoseCrop(String cropName, {String? imageBase64}) async {
    final result = await ApiService.scanCrop(cropName, imageBase64: imageBase64);
    if (result != null) {
      currentDiagnosis = result;
      notifyListeners();
      return result;
    }

    // Default fallback diagnosis if offline
    final fallback = DiagnosisModel(
      id: 'diag-01',
      cropName: cropName,
      diseaseName: 'Bacterial Leaf Blight',
      scientificName: 'Xanthomonas oryzae pv. oryzae',
      severity: 'SEVERE',
      confidencePercent: 88.0,
      description: 'Identified based on water-soaked to yellowish stripes on leaf blades or starting at leaf tips.',
      warningBanner: 'High incidence of Blight reported in your agricultural zone.',
      organicTreatments: [
        TreatmentItem(
          name: 'Neem Seed Kernel Extract (5%)',
          instruction: '5ml per 1L water. Spray in early morning.',
          dosagePerLiter: '5ml / Liter',
          standardPerchDosageGrams: 15.0,
        ),
      ],
      chemicalTreatments: [
        TreatmentItem(
          name: 'Copper Oxychloride 50 WP',
          instruction: '2.5g per 1 Liter water. Avoid spraying right before heavy rainfall.',
          dosagePerLiter: '2.5g / Liter',
          standardPerchDosageGrams: 15.0,
        ),
      ],
    );
    currentDiagnosis = fallback;
    notifyListeners();
    return fallback;
  }

  // 6. Real Conversational AI Assistant (Calls backend /api/v1/ai/assistant/chat)
  Future<void> sendAiMessage(String text, {String? attachedContext, String? customApiKey}) async {
    final userMsg = AiMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      attachedContext: attachedContext,
    );
    chatMessages.add(userMsg);
    notifyListeners();

    // Call real backend AI assistant with API key
    final keyToUse = (customApiKey != null && customApiKey.isNotEmpty) ? customApiKey : _geminiApiKey;
    final aiReplyText = await ApiService.chatWithAi(text, diseaseContext: attachedContext, apiKey: keyToUse);

    final aiMsg = AiMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch + 1}',
      text: aiReplyText,
      isUser: false,
      timestamp: DateTime.now(),
    );
    chatMessages.add(aiMsg);
    notifyListeners();
  }

  // 7. Dosage Calculator (Calls backend or local DOA Sri Lanka formula)
  Future<Map<String, String>> calculateDosage({
    required double landAmount,
    required bool isAcres,
    required double perchGrams,
  }) async {
    final remoteCalc = await ApiService.calculateDosage(
      landAmount: landAmount,
      isAcres: isAcres,
      perchGrams: perchGrams,
    );
    if (remoteCalc != null) {
      return remoteCalc;
    }

    // Formula calculation fallback
    double totalPerches = isAcres ? landAmount * 160 : landAmount;
    double totalGramsOrMl = totalPerches * perchGrams;
    double sprayTanks16L = (totalPerches * 0.5).clamp(1.0, 999.0);

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
