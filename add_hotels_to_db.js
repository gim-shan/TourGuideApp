// Script to add Sri Lanka hotels to Firestore
// Run with: node add_hotels_to_db.js
// Requires: npm install firebase-admin

const admin = require('firebase-admin');

// Initialize Firebase Admin using Application Default Credentials
// This works if you run: gcloud auth application-default login
// Or when deployed to Firebase Cloud Functions
try {
  admin.initializeApp();
} catch (e) {
  // App already initialized
}

const hotels = [
  // Existing hotels
  {
    'name': 'Little England Cottages',
    'location': 'Nuwara Eliya, Sri Lanka',
    'rating': '4.5',
    'price': 120,
    'desc': 'Cozy cottage with mountain views',
  },
  {
    'name': '98 Acres Resort and Spa',
    'location': 'Ella, Sri Lanka',
    'rating': '4.7',
    'price': 180,
    'desc': 'Luxury eco-resort with scenic views',
  },
  {
    'name': 'Heritance Kandalama',
    'location': 'Dambulla, Sri Lanka',
    'rating': '4.6',
    'price': 160,
    'desc': 'Award-winning architectural wonder',
  },
  {
    'name': 'Jetwing Vil Uyana',
    'location': 'Sigiriya, Sri Lanka',
    'rating': '4.8',
    'price': 220,
    'desc': 'Serene luxury with nature pond',
  },
  // New hotels - Coastal & Beach
  {
    'name': 'Taj Bentota Resort & Spa',
    'location': 'Bentota, Sri Lanka',
    'rating': '4.6',
    'price': 200,
    'desc': 'Luxury beachfront resort with Ayurvedic spa',
  },
  {
    'name': 'Shangri-La Hambantota',
    'location': 'Hambantota, Sri Lanka',
    'rating': '4.7',
    'price': 250,
    'desc': 'Premium resort overlooking the Indian Ocean',
  },
  {
    'name': 'Amanwella',
    'location': 'Tangalle, Sri Lanka',
    'rating': '4.9',
    'price': 450,
    'desc': 'Ultra-luxury beachfront villa resort',
  },
  {
    'name': 'Jungle Beach',
    'location': 'Trincomalee, Sri Lanka',
    'rating': '4.4',
    'price': 150,
    'desc': 'Eco-friendly resort nestled in nature',
  },
  {
    'name': 'The Fortress Resort & Spa',
    'location': 'Galle, Sri Lanka',
    'rating': '4.7',
    'price': 220,
    'desc': 'Colonial-style luxury near Galle Fort',
  },
  {
    'name': 'Jetwing Sea',
    'location': 'Negombo, Sri Lanka',
    'rating': '4.5',
    'price': 140,
    'desc': 'Modern beachfront hotel with pool',
  },
  {
    'name': 'Club Hotel Dolphin',
    'location': 'Negombo, Sri Lanka',
    'rating': '4.3',
    'price': 110,
    'desc': 'Family-friendly all-inclusive resort',
  },
  {
    'name': 'Blue Water',
    'location': 'Wadduwa, Sri Lanka',
    'rating': '4.5',
    'price': 160,
    'desc': 'Luxury hotel with stunning ocean views',
  },
  // Hill Country
  {
    'name': 'Ceylon Tea Trails',
    'location': 'Hatton, Sri Lanka',
    'rating': '4.9',
    'price': 400,
    'desc': 'Exclusive tea plantation bungalows',
  },
  {
    'name': 'Camellia Hills',
    'location': 'Dickoya, Sri Lanka',
    'rating': '4.7',
    'price': 280,
    'desc': 'Victorian-era luxury in tea country',
  },
  {
    'name': 'Lunuganga Estate',
    'location': 'Bentota, Sri Lanka',
    'rating': '4.6',
    'price': 180,
    'desc': 'Historic country house with gardens',
  },
  // Cultural Triangle & Kandy
  {
    'name': 'The Lanka Collection',
    'location': 'Kandy, Sri Lanka',
    'rating': '4.4',
    'price': 130,
    'desc': 'Boutique hotel near Kandy Lake',
  },
  {
    'name': 'Mahaweli Reach',
    'location': 'Kandy, Sri Lanka',
    'rating': '4.5',
    'price': 145,
    'desc': 'Riverside hotel with scenic views',
  },
  // Colombo & South
  {
    'name': 'Galle Face Hotel',
    'location': 'Colombo, Sri Lanka',
    'rating': '4.6',
    'price': 200,
    'desc': 'Historic colonial hotel since 1864',
  },
  {
    'name': 'The Mount Lavinia Hotel',
    'location': 'Mount Lavinia, Sri Lanka',
    'rating': '4.5',
    'price': 170,
    'desc': 'Beachfront colonial heritage hotel',
  },
  {
    'name': 'Anantara Kalutara',
    'location': 'Kalutara, Sri Lanka',
    'rating': '4.7',
    'price': 230,
    'desc': 'Luxury villa resort with lagoon',
  },
  {
    'name': 'Avani Kalutara',
    'location': 'Kalutara, Sri Lanka',
    'rating': '4.4',
    'price': 150,
    'desc': 'Modern beachfront resort',
  },
];

async function addHotels() {
  const db = admin.firestore();
  
  console.log(`Adding ${hotels.length} hotels to Firestore...\n`);
  
  let successCount = 0;
  let errorCount = 0;
  
  for (const hotel of hotels) {
    try {
      const docRef = await db.collection('hotels').add({
        ...hotel,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      console.log(`✓ ${hotel.name}`);
      successCount++;
    } catch (error) {
      console.error(`✗ ${hotel.name}: ${error.message}`);
      errorCount++;
    }
  }
  
  console.log(`\n✓ Successfully added ${successCount} hotels to Firestore`);
  if (errorCount > 0) {
    console.log(`✗ Failed to add ${errorCount} hotels`);
  }
  
  process.exit(0);
}

addHotels().catch(err => {
  console.error('Fatal error:', err.message);
  process.exit(1);
});
