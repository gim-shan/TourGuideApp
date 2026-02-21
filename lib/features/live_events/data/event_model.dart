class EventModel {
  final String title;
  final String location;
  final String date;
  final String imageUrl;
  final String price;
  final String description;
  final String region; // Added field for grouping locations

  EventModel({
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.region, // Added required parameter
  });
}

// Dummy data matching the exact UI design provided
List<EventModel> dummyEvents = [
  EventModel(
    title: "Sky Lanterns",
    location: "Hikkaduwa",
    date: "2025-12-30\n6pm onwards",
    imageUrl: "assets/images/lanterns.png", 
    price: "",
    description: "Lively music, vibrant atmosphere, dancing, delicious food and drinks.",
    region: "Southern", // Grouping category
  ),
  EventModel(
    title: "Bonfires and Barbeques",
    location: "Yala",
    date: "Every Friday\n6pm onwards",
    imageUrl: "assets/images/bonfire.png",
    price: "",
    description: "Stargazing and nightwalking to stories around the fire and cooking.",
    region: "Southern", // Grouping category
  ),
  EventModel(
    title: "Esala Perahera",
    location: "Kandy",
    date: "July/August",
    imageUrl: "assets/images/perahera.png",
    price: "",
    description: "One of the grandest Buddhist festivals in the world...",
    region: "Hill Country", // Grouping category
  ),
  EventModel(
    title: "Vesak Poya",
    location: "Colombo",
    date: "May",
    imageUrl: "assets/images/vesak.png",
    price: "",
    description: "The 'Festival of Lights.' Colombo transforms into a glowing wonderland...",
    region: "Colombo", // Grouping category
  ),
  EventModel(
    title: "Colombo Fashion Week",
    location: "Colombo",
    date: "February/March and November",
    imageUrl: "assets/images/fashion.png",
    price: "",
    description: "Colombo Fashion Week, is a semiannual fashion show held in Colombo...",
    region: "Colombo", // Grouping category
  ),
];