import 'package:flutter/material.dart';

import 'pages/settings.dart';
import 'pages/test.dart';
import 'pages/todos/todos.dart';

/// The HomeScreen of the Application
class HomeScreen extends StatefulWidget {
  final int initialPage;

  const HomeScreen({
    Key key,
    this.initialPage,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin<HomeScreen> {
  PageController _pageController;
  int _currentPage;

  @override
  void initState() {
    super.initState();
    final initialPage = widget.initialPage ?? 0;
    _pageController = PageController(initialPage: initialPage, keepPage: true);
    _currentPage = initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TestPage(),
            TodosPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (page) {
          _pageController.jumpToPage(page);
          setState(() => _currentPage = page);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Test'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Todos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
