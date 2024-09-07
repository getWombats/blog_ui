import 'dart:ui';

import 'package:blog_test/constants/app_constants.dart';
import 'package:blog_test/widgets/account_view.dart';
import 'package:blog_test/services/auth_provider.dart';
import 'package:blog_test/widgets/app_info_dialog.dart';
import 'package:blog_test/widgets/blog_list_view.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final authState = AuthState.instance;
  static final List<Widget> _widgetOptions = <Widget>[
    const BlogListView(),
    const AccountView(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    authState.logout();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          var fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          var fadeOutAnimation =
              Tween(begin: 1.0, end: 0.0).animate(secondaryAnimation);

          return FadeTransition(
            opacity: fadeInAnimation,
            child: SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeOutAnimation,
                child: child,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.0),
              ),
            ),
            AppInfoDialog(theme: theme)
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          AppConstants.APP_NAME,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.surface,
          ),
        ),
        actions: [
          PopupMenuButton(
            popUpAnimationStyle: AnimationStyle.noAnimation,
            icon: Icon(Icons.more_vert,
                color: theme.colorScheme.surface, size: 30),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () => _logout(context),
                  icon: Icon(Icons.logout, color: theme.colorScheme.primary),
                  label: const Text('Logout'),
                  iconAlignment: IconAlignment.start,
                  style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary),
                ),
              ),
              PopupMenuItem(
                child: TextButton.icon(
                  onPressed: () => (_showAppInfoDialog(context)),
                  icon: Icon(Icons.question_mark,
                      color: theme.colorScheme.primary),
                  label: const Text('About this app'),
                  iconAlignment: IconAlignment.start,
                  style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
