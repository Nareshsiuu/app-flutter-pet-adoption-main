import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ChatListScreen(),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {'name': 'Alice', 'lastMessage': 'Hey there!'},
    {'name': 'Bob', 'lastMessage': 'Let’s catch up soon.'},
    {'name': 'Charlie', 'lastMessage': 'See you tomorrow.'},
    {'name': 'Diana', 'lastMessage': 'It was great meeting you!'},
    {'name': 'Eve', 'lastMessage': 'Can you send me the file?'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(contacts[index]['name']![0],
                  style: TextStyle(color: Colors.white)),
            ),
            title: Text(contacts[index]['name']!),
            subtitle: Text(contacts[index]['lastMessage']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatWindowScreen(
                    contactName: contacts[index]['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatWindowScreen extends StatelessWidget {
  final String contactName;

  ChatWindowScreen({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                // Sample messages
                _buildMessage('Hi, how are you?', true),
                _buildMessage('I\'m good, what about you?', false),
                _buildMessage('Doing great, thanks!', true),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.teal),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}