import 'package:flutter/material.dart';
import 'package:hidmo_app/core/widgets/custom_app_bar.dart';
import 'package:hidmo_app/features/profile/presentation/screens/user_profile_screen.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import '../widgets/event_card.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({super.key});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Upcoming', 'All Events'];
  final EventRepository _eventRepository = EventRepository();

  Future<List<EventModel>> _getDisplayedEvents() async {
    if (_selectedTabIndex == 0) {
      return await _eventRepository.getUpcomingEvents();
    } else {
      return await _eventRepository.getAllEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),
      appBar: CustomAppBar(
        title: 'Live Events',
        showBackButton: true,
        onProfileTapped: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const UserProfileScreen())),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: List.generate(
                _tabs.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTabIndex == index
                                ? const Color(0xff1b9c4d)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedTabIndex == index
                              ? const Color(0xff1b9c4d)
                              : const Color(0xff666666),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Events List
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: _getDisplayedEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff1b9c4d),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: const Color(0xff1b9c4d).withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading events',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1b3a20).withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xff666666).withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final events = snapshot.data ?? [];

                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          size: 80,
                          color: const Color(0xff1b9c4d).withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1b3a20).withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back soon for upcoming events in Sri Lanka',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff666666).withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: events[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
