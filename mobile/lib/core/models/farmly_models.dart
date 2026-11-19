enum UserRole { farmer, buyer, shop, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String district;
  final String locationName;
  final double lat;
  final double lng;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final String? profilePhoto;

  UserModel({
    required this.id,
    required this.name,
    this.email = '',
    required this.phone,
    required this.role,
    required this.district,
    required this.locationName,
    required this.lat,
    required this.lng,
    this.rating = 4.8,
    this.reviewsCount = 112,
    this.isVerified = true,
    this.profilePhoto,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? district,
    String? locationName,
    double? lat,
    double? lng,
    double? rating,
    int? reviewsCount,
    bool? isVerified,
    String? profilePhoto,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      district: district ?? this.district,
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isVerified: isVerified ?? this.isVerified,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserRole parseRole(String? r) {
      switch (r?.toUpperCase()) {
        case 'FARMER':
          return UserRole.farmer;
        case 'BUYER':
          return UserRole.buyer;
        case 'SHOP':
          return UserRole.shop;
        case 'ADMIN':
          return UserRole.admin;
        default:
          return UserRole.farmer;
      }
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Farmer',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: parseRole(json['role']?.toString()),
      district: json['district']?.toString() ?? 'Anuradhapura',
      locationName: json['locationName']?.toString() ?? 'Anuradhapura, Sri Lanka',
      lat: (json['latitude'] as num?)?.toDouble() ?? 8.3114,
      lng: (json['longitude'] as num?)?.toDouble() ?? 80.4037,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 112,
      isVerified: json['isVerified'] != false,
      profilePhoto: json['profilePicture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name.toUpperCase(),
      'district': district,
      'locationName': locationName,
      'latitude': lat,
      'longitude': lng,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isVerified': isVerified,
    };
  }
}

class CropPriceModel {
  final String id;
  final String cropName;
  final String category; // Grains, Vegetables, Fruits, Spices
  final double pricePerKg;
  final double changePercent;
  final bool isPositive;
  final List<double> sparklinePoints; // 7-day points
  final String marketName;
  final String iconType;

  CropPriceModel({
    required this.id,
    required this.cropName,
    required this.category,
    required this.pricePerKg,
    required this.changePercent,
    required this.isPositive,
    required this.sparklinePoints,
    this.marketName = 'Dambulla Dedicated Economic Centre',
    required this.iconType,
  });

  factory CropPriceModel.fromJson(Map<String, dynamic> json) {
    List<double> points = [];
    if (json['historicalTrend'] != null) {
      points = json['historicalTrend']
          .toString()
          .split(',')
          .map((s) => double.tryParse(s.trim()) ?? 0.0)
          .where((d) => d > 0)
          .toList();
    }
    if (points.isEmpty) points = [100, 102, 105, 108, 110];

    String crop = json['cropName']?.toString() ?? '';
    String icon = 'grain';
    String lower = crop.toLowerCase();
    if (lower.contains('onion')) {
      icon = 'onion';
    } else if (lower.contains('tomato')) {
      icon = 'tomato';
    } else if (lower.contains('chili')) {
      icon = 'chili';
    } else if (lower.contains('carrot')) {
      icon = 'carrot';
    } else if (lower.contains('bean')) {
      icon = 'bean';
    }

    return CropPriceModel(
      id: json['id']?.toString() ?? '',
      cropName: crop,
      category: json['category']?.toString() ?? 'Vegetables',
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      changePercent: (json['changePercent'] as num?)?.toDouble() ?? 0.0,
      isPositive: json['isPositive'] != false,
      sparklinePoints: points,
      marketName: json['marketName']?.toString() ?? 'Dambulla Dedicated Economic Centre',
      iconType: icon,
    );
  }
}

class ProduceListingModel {
  final String id;
  final String cropName;
  final String variety;
  final String category;
  final double pricePerKg;
  final double availableQty;
  final double minOrderQty;
  final String unit;
  final String qualityGrade; // Grade A, Organic, etc.
  final String harvestDate;
  final String location;
  final double distanceKm;
  final String farmerName;
  final double farmerRating;
  final int farmerReviewCount;
  final bool isFarmerVerified;
  final String farmerPhone;
  final String imageUrl;
  final String description;

  String get farmerId => farmerPhone.isNotEmpty ? farmerPhone : farmerName.toLowerCase().replaceAll(' ', '_');

  ProduceListingModel({
    required this.id,
    required this.cropName,
    required this.variety,
    required this.category,
    required this.pricePerKg,
    required this.availableQty,
    required this.minOrderQty,
    this.unit = 'kg',
    required this.qualityGrade,
    required this.harvestDate,
    required this.location,
    required this.distanceKm,
    required this.farmerName,
    required this.farmerRating,
    required this.farmerReviewCount,
    this.isFarmerVerified = true,
    required this.farmerPhone,
    required this.imageUrl,
    required this.description,
  });

  factory ProduceListingModel.fromJson(Map<String, dynamic> json) {
    return ProduceListingModel(
      id: json['id']?.toString() ?? '',
      cropName: json['cropName']?.toString() ?? '',
      variety: json['variety']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Vegetables',
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      availableQty: (json['availableQty'] as num?)?.toDouble() ?? 0.0,
      minOrderQty: (json['minOrderQty'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit']?.toString() ?? 'kg',
      qualityGrade: json['qualityGrade']?.toString() ?? 'Grade A',
      harvestDate: json['harvestDate']?.toString() ?? 'Today',
      location: json['location']?.toString() ?? 'Sri Lanka',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 12.5,
      farmerName: json['farmerName']?.toString() ?? 'Local Farmer',
      farmerRating: (json['farmerRating'] as num?)?.toDouble() ?? 4.8,
      farmerReviewCount: (json['farmerReviewCount'] as num?)?.toInt() ?? 45,
      isFarmerVerified: json['isFarmerVerified'] != false,
      farmerPhone: json['farmerPhone']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty && !id.startsWith('list-')) 'id': id,
      'farmerName': farmerName,
      'farmerPhone': farmerPhone,
      'cropName': cropName,
      'variety': variety,
      'category': category,
      'pricePerKg': pricePerKg,
      'availableQty': availableQty,
      'minOrderQty': minOrderQty,
      'unit': unit,
      'qualityGrade': qualityGrade,
      'harvestDate': harvestDate,
      'location': location,
      'latitude': 8.3114,
      'longitude': 80.4037,
      'imageUrl': imageUrl,
      'description': description,
      'status': 'ACTIVE',
    };
  }
}

class TreatmentItem {
  final String name;
  final String instruction;
  final String dosagePerLiter;
  final double standardPerchDosageGrams;

  TreatmentItem({
    required this.name,
    required this.instruction,
    required this.dosagePerLiter,
    required this.standardPerchDosageGrams,
  });
}

class DiagnosisModel {
  final String id;
  final String cropName;
  final String diseaseName;
  final String scientificName;
  final String severity; // MILD, MODERATE, SEVERE
  final double confidencePercent;
  final String description;
  final String warningBanner;
  final List<TreatmentItem> organicTreatments;
  final List<TreatmentItem> chemicalTreatments;
  final String? leafPhotoUrl;

  DiagnosisModel({
    required this.id,
    required this.cropName,
    required this.diseaseName,
    required this.scientificName,
    required this.severity,
    required this.confidencePercent,
    required this.description,
    required this.warningBanner,
    required this.organicTreatments,
    required this.chemicalTreatments,
    this.leafPhotoUrl,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    List<TreatmentItem> org = [];
    if (json['organicTreatment'] != null) {
      String text = json['organicTreatment'].toString();
      org.add(TreatmentItem(
        name: text.split(';').first,
        instruction: text,
        dosagePerLiter: '5ml / Liter',
        standardPerchDosageGrams: (json['standardPerchGrams'] as num?)?.toDouble() ?? 15.0,
      ));
    }
    List<TreatmentItem> chem = [];
    if (json['chemicalTreatment'] != null) {
      String text = json['chemicalTreatment'].toString();
      chem.add(TreatmentItem(
        name: text.split(';').first,
        instruction: text,
        dosagePerLiter: '2.5g / Liter',
        standardPerchDosageGrams: (json['standardPerchGrams'] as num?)?.toDouble() ?? 15.0,
      ));
    }

    return DiagnosisModel(
      id: json['id']?.toString() ?? 'diag-01',
      cropName: json['cropName']?.toString() ?? 'Paddy (Rice)',
      diseaseName: json['diseaseName']?.toString() ?? 'Bacterial Leaf Blight',
      scientificName: json['scientificName']?.toString() ?? 'Xanthomonas oryzae pv. oryzae',
      severity: json['severity']?.toString() ?? 'SEVERE',
      confidencePercent: (json['confidencePercent'] as num?)?.toDouble() ?? 88.0,
      description: json['description']?.toString() ?? '',
      warningBanner: json['warningBanner']?.toString() ?? 'Active advisory reported in your agricultural zone.',
      organicTreatments: org,
      chemicalTreatments: chem,
      leafPhotoUrl: json['leafPhotoUrl']?.toString(),
    );
  }
}

class ShopProductItem {
  final String name;
  final String category;
  final double price;
  final String unit;
  final String stockStatus; // in_stock, low_stock, out_of_stock

  ShopProductItem({
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stockStatus,
  });

  factory ShopProductItem.fromJson(Map<String, dynamic> json) {
    return ShopProductItem(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit']?.toString() ?? 'pack',
      stockStatus: json['stockStatus']?.toString() ?? 'in_stock',
    );
  }
}

class ShopModel {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final String phone;
  final double lat;
  final double lng;
  final List<String> tags;
  final List<ShopProductItem> products;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.rating,
    required this.reviewsCount,
    this.isVerified = true,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.tags,
    required this.products,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    List<ShopProductItem> prods = [];
    if (json['products'] is List) {
      prods = (json['products'] as List)
          .map((p) => ShopProductItem.fromJson(p as Map<String, dynamic>))
          .toList();
    }
    List<String> tagList = [];
    if (json['tags'] != null) {
      tagList = json['tags'].toString().split(',').map((t) => t.trim()).toList();
    }
    return ShopModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 2.8,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 142,
      isVerified: json['isVerified'] != false,
      phone: json['phone']?.toString() ?? '',
      lat: (json['latitude'] as num?)?.toDouble() ?? 7.8731,
      lng: (json['longitude'] as num?)?.toDouble() ?? 80.6511,
      tags: tagList,
      products: prods,
    );
  }
}

class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? attachedContext;

  AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedContext,
  });
}

class ChatMessageModel {
  final int id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String recipientName;
  final String content;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName']?.toString() ?? 'User',
      recipientId: json['recipientId']?.toString() ?? '',
      recipientName: json['recipientName']?.toString() ?? 'User',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ConversationItemModel {
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationItemModel({
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ConversationItemModel.fromJson(Map<String, dynamic> json) {
    return ConversationItemModel(
      otherUserId: json['otherUserId']?.toString() ?? '',
      otherUserName: json['otherUserName']?.toString() ?? 'User',
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime'].toString()) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}

