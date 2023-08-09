
import 'package:flutter/material.dart';
import 'package:module_11_live_class/UI/screens/CancelTaskScreen.dart';
import 'package:module_11_live_class/UI/screens/CompletedTaskScreen.dart';
import 'package:module_11_live_class/UI/screens/InprogressTaskScreen.dart';
import 'package:module_11_live_class/UI/screens/NewTaskScreen.dart';

class BottomNevBaseScreen extends StatefulWidget {
  const BottomNevBaseScreen({super.key});

  @override
  State<BottomNevBaseScreen> createState() => _BottomNevBaseScreenState();
}

class _BottomNevBaseScreenState extends State<BottomNevBaseScreen> {
  int _selectedScreenIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    InProgressTaskScreen(),
    CancelledTaskScreen(),
    CompletedTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showSelectedLabels: true,
        selectedItemColor: Colors.green,
        selectedLabelStyle: const TextStyle(color: Colors.green),
         onTap: (int index){
          _selectedScreenIndex = index;
          if (mounted) {
            setState(() {});
          }
         },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.free_cancellation),
            label: "Cancel",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_done_sharp),
            label: "Completed",
          ),
        ],
      ),
    );
  }
}
