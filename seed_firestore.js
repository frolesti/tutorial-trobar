const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// ========================================
// COL·LECCIÓ: users
// ========================================
const users = [
  {
    email: 'admin@trobar.com',
    role: 'admin',
    displayName: 'Admin Trobar',
    createdAt: admin.firestore.Timestamp.now()
  },
  {
    email: 'propietari1@example.com',
    role: 'bar_owner',
    ownedBarId: null, // S'assignarà després
    displayName: 'Joan García',
    createdAt: admin.firestore.Timestamp.now()
  },
  {
    email: 'user@example.com',
    role: 'user',
    displayName: 'Maria López',
    createdAt: admin.firestore.Timestamp.now()
  }
];

// ========================================
// COL·LECCIÓ: match_schedule
// ========================================
const matchSchedule = [
  {
    homeTeam: 'FC Barcelona',
    awayTeam: 'Real Madrid',
    dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 3 * 60 * 60 * 1000)),
    competition: 'La Liga',
    tvChannels: ['Movistar LaLiga', 'DAZN'],
    isPopular: true,
    league: 'spain',
    season: '2024-2025'
  },
  {
    homeTeam: 'Manchester United',
    awayTeam: 'Arsenal',
    dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 5 * 60 * 60 * 1000)),
    competition: 'Premier League',
    tvChannels: ['DAZN'],
    isPopular: true,
    league: 'england',
    season: '2024-2025'
  },
  {
    homeTeam: 'Liverpool',
    awayTeam: 'Chelsea',
    dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 2 * 60 * 60 * 1000)),
    competition: 'Premier League',
    tvChannels: ['DAZN'],
    isPopular: true,
    league: 'england',
    season: '2024-2025'
  },
  {
    homeTeam: 'Bayern Munich',
    awayTeam: 'Borussia Dortmund',
    dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 4 * 60 * 60 * 1000)),
    competition: 'Bundesliga',
    tvChannels: ['Movistar+'],
    isPopular: true,
    league: 'germany',
    season: '2024-2025'
  },
  {
    homeTeam: 'Inter Milan',
    awayTeam: 'AC Milan',
    dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 6 * 60 * 60 * 1000)),
    competition: 'Serie A',
    tvChannels: ['Movistar+'],
    isPopular: true,
    league: 'italy',
    season: '2024-2025'
  }
];

// ========================================
// COL·LECCIÓ: bars (igual que abans)
// ========================================
const bars = [
  {
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
        dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 3 * 60 * 60 * 1000)),
        competition: 'La Liga',
        tvChannel: 'Movistar LaLiga'
      }
    ],
    createdAt: admin.firestore.Timestamp.now(),
    updatedAt: admin.firestore.Timestamp.now()
  },
  {
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
        dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 5 * 60 * 60 * 1000)),
        competition: 'Premier League',
        tvChannel: 'DAZN'
      }
    ],
    createdAt: admin.firestore.Timestamp.now(),
    updatedAt: admin.firestore.Timestamp.now()
  },
  {
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
        dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 2 * 60 * 60 * 1000)),
        competition: 'Premier League',
        tvChannel: 'DAZN'
      }
    ],
    createdAt: admin.firestore.Timestamp.now(),
    updatedAt: admin.firestore.Timestamp.now()
  },
  {
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
        dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 6 * 60 * 60 * 1000)),
        competition: 'Serie A',
        tvChannel: 'Movistar+'
      }
    ],
    createdAt: admin.firestore.Timestamp.now(),
    updatedAt: admin.firestore.Timestamp.now()
  },
  {
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
        dateTime: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 4 * 60 * 60 * 1000)),
        competition: 'Bundesliga',
        tvChannel: 'Movistar+'
      }
    ],
    createdAt: admin.firestore.Timestamp.now(),
    updatedAt: admin.firestore.Timestamp.now()
  }
];

async function seedDatabase() {
  console.log('🚀 Iniciant seed complet de la base de dades...\n');
  
  try {
    // 1. Crear usuaris
    console.log('👥 Creant usuaris...');
    for (const user of users) {
      await db.collection('users').add(user);
      console.log(`  ✅ ${user.email} (${user.role})`);
    }
    
    // 2. Crear calendari de partits
    console.log('\n⚽ Creant calendari de partits...');
    for (const match of matchSchedule) {
      await db.collection('match_schedule').add(match);
      console.log(`  ✅ ${match.homeTeam} vs ${match.awayTeam}`);
    }
    
    // 3. Crear bars
    console.log('\n🍺 Creant bars...');
    for (const bar of bars) {
      await db.collection('bars').add(bar);
      console.log(`  ✅ ${bar.name}`);
    }
    
    console.log('\n🎉 Base de dades creada amb èxit!');
    console.log(`\n📊 Resum:`);
    console.log(`   - Usuaris: ${users.length}`);
    console.log(`   - Partits: ${matchSchedule.length}`);
    console.log(`   - Bars: ${bars.length}`);
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

seedDatabase();