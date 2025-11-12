import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bar.dart';
import 'dart:math';

class BarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Cerca bars ACTIUS amb partit avui en un radi determinat
  Future<List<Bar>> getNearbyBarsWithMatches({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      // ⬇️ IMPORTANT: Només bars actius
      final snapshot = await _firestore
          .collection('bars')
          .where('isActive', isEqualTo: true)
          .get();

      final bars = snapshot.docs
          .map((doc) => Bar.fromFirestore(doc))
          .where((bar) {
            final distance = _calculateDistance(
              latitude,
              longitude,
              bar.latitude,
              bar.longitude,
            );
            
            final hasMatchToday = bar.todaysMatches.any((match) {
              return match.dateTime.isAfter(today) &&
                     match.dateTime.isBefore(tomorrow);
            });
            
            return distance <= radiusKm && hasMatchToday;
          })
          .toList();

      bars.sort((a, b) {
        final distA = _calculateDistance(latitude, longitude, a.latitude, a.longitude);
        final distB = _calculateDistance(latitude, longitude, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });

      return bars;
    } catch (e) {
      return [];
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * (pi / 180.0);

  Future<void> addBar(Bar bar) async {
    await _firestore.collection('bars').add(bar.toFirestore());
  }

  Future<void> updateBar(Bar bar) async {
    await _firestore.collection('bars').doc(bar.id).update(bar.toFirestore());
  }

  Future<void> deleteBar(String barId) async {
    await _firestore.collection('bars').doc(barId).delete();
  }
}