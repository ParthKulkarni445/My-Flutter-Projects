import 'package:flutter/material.dart';
import 'package:unite_app/screens/schedule_page.dart';
import 'package:unite_app/screens/meeting_history.dart';
import 'package:unite_app/screens/meetings_page.dart';
import 'package:unite_app/screens/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _page=0;
  onPageChange(int page){
    setState(() {
      _page=page;
    });
  }

  List<Widget> pages = [
    const MeetingsPage(),
    const MeetingHistory(),
    const SchedulePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          title: const Text(
            "unite",
            style: TextStyle(
              fontSize: 30,
              shadows: [Shadow(color: Colors.black, blurRadius: 20)]
            ),
            ),
        ),
        body: pages[_page],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: BorderDirectional(top: BorderSide(width: 2,color: Colors.black))
          ),
          child: BottomNavigationBar(
            elevation: 30,
            onTap: onPageChange,
            currentIndex: _page,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.deepPurple,
            selectedIconTheme: const IconThemeData(size: 35),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.grey[600],
            unselectedIconTheme: const IconThemeData(size: 30),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600]),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.videocam), label: "MeetRooms"),
              BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), label: "History"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}