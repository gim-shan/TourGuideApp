import 'package:flutter/material.dart';

class Destination1 extends StatefulWidget {
  const Destination1({super.key});

  @override
  State<Destination1> createState() => _Destination1State();
}

class _Destination1State extends State<Destination1> {
  // Data list to represent your 4 images/cards
  final List<String> images = [
    'assets/images/sinharaja.png', // Replace with your actual filenames
    'assets/images/sinharaja1.png',
    'assets/images/sinharaja2.png',
    'assets/images/sinharaja3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matching the dark background in your screenshot
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(viewportFraction: 0.9), // Shows a peek of the next card
        itemBuilder: (context, index) {
          return destinationCard(images[index]);
        },
      ),
    );
  }

  Widget destinationCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: Image.asset(
                  imagePath,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),

          // 2. Title and Price
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Sinharaja Forest", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Sri Lanka", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("\$20", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text("per person", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),

          // 3. Description
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Sinharaja Forest Reserve is a forest reserve and a biodiversity hotspot in Sri Lanka. It is of international significance and has been designated a Biosphere Reserve and World Heritage Site by UNESCO.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, height: 1.4),
            ),
          ),

          // 4. Location and Time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("Ratnapura"),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.access_time, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("Open\n09.00Am", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // 5. Add Button
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3022), // Dark green color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Add", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
          
          // 6. Bottom Navigation Placeholder
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home_outlined),
                Icon(Icons.map_outlined),
                Icon(Icons.assignment_outlined),
                Icon(Icons.settings_outlined),
              ],
            ),
          )
        ],
      ),
    );
  }
}