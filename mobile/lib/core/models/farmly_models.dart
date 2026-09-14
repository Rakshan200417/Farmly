enum UserRole { farmer, buyer, shop, admin }

class UserModel {
  final String id;
  final String name;
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
    this.marketName = 'Dambulla Economic Centre',
    required this.iconType,
  });
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
