import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MessageBoardScreen extends StatelessWidget {
  final List<Map<String, String>> messageBoards = [
    {'title': 'General Chat', 'icon': 'assets/general_chat.png'},
    {'title': 'Announcements', 'icon': 'assets/announcement.png'},
    {'title': 'Study Group', 'icon': 'assets/studygroup.png'},
    {'title': 'Events', 'icon': 'assets/events.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Boards'),
      ),
      drawer: NavigationDrawer(),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              messageBoards[index]['icon']!,
              width: 40,
              height: 40,
            ),
            title: Text(messageBoards[index]['title']!),
            onTap: () {
              // Navigating to ChatScreen with the board name as an argument
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: messageBoards[index]['title']!,
              );
            },
          );
        },
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Message Boards'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/messageBoards');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
