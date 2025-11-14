const admin = require('firebase-admin');
const serviceAccount = require('../../serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// ========================================
// FUNCIÓ: Obtenir data d'avui amb hora específica
// ========================================
function getTodayAt(hours, minutes = 0) {
  const today = new Date();
  today.setHours(hours, minutes, 0, 0);
  return admin.firestore.Timestamp.fromDate(today);
}

// ========================================
// COL·LECCIÓ: users
// ========================================
const users = [
  {
    id: 'admin-trobar',
    email: 'admin@trobar.com',
    role: 'admin',
    displayName: 'Admin Trobar',
    createdAt: admin.firestore.Timestamp.now()
  },
  {
    id: 'propietari1',
    email: 'propietari1@example.com',
    role: 'bar_owner',
    ownedBarId: null, // S'assignarà després
    displayName: 'Joan García',
    createdAt: admin.firestore.Timestamp.now()
  },
  {
    id: 'user-example',
    email: 'user@example.com',
    role: 'user',
    displayName: 'Maria López',
    createdAt: admin.firestore.Timestamp.now()
  }
];

// ========================================
// COL·LECCIÓ: match_schedule (amb dates d'avui)
// ========================================
function getMatchSchedule() {
  return [
    {
      id: 'match-barca-madrid',
      homeTeam: 'FC Barcelona',
      awayTeam: 'Real Madrid',
      dateTime: getTodayAt(18, 30), // 18:30 avui
      competition: 'La Liga',
      tvChannels: ['Movistar LaLiga', 'DAZN'],
      isPopular: true,
      league: 'spain',
      season: '2024-2025'
    },
    {
      id: 'match-manu-arsenal',
      homeTeam: 'Manchester United',
      awayTeam: 'Arsenal',
      dateTime: getTodayAt(20, 30), // 20:30 avui
      competition: 'Premier League',
      tvChannels: ['DAZN'],
      isPopular: true,
      league: 'england',
      season: '2024-2025'
    },
    {
      id: 'match-liverpool-chelsea',
      homeTeam: 'Liverpool',
      awayTeam: 'Chelsea',
      dateTime: getTodayAt(16, 0), // 16:00 avui
      competition: 'Premier League',
      tvChannels: ['DAZN'],
      isPopular: true,
      league: 'england',
      season: '2024-2025'
    },
    {
      id: 'match-bayern-dortmund',
      homeTeam: 'Bayern Munich',
      awayTeam: 'Borussia Dortmund',
      dateTime: getTodayAt(19, 30), // 19:30 avui
      competition: 'Bundesliga',
      tvChannels: ['Movistar+'],
      isPopular: true,
      league: 'germany',
      season: '2024-2025'
    },
    {
      id: 'match-inter-milan',
      homeTeam: 'Inter Milan',
      awayTeam: 'AC Milan',
      dateTime: getTodayAt(21, 0), // 21:00 avui
      competition: 'Serie A',
      tvChannels: ['Movistar+'],
      isPopular: true,
      league: 'italy',
      season: '2024-2025'
    }
  ];
}

// ========================================
// COL·LECCIÓ: bars (amb partits actualitzats)
// ========================================
function getBars() {
  return [
    {
      id: 'bar-mut',
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
      approvedAt: admin.firestore.Timestamp.now(),
      nif: 'B12345678',
      amenities: ['TV 4K', 'Terrassa', 'WiFi', 'Aire condicionat'],
      capacity: 80,
      hasFood: true,
      hasParking: false,
      rating: 4.5,
      reviewCount: 127,
      photoUrls: [],
      website: 'https://www.barmut.com',
      todaysMatches: [
        {
          homeTeam: 'FC Barcelona',
          awayTeam: 'Real Madrid',
          dateTime: getTodayAt(18, 30),
          competition: 'La Liga',
          tvChannel: 'Movistar LaLiga'
        }
      ],
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now()
    },
    {
      id: 'el-nacional',
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
      approvedAt: admin.firestore.Timestamp.now(),
      nif: 'B23456789',
      amenities: ['Múltiples pantalles', 'Restaurant', 'WiFi', 'Reserva taules'],
      capacity: 150,
      hasFood: true,
      hasParking: true,
      rating: 4.3,
      reviewCount: 543,
      photoUrls: [],
      todaysMatches: [
        {
          homeTeam: 'Manchester United',
          awayTeam: 'Arsenal',
          dateTime: getTodayAt(20, 30),
          competition: 'Premier League',
          tvChannel: 'DAZN'
        }
      ],
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now()
    },
    {
      id: 'moritz',
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
      approvedAt: admin.firestore.Timestamp.now(),
      nif: 'B34567890',
      amenities: ['Cervesa artesana', 'TV HD', 'Terrassa gran'],
      capacity: 120,
      hasFood: true,
      hasParking: false,
      rating: 4.2,
      reviewCount: 234,
      photoUrls: [],
      todaysMatches: [
        {
          homeTeam: 'Liverpool',
          awayTeam: 'Chelsea',
          dateTime: getTodayAt(16, 0),
          competition: 'Premier League',
          tvChannel: 'DAZN'
        }
      ],
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now()
    },
    {
      id: 'ovella-negra',
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
      approvedAt: admin.firestore.Timestamp.now(),
      nif: 'B56789012',
      amenities: ['Gran capacitat', 'Terrassa', 'Preu econòmic', 'WiFi'],
      capacity: 200,
      hasFood: true,
      hasParking: false,
      rating: 4.1,
      reviewCount: 312,
      photoUrls: [],
      todaysMatches: [
        {
          homeTeam: 'Inter Milan',
          awayTeam: 'AC Milan',
          dateTime: getTodayAt(21, 0),
          competition: 'Serie A',
          tvChannel: 'Movistar+'
        }
      ],
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now()
    },
    {
      id: 'belushis',
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
      approvedAt: admin.firestore.Timestamp.now(),
      nif: 'B67890123',
      amenities: ['Ambient internacional', 'Múltiples pantalles', 'Happy hour', 'WiFi'],
      capacity: 100,
      hasFood: true,
      hasParking: false,
      rating: 4.0,
      reviewCount: 445,
      photoUrls: [],
      todaysMatches: [
        {
          homeTeam: 'Bayern Munich',
          awayTeam: 'Borussia Dortmund',
          dateTime: getTodayAt(19, 30),
          competition: 'Bundesliga',
          tvChannel: 'Movistar+'
        }
      ],
      createdAt: admin.firestore.Timestamp.now(),
      updatedAt: admin.firestore.Timestamp.now()
    }
  ];
}

async function seedDatabase() {
  console.log('🚀 Iniciant seed complet de la base de dades...\n');
  console.log(`📅 Data actual: ${new Date().toLocaleDateString('ca-ES')}\n`);
  
  try {
    // Obtenir dades dinàmiques
    const matchSchedule = getMatchSchedule();
    const bars = getBars();
    
    // 1. Crear/Actualitzar usuaris (REPLACE complert)
    console.log('👥 Creant/Actualitzant usuaris...');
    for (const user of users) {
      const { id, ...userData } = user;
      await db.collection('users').doc(id).set(userData); // Sense merge: reemplaça tot
      console.log(`  ✅ ${user.email} (${user.role})`);
    }
    
    // 2. Crear/Actualitzar calendari de partits (REPLACE complert)
    console.log('\n⚽ Creant/Actualitzant calendari de partits per avui...');
    for (const match of matchSchedule) {
      const { id, ...matchData } = match;
      await db.collection('match_schedule').doc(id).set(matchData); // Sense merge: reemplaça tot
      const dateTime = match.dateTime.toDate();
      console.log(`  ✅ ${match.homeTeam} vs ${match.awayTeam} - ${dateTime.toLocaleTimeString('ca-ES', { hour: '2-digit', minute: '2-digit' })}`);
    }
    
    // 3. Crear/Actualitzar bars (REPLACE complert)
    console.log('\n🍺 Creant/Actualitzant bars...');
    for (const bar of bars) {
      const { id, ...barData } = bar;
      await db.collection('bars').doc(id).set(barData); // Sense merge: reemplaça tot
      console.log(`  ✅ ${bar.name} (${bar.todaysMatches.length} partit${bar.todaysMatches.length !== 1 ? 's' : ''})`);
    }
    
    console.log('\n🎉 Base de dades actualitzada amb èxit!');
    console.log(`\n📊 Resum:`);
    console.log(`   - Usuaris: ${users.length}`);
    console.log(`   - Partits (avui): ${matchSchedule.length}`);
    console.log(`   - Bars: ${bars.length}`);
    console.log(`\n💡 Tots els partits han estat configurats per a avui, ${new Date().toLocaleDateString('ca-ES')}`);
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

seedDatabase();