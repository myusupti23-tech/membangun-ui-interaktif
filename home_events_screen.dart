import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import '../models/registration_ticket.dart';

class HomeEventsScreen extends StatefulWidget {
  final Function(RegistrationTicket) onRegistered;

  const HomeEventsScreen({Key? key, required this.onRegistered}) : super(key: key);

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedCategory == 'All'
        ? sampleEvents
        : sampleEvents.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaEvent Hub'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.event), text: 'Seminar & Workshop'),
            Tab(icon: Icon(Icons.map), text: 'Galeri & Denah Venue'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterBottomSheet(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                ),
              );
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Seminar & Workshop (ListView)
          Column(
            children: [
              if (_selectedCategory != 'All')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text('Filter: $_selectedCategory'),
                    onDeleted: () => setState(() => _selectedCategory = 'All'),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return EventCard(
                      event: event,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventRegistrationScreen(
                              event: event,
                              onRegistered: widget.onRegistered,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Tab 2: Galeri & Denah Venue (GridView & InteractiveViewer)
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Galeri Poster Seminar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              SizedBox(
                height: 180,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: sampleEvents.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(sampleEvents[index].imageUrl, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
              const Divider(),
              const Expanded(child: VenueMapViewer()),
            ],
          ),
        ],
      ),
    );
  }
}