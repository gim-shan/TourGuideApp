import 'package:flutter/material.dart';
import '../../data/event_model.dart';
import '../widgets/event_card.dart';

class LiveEventsScreen extends StatelessWidget {
  const LiveEventsScreen({super.key});

  final Color primaryColor = const Color(0xFF1E4D3C);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Live Events",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black, width: 2),
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: const Color.fromARGB(255, 255, 255, 255),
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: "Location"),
              Tab(text: "This Weekend"),
              Tab(text: "Top Rated"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventList(),
            _buildEventList(),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: ListView.builder(
        itemCount: dummyEvents.length,
        itemBuilder: (context, index) {
          return EventCard(event: dummyEvents[index]);
        },
      ),
    );
  }
}