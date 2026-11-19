import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/farmly_models.dart';

class ApiService {
  // Use localhost:8080 for Chrome Web & Windows Desktop.
  // For Android Emulator, use 10.0.2.2:8080.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8081/api/v1';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8081/api/v1';
    }
    return 'http://localhost:8081/api/v1';
  }

  // 1. Email & Password Authentication (Sign Up)
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? district,
    String? phone,
  }) async {
    try {
      final roleStr = role.name.toUpperCase();
      final url = Uri.parse('$baseUrl/auth/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'role': roleStr,
          'district': district ?? 'Anuradhapura',
          'phone': phone?.trim() ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        final token = data['token']?.toString() ?? '';
        return {'success': true, 'user': user, 'token': token};
      } else {
        final err = jsonDecode(utf8.decode(response.bodyBytes));
        return {'success': false, 'error': err['error'] ?? 'Sign up failed'};
      }
    } catch (e) {
      debugPrint('signUp error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // 1b. Email & Password Authentication (Sign In)
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/signin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        final token = data['token']?.toString() ?? '';
        return {'success': true, 'user': user, 'token': token};
      } else {
        final err = jsonDecode(utf8.decode(response.bodyBytes));
        return {'success': false, 'error': err['error'] ?? 'Invalid email or password'};
      }
    } catch (e) {
      debugPrint('signIn error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // 1c. Update User Profile
  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? district,
    String? locationName,
    String? profilePicture,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/profile/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (name != null) 'name': name.trim(),
          if (phone != null) 'phone': phone.trim(),
          if (district != null) 'district': district.trim(),
          if (locationName != null) 'locationName': locationName.trim(),
          if (profilePicture != null) 'profilePicture': profilePicture,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'error': 'Failed to update profile'};
      }
    } catch (e) {
      debugPrint('updateProfile error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Legacy Phone Login & Registration
  static Future<Map<String, dynamic>> loginWithPhone({
    required String phone,
    String? name,
    UserRole? role,
    String? district,
  }) async {
    try {
      final roleStr = (role ?? UserRole.farmer).name.toUpperCase();
      final url = Uri.parse('$baseUrl/auth/phone-login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'name': (name != null && name.trim().isNotEmpty) ? name.trim() : 'Farmer ($phone)',
          'role': roleStr,
          'district': district ?? 'Anuradhapura',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        final token = data['token']?.toString() ?? '';
        return {'success': true, 'user': user, 'token': token};
      } else {
        return {'success': false, 'error': 'Server error ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      debugPrint('loginWithPhone error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // 2. Fetch Real Wholesale Market Prices
  static Future<List<CropPriceModel>> getPrices({String? category}) async {
    try {
      String query = '';
      if (category != null && category.isNotEmpty && category != 'All') {
        query = '?category=${Uri.encodeComponent(category)}';
      }
      final url = Uri.parse('$baseUrl/prices$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list.map((item) => CropPriceModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('getPrices error: $e');
    }
    return [];
  }

  // 3. Fetch Real Marketplace Produce Listings
  static Future<List<ProduceListingModel>> getListings({String? category, String? query}) async {
    try {
      String params = '';
      if (category != null && category.isNotEmpty && category != 'All') {
        params = '?category=${Uri.encodeComponent(category)}';
      }
      if (query != null && query.trim().isNotEmpty) {
        params += '${params.isEmpty ? '?' : '&'}query=${Uri.encodeComponent(query.trim())}';
      }
      final url = Uri.parse('$baseUrl/listings$params');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list.map((item) => ProduceListingModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('getListings error: $e');
    }
    return [];
  }

  // 4. Create & Save Real Produce Listing into XAMPP MySQL
  static Future<ProduceListingModel?> createListing(ProduceListingModel listing) async {
    try {
      final url = Uri.parse('$baseUrl/listings');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(listing.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ProduceListingModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('createListing error: $e');
    }
    return null;
  }

  // 5. Fetch Real Agro-Input Shops & Treatment Inventory
  static Future<List<ShopModel>> getShops({double lat = 8.3114, double lng = 80.4037}) async {
    try {
      final url = Uri.parse('$baseUrl/shops');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list.map((item) => ShopModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('getShops error: $e');
    }
    return [];
  }

  // 6. Real Crop Pathology Disease Diagnosis
  static Future<DiagnosisModel?> scanCrop(String cropName, {String? imageBase64}) async {
    try {
      final url = Uri.parse('$baseUrl/diagnosis/scan');
      final Map<String, dynamic> payload = {'cropName': cropName};
      if (imageBase64 != null) payload['image'] = imageBase64;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return DiagnosisModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('scanCrop error: $e');
    }
    return null;
  }

  // 7. Calculate Chemical & Organic Dosage
  static Future<Map<String, String>?> calculateDosage({
    required double landAmount,
    required bool isAcres,
    required double perchGrams,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/diagnosis/dosage-calc');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'landAmount': landAmount,
          'isAcres': isAcres,
          'perchGrams': perchGrams,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'landSummary': data['landSummary']?.toString() ?? '',
          'totalProduct': data['totalProduct']?.toString() ?? '',
          'waterVolume': '${data['waterVolumeLiters']} Liters',
          'sprayTanks': data['sprayTanks']?.toString() ?? '',
        };
      }
    } catch (e) {
      debugPrint('calculateDosage error: $e');
    }
    return null;
  }

  // 8. Chat with Farmly AI Assistant
  static Future<String> chatWithAi(String message, {String? diseaseContext, String? apiKey}) async {
    try {
      final url = Uri.parse('$baseUrl/ai/assistant/chat');
      final Map<String, dynamic> payload = {'message': message};
      if (diseaseContext != null) payload['diseaseContext'] = diseaseContext;
      if (apiKey != null && apiKey.trim().isNotEmpty) payload['apiKey'] = apiKey.trim();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return data['reply']?.toString() ?? 'No response received.';
      }
    } catch (e) {
      debugPrint('chatWithAi error: $e');
    }
    return 'Could not connect to Farmly AI service. Please ensure the backend is running.';
  }

  // 9. Real Messaging & Chat Endpoints
  static Future<List<ConversationItemModel>> getConversations(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/chat/conversations?userId=${Uri.encodeComponent(userId)}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return list.map((item) => ConversationItemModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('getConversations error: $e');
    }
    return [];
  }

  static Future<List<ChatMessageModel>> getChatHistory(String user1, String user2) async {
    try {
      final url = Uri.parse('$baseUrl/chat/history?user1=${Uri.encodeComponent(user1)}&user2=${Uri.encodeComponent(user2)}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        return list.map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('getChatHistory error: $e');
    }
    return [];
  }

  static Future<ChatMessageModel?> sendChatMessage({
    required String senderId,
    required String senderName,
    required String recipientId,
    required String recipientName,
    required String content,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/chat/send');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': senderId,
          'senderName': senderName,
          'recipientId': recipientId,
          'recipientName': recipientName,
          'content': content,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return ChatMessageModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('sendChatMessage error: $e');
    }
    return null;
  }
}
