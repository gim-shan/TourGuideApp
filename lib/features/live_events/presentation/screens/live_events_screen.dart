import 'package:flutter/material.dart';
import '../../data/event_model.dart';
import '../widgets/event_card.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({super.key});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF143B29);
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Trigger UI rebuild when a tab selection changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.animation?.value == _tabController.index) {
        setState(() {}); 
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/home.png', width: 28, height: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/map.png', width: 28, height: 28),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/clipboard.png', width: 28, height: 28),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/settings.png', width: 28, height: 28),
              label: 'Settings',
            ),
          ],
        ),
      ),

      // Main Body Layout
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Curved Header
            Container(
              height: size.height * 0.42,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
            ),
            
            // Foreground Content
            SafeArea(
              child: Column(
                children: [
                  // App Bar Title & Back Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "Events &\nCelebrations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 26,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Custom Tab Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: false, 
                      dividerColor: Colors.transparent, 
                      indicator: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12), 
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white, 
                      unselectedLabelColor: Colors.white, 
                      labelStyle: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.location_on_outlined, size: 16),
                              SizedBox(width: 4),
                              Text("Locations", style: TextStyle(overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        const Tab(
                          child: Text("This Weekend", style: TextStyle(overflow: TextOverflow.ellipsis)),
                        ),
                        const Tab(
                          child: Text("Top Rated", style: TextStyle(overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10), 
                  
                  // Display content based on the selected tab
                  _getCurrentTabContent(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to switch content based on the active tab
  Widget _getCurrentTabContent() {
    if (_tabController.index == 0) {
      return _buildLocationsTab();
    } else if (_tabController.index == 1) {
      return _buildThisWeekendTab();
    } else {
      return _buildTopRatedTab();
    }
  }

  // 1. Locations Tab: Groups events by their specific regions (e.g., Southern, Colombo)
  Widget _buildLocationsTab() {
    // Organize events into a map based on their region
    Map<String, List<EventModel>> groupedEvents = {};
    for (var event in dummyEvents) {
      if (!groupedEvents.containsKey(event.region)) {
        groupedEvents[event.region] = [];
      }
      groupedEvents[event.region]!.add(event);
    }

    List<Widget> listItems = [];
    
    // Build UI elements for each region category
    groupedEvents.forEach((region, events) {
      // Add Region Header Text
      listItems.add(
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
          child: Text(
            region,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      );
      
      // Add Event Cards under the respective Region Header
      for (var event in events) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: EventCard(event: event),
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItems,
    );
  }

  // 2. This Weekend Tab: Displays events filtered for the upcoming weekend
  Widget _buildThisWeekendTab() {
    // Filtering dummy data by 'Colombo' as a placeholder example for weekend events
    List<EventModel> weekendEvents = dummyEvents.where((e) => e.region == "Colombo").toList();
    
    return Column(
      children: weekendEvents.map((event) => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: EventCard(event: event),
      )).toList(),
    );
  }

  // 3. Top Rated Tab: Displays the highest-rated events
  Widget _buildTopRatedTab() {
    // Reversing the dummy data list as a placeholder example for top-rated events
    List<EventModel> topRatedEvents = dummyEvents.reversed.toList();
    
    return Column(
      children: topRatedEvents.map((event) => Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: EventCard(event: event),
      )).toList(),
    );
  }
}