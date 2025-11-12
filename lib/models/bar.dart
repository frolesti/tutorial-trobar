import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Bar extends Equatable {
  final String id;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  
  // Propietari
  final String? ownerId;
  final String? ownerEmail;
  
  // Verificació
  final bool isActive;
  final bool isPendingApproval;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? nif;
  
  // Característiques
  final List<String> amenities;
  final int capacity;
  final bool hasFood;
  final bool hasParking;
  
  // Partits
  final List<Match> todaysMatches;
  
  // Metadata
  final double rating;
  final int reviewCount;
  final List<String> photoUrls;
  final String? website;
  final String? googlePlaceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bar({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.ownerId,
    this.ownerEmail,
    this.isActive = false,
    this.isPendingApproval = true,
    this.approvedBy,
    this.approvedAt,
    this.nif,
    this.amenities = const [],
    this.capacity = 0,
    this.hasFood = false,
    this.hasParking = false,
    this.todaysMatches = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.photoUrls = const [],
    this.website,
    this.googlePlaceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  factory Bar.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bar(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      postalCode: data['postalCode'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      phoneNumber: data['phoneNumber'] ?? '',
      ownerId: data['ownerId'],
      ownerEmail: data['ownerEmail'],
      isActive: data['isActive'] ?? false,
      isPendingApproval: data['isPendingApproval'] ?? true,
      approvedBy: data['approvedBy'],
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
      nif: data['nif'],
      amenities: List<String>.from(data['amenities'] ?? []),
      capacity: data['capacity'] ?? 0,
      hasFood: data['hasFood'] ?? false,
      hasParking: data['hasParking'] ?? false,
      todaysMatches: (data['todaysMatches'] as List<dynamic>?)
          ?.map((m) => Match.fromMap(m as Map<String, dynamic>))
          .toList() ?? const [],
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      website: data['website'],
      googlePlaceId: data['googlePlaceId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'isActive': isActive,
      'isPendingApproval': isPendingApproval,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'nif': nif,
      'amenities': amenities,
      'capacity': capacity,
      'hasFood': hasFood,
      'hasParking': hasParking,
      'todaysMatches': todaysMatches.map((m) => m.toMap()).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
      'photoUrls': photoUrls,
      'website': website,
      'googlePlaceId': googlePlaceId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}

class Match extends Equatable {
  final String homeTeam;
  final String awayTeam;
  final DateTime dateTime;
  final String competition;
  final String? tvChannel;

  const Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    required this.competition,
    this.tvChannel,
  });

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      competition: map['competition'] ?? '',
      tvChannel: map['tvChannel'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'dateTime': Timestamp.fromDate(dateTime),
      'competition': competition,
      'tvChannel': tvChannel,
    };
  }

  @override
  List<Object?> get props => [homeTeam, awayTeam, dateTime];
}