import 'package:flutter/material.dart';
import 'models/registration_ticket.dart';
import 'screens/home_events_screen.dart';
import 'screens/registered_ticket_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NusaEvent Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<RegistrationTicket> _registeredTickets = [];

  void _addTicket(RegistrationTicket ticket) {
    setState(() {
      _registeredTickets.add(ticket);
    });
  }

  void _removeTicket(int index) {
    setState(() {
      _registeredTickets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika masih muncul garis merah di bagian pages, sesuaikan parameter di bawah
    // dengan constructor yang ada di home_events_screen.dart & registered_ticket_screen.dart
   final List<Widget> pages = [
      HomeEventsScreen(onRegistered: _addTicket),
      RegisteredTicketsScreen( // <-- Tambahkan huruf 's' di sini
        tickets: _registeredTickets,
        onCancelTicket: _removeTicket,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Seminar & Venue',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket Terdaftar',
          ),
        ],
      ),
    );
  }
}