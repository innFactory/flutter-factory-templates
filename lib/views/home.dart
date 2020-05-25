import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/auth/bloc/auth_bloc.dart';
import 'package:template/push_notifications/views/notification_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(initialPage: _currentPage, keepPage: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () => BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: <Widget>[
          NotificationList(),
          Container(
            color: Colors.green,
            child: Center(
              child: RaisedButton(
                child: Text('Test'),
                onPressed: () => BotToast.showSimpleNotification(title: 'Test', subTitle: 'Testnotification'),
              ),
            ),
          ),
          Container(color: Colors.orange),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int index) => _pageController.jumpToPage(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Page 1'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Page 2'),
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