import 'package:flutter/material.dart';
import 'package:streamzlive/screens/browser_screen.dart';
import 'package:streamzlive/screens/feed_screen.dart';
import 'package:streamzlive/screens/go_live_screen.dart';
import 'package:streamzlive/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routename = './home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 1;
  List<Widget> pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    const BrowserScreen()
  ];

  void onpageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final username = userProvider.user.username;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: onpageChange,
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        unselectedFontSize: 12,
        backgroundColor: backgroundColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Following'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Go Live'),
          BottomNavigationBarItem(icon: Icon(Icons.copy), label: 'Browse'),
        ],
      ),
      body: pages[_page],
    );
  }
}
