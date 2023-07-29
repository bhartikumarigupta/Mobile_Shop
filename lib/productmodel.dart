class Listing {
  final String id;
  final String deviceCondition;
  final String listedBy;
  final String deviceStorage;
  final List<String> images;
  final String defaultImage;
  final String listingLocation;
  final String make;
  final String marketingName;
  final String mobileNumber;
  final String model;
  final bool verified;
  final String status;
  final String listingDate;
  final String deviceRam;
  final String createdAt;
  final String listingId;
  final int listingNumPrice;
  final String listingState;

  Listing({
    required this.id,
    required this.deviceCondition,
    required this.listedBy,
    required this.deviceStorage,
    required this.images,
    required this.defaultImage,
    required this.listingLocation,
    required this.make,
    required this.marketingName,
    required this.mobileNumber,
    required this.model,
    required this.verified,
    required this.status,
    required this.listingDate,
    required this.deviceRam,
    required this.createdAt,
    required this.listingId,
    required this.listingNumPrice,
    required this.listingState,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'],
      deviceCondition: json['deviceCondition'],
      listedBy: json['listedBy'],
      deviceStorage: json['deviceStorage'],
      images:
          List<String>.from(json['images'].map((image) => image['fullImage'])),
      defaultImage: json['defaultImage']['fullImage'],
      listingLocation: json['listingLocation'],
      make: json['make'],
      marketingName: json['marketingName'],
      mobileNumber: json['mobileNumber'],
      model: json['model'],
      verified: json['verified'],
      status: json['status'],
      listingDate: json['listingDate'],
      deviceRam: json['deviceRam'],
      createdAt: json['createdAt'],
      listingId: json['listingId'],
      listingNumPrice: json['listingNumPrice'],
      listingState: json['listingState'],
    );
  }
}
