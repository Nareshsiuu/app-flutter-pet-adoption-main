import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // List of notifications
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Pet Available',
      description: 'Check out the new dog available for adoption!',
      timestamp: '5 mins ago',
      imageUrl:
      'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDE3fHxkb2d8ZW58MHx8fDE2NjMwOTI2MTQ&ixlib=rb-1.2.1&q=80&w=400',
    ),
    NotificationItem(
      title: 'Adoption Request Approved',
      description: 'Your adoption request for Bella has been approved!',
      timestamp: '20 mins ago',
      imageUrl:
      'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDE3fHxkb2d8ZW58MHx8fDE2NjMwOTI2MTQ&ixlib=rb-1.2.1&q=80&w=400',
    ),
    NotificationItem(
      title: 'Reminder: Pet Vaccination',
      description: 'Don’t forget to schedule a vaccination for your adopted cat!',
      timestamp: '1 hour ago',
      imageUrl:
      'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDE3fHxkb2d8ZW58MHx8fDE2NjMwOTI2MTQ&ixlib=rb-1.2.1&q=80&w=400',
    ),
    NotificationItem(
      title: 'New Message',
      description: 'You have a new message from an adoption center.',
      timestamp: '3 hours ago',
      imageUrl:
      'https://images.unsplash.com/photo-1592194996308-7b43878e84a6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDE3fHxkb2d8ZW58MHx8fDE2NjMwOTI2MTQ&ixlib=rb-1.2.1&q=80&w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Dismissible(
            key: Key(notification.title),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });

              // Show a snackbar or notification after dismissal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${notification.title} dismissed")),
              );
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  notification.timestamp,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String timestamp;
  final String imageUrl;

  NotificationItem({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.imageUrl,
  });
}
