import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bar.dart';

/// Servei per gestionar les dades de Firebase.
/// IMPORTANT: Les dades de seed es creen amb el script Node.js (lib/scripts/seed_firestore.js)
/// Aquest servei només proporciona mètodes auxiliars per llegir i gestionar les dades.
class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Comprova si existeixen bars a la base de dades
  Future<bool> hasBars() async {
    final snapshot = await _firestore.collection('bars').limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  /// Obté tots els bars actius de Firebase
  Future<List<Bar>> getActiveBars() async {
    final snapshot = await _firestore
        .collection('bars')
        .where('isActive', isEqualTo: true)
        .get();
    
    return snapshot.docs.map((doc) => Bar.fromFirestore(doc)).toList();
  }

  /// Obté tots els bars (actius i inactius)
  Future<List<Bar>> getAllBars() async {
    final snapshot = await _firestore.collection('bars').get();
    return snapshot.docs.map((doc) => Bar.fromFirestore(doc)).toList();
  }

  /// Obté bars que estan pendents d'aprovació
  Future<List<Bar>> getPendingBars() async {
    final snapshot = await _firestore
        .collection('bars')
        .where('isPendingApproval', isEqualTo: true)
        .get();
    
    return snapshot.docs.map((doc) => Bar.fromFirestore(doc)).toList();
  }

  /// Obté bars amb partits avui
  Future<List<Bar>> getBarsWithMatchesToday() async {
    final snapshot = await _firestore
        .collection('bars')
        .where('isActive', isEqualTo: true)
        .get();
    
    final bars = snapshot.docs.map((doc) => Bar.fromFirestore(doc)).toList();
    
    // Filtrar bars que tenen partits avui
    return bars.where((bar) => bar.todaysMatches.isNotEmpty).toList();
  }

  /// Obté un bar específic per ID
  Future<Bar?> getBarById(String barId) async {
    final doc = await _firestore.collection('bars').doc(barId).get();
    
    if (!doc.exists) {
      return null;
    }
    
    return Bar.fromFirestore(doc);
  }

  /// Stream de bars actius (per actualitzacions en temps real)
  Stream<List<Bar>> watchActiveBars() {
    return _firestore
        .collection('bars')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Bar.fromFirestore(doc)).toList());
  }

  /// Stream d'un bar específic
  Stream<Bar?> watchBar(String barId) {
    return _firestore
        .collection('bars')
        .doc(barId)
        .snapshots()
        .map((doc) => doc.exists ? Bar.fromFirestore(doc) : null);
  }

  /// Esborra tots els bars (utilitzar amb precaució!)
  Future<void> clearAllBars() async {
    final snapshot = await _firestore.collection('bars').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Esborra tots els partits programats (utilitzar amb precaució!)
  Future<void> clearAllMatches() async {
    final snapshot = await _firestore.collection('match_schedule').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Esborra tots els usuaris (utilitzar amb precaució!)
  Future<void> clearAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Esborra totes les dades de la base de dades (utilitzar amb precaució!)
  Future<void> clearAllData() async {
    await Future.wait([
      clearAllBars(),
      clearAllMatches(),
      clearAllUsers(),
    ]);
  }

  /// Verifica l'estat de les dades a la base de dades
  Future<Map<String, dynamic>> getDatabaseStatus() async {
    final barsSnapshot = await _firestore.collection('bars').get();
    final matchesSnapshot = await _firestore.collection('match_schedule').get();
    final usersSnapshot = await _firestore.collection('users').get();

    final activeBars = barsSnapshot.docs
        .where((doc) => (doc.data()['isActive'] ?? false) == true)
        .length;
    
    final pendingBars = barsSnapshot.docs
        .where((doc) => (doc.data()['isPendingApproval'] ?? false) == true)
        .length;

    return {
      'totalBars': barsSnapshot.docs.length,
      'activeBars': activeBars,
      'pendingBars': pendingBars,
      'totalMatches': matchesSnapshot.docs.length,
      'totalUsers': usersSnapshot.docs.length,
    };
  }
}