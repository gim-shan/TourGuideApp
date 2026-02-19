// This file defines the data structure for a single live event.
// It acts as a blueprint to ensure all events have the required details.
class EventModel {
  final String title;
  final String location;
  final String date;
  final String imageUrl;
  final String price;

  // The constructor requires all fields to be provided when creating a new event.
  EventModel({
    required this.title,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.price,
  });
}

// A dummy list of events used for testing and UI design purposes.
// Once you connect to a database (like Firebase), you will replace this.
List<EventModel> dummyEvents = [
  EventModel(
    title: "Kandy Esala Perahera",
    location: "Kandy, Sri Lanka",
    date: "Aug 15, 7:00 PM",
    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e9/Kandy_Esala_Perahera.jpg",
    price: "Free",
  ),
  EventModel(
    title: "Galle Literary Festival",
    location: "Galle Fort",
    date: "Jan 25, 9:00 AM",
    imageUrl: "https://example.com/galle.jpg",
    price: "\$20",
  ),
  EventModel(
    title: "Ella Music Night",
    location: "Ella Town",
    date: "Dec 31, 8:00 PM",
    imageUrl: "https://example.com/ella.jpg",
    price: "\$10",
  ),
];