import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../auth/bloc/auth_bloc.dart';
import '../push_notifications/push_notifications.dart';

/// The HomeScreen of the Application
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
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: <Widget>[
          Container(
            color: Colors.green,
            child: Center(
              child: ListView(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Test Notification'),
                    onPressed: () => BotToast.showSimpleNotification(
                        title: 'Test', subTitle: 'Testnotification'),
                  ),
                  BlocBuilder<PushNotificationsBloc, PushNotificationsState>(
                    builder: (context, state) {
                      if (state is PushNotificationsLoaded) {
                        return RaisedButton(
                          child: Text('''
                            Test toggle notification channel:
                            ${state.channels.first.isSubscribed}'''),
                          onPressed: () =>
                              BlocProvider.of<PushNotificationsBloc>(context)
                                  .add(TogglePushNotificationChannel(
                                      state.channels.first)),
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(color: Colors.orange),
          Container(color: Colors.red),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) => _pageController.jumpToPage(index),
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
