import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isAllRead = false;
  List<Notification> notifications = [
    Notification(text: 'Notification 1', time: '9:00 AM'),
    Notification(text: 'Notification 2', time: '10:00 AM'),
    Notification(text: 'Notification 3', time: '11:00 AM'),
  ];

  // Function to handle deleting a single notification
  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  // Function to handle deleting all notifications
  void deleteAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isAllRead,
                      onChanged: (value) {
                        setState(() {
                          isAllRead = value!;
                        });
                      },
                    ),
                    Text(
                      'Mark all Read',
                      style: TextStyle(
                        color: Colors.green, // Change color if needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon( Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () {
                    deleteAllNotifications();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length, // Use notifications list length
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(notifications[index].text),
                      subtitle: Opacity(
                        opacity: 0.5,
                        child: Text(
                          notifications[index]
                              .time, // Replace with notification time
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon( Icons.delete_outline_rounded, color: Colors.red),
                        onPressed: () {
                          // Call the function to delete the selected notification
                          deleteNotification(index);
                        },
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Notification {
  final String text;
  final String time;

  Notification({required this.text, required this.time});
}
