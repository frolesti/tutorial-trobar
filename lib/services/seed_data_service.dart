import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bar.dart';

class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedBars() async {
    final barsCollection = _firestore.collection('bars');

    final snapshot = await barsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    
    final bars = [
      // BAR 1: ACTIU amb partit avui
      Bar(
        id: '',
        name: 'Bar Mut',
        address: 'Carrer de Pau Claris, 192',
        city: 'Barcelona',
        postalCode: '08009',
        latitude: 41.3932,
        longitude: 2.1649,
        phoneNumber: '+34932174338',
        isActive: true,
        isPendingApproval: false,
        approvedBy: 'admin_seed',
        approvedAt: now,
        nif: 'B12345678',
        amenities: const ['TV 4K', 'Terrassa', 'WiFi', 'Aire condicionat'],
        capacity: 80,
        hasFood: true,
        hasParking: false,
        rating: 4.5,
        reviewCount: 127,
        photoUrls: const [],
        website: 'https://www.barmut.com',
        todaysMatches: [
          Match(
            homeTeam: 'FC Barcelona',
            awayTeam: 'Real Madrid',
            dateTime: now.add(const Duration(hours: 3)),
            competition: 'La Liga',
            tvChannel: 'Movistar LaLiga',
          ),
        ],
      ),

      // BAR 2: ACTIU amb múltiples partits
      Bar(
        id: '',
        name: 'El Nacional',
        address: 'Passeig de Gràcia, 24',
        city: 'Barcelona',
        postalCode: '08007',
        latitude: 41.3865,
        longitude: 2.1694,
        phoneNumber: '+34933181730',
        isActive: true,
        isPendingApproval: false,
        approvedBy: 'admin_seed',
        approvedAt: now,
        nif: 'B23456789',
        amenities: const ['Múltiples pantalles', 'Restaurant', 'WiFi', 'Reserva taules'],
        capacity: 150,
        hasFood: true,
        hasParking: true,
        rating: 4.3,
        reviewCount: 543,
        photoUrls: const [],
        todaysMatches: [
          Match(
            homeTeam: 'Manchester United',
            awayTeam: 'Arsenal',
            dateTime: now.add(const Duration(hours: 5)),
            competition: 'Premier League',
            tvChannel: 'DAZN',
          ),
          Match(
            homeTeam: 'PSG',
            awayTeam: 'Marseille',
            dateTime: now.add(const Duration(hours: 8)),
            competition: 'Ligue 1',
            tvChannel: 'beIN Sports',
          ),
        ],
      ),

      // BAR 3: ACTIU
      Bar(
        id: '',
        name: 'Moritz',
        address: 'Ronda de Sant Antoni, 41',
        city: 'Barcelona',
        postalCode: '08011',
        latitude: 41.3823,
        longitude: 2.1656,
        phoneNumber: '+34933250650',
        isActive: true,
        isPendingApproval: false,
        approvedBy: 'admin_seed',
        approvedAt: now,
        nif: 'B34567890',
        amenities: const ['Cervesa artesana', 'TV HD', 'Terrassa gran'],
        capacity: 120,
        hasFood: true,
        hasParking: false,
        rating: 4.2,
        reviewCount: 234,
        photoUrls: const [],
        todaysMatches: [
          Match(
            homeTeam: 'Liverpool',
            awayTeam: 'Chelsea',
            dateTime: now.add(const Duration(hours: 2)),
            competition: 'Premier League',
            tvChannel: 'DAZN',
          ),
        ],
      ),

      // BAR 4: PENDENT D'APROVACIÓ
      Bar(
        id: '',
        name: 'La Cervecita Nuestra',
        address: 'Carrer de Sant Joaquim, 6',
        city: 'Barcelona',
        postalCode: '08012',
        latitude: 41.3975,
        longitude: 2.1583,
        phoneNumber: '+34934151364',
        ownerId: 'demo_owner_1',
        ownerEmail: 'propietari1@example.com',
        isActive: false,
        isPendingApproval: true,
        nif: 'B45678901',
        amenities: const ['Ambient acollidor', 'Cerveses especials', 'WiFi'],
        capacity: 40,
        hasFood: false,
        hasParking: false,
        rating: 0,
        reviewCount: 0,
        photoUrls: const [],
        todaysMatches: const [],
      ),

      // BAR 5: ACTIU amb partit
      Bar(
        id: '',
        name: 'Ovella Negra',
        address: 'Carrer de Sitges, 5',
        city: 'Barcelona',
        postalCode: '08001',
        latitude: 41.3811,
        longitude: 2.1740,
        phoneNumber: '+34933177585',
        isActive: true,
        isPendingApproval: false,
        approvedBy: 'admin_seed',
        approvedAt: now,
        nif: 'B56789012',
        amenities: const ['Gran capacitat', 'Terrassa', 'Preu econòmic', 'WiFi'],
        capacity: 200,
        hasFood: true,
        hasParking: false,
        rating: 4.1,
        reviewCount: 312,
        photoUrls: const [],
        todaysMatches: [
          Match(
            homeTeam: 'Inter Milan',
            awayTeam: 'AC Milan',
            dateTime: now.add(const Duration(hours: 6)),
            competition: 'Serie A',
            tvChannel: 'Movistar+',
          ),
        ],
      ),

      // BAR 6: ACTIU
      Bar(
        id: '',
        name: 'Belushi\'s Barcelona',
        address: 'Carrer de Bergara, 3',
        city: 'Barcelona',
        postalCode: '08002',
        latitude: 41.3863,
        longitude: 2.1706,
        phoneNumber: '+34933014082',
        isActive: true,
        isPendingApproval: false,
        approvedBy: 'admin_seed',
        approvedAt: now,
        nif: 'B67890123',
        amenities: const ['Ambient internacional', 'Múltiples pantalles', 'Happy hour', 'WiFi'],
        capacity: 100,
        hasFood: true,
        hasParking: false,
        rating: 4.0,
        reviewCount: 445,
        photoUrls: const [],
        todaysMatches: [
          Match(
            homeTeam: 'Bayern Munich',
            awayTeam: 'Borussia Dortmund',
            dateTime: now.add(const Duration(hours: 4)),
            competition: 'Bundesliga',
            tvChannel: 'Movistar+',
          ),
        ],
      ),

      // BAR 7: PENDENT D'APROVACIÓ
      Bar(
        id: '',
        name: 'Bar Esportiu Cronopios',
        address: 'Carrer de Bailèn, 129',
        city: 'Barcelona',
        postalCode: '08009',
        latitude: 41.3978,
        longitude: 2.1695,
        phoneNumber: '+34934560000',
        ownerId: 'demo_owner_2',
        ownerEmail: 'propietari2@example.com',
        isActive: false,
        isPendingApproval: true,
        nif: 'B78901234',
        amenities: const ['TV Gran', 'Terrassa', 'Bar esportiu'],
        capacity: 60,
        hasFood: true,
        hasParking: false,
        rating: 0,
        reviewCount: 0,
        photoUrls: const [],
        todaysMatches: const [],
      ),
    ];

    for (var bar in bars) {
      await barsCollection.add(bar.toFirestore());
    }
  }

  Future<void> clearAllBars() async {
    final snapshot = await _firestore.collection('bars').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}