import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Define a model for notifications
class NotificationModel {
  final String message;
  bool isRead;

  NotificationModel({required this.message, this.isRead = false});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(message: json['message']);
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isAllRead = false;
  List<NotificationModel> notifications =
      []; // Changed to a list of NotificationModel

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

  // Function to handle marking all notifications as read
  void markAllAsRead() {
    setState(() {
      isAllRead = true;
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  // Method to fetch data from APIs
  Future<void> fetchDataAndShowNotification() async {
    final String userId = "65e77dfc1c4a15ae7c2056d6";
    final String expensesApiUrl =
        "https://walletapp-cr96.onrender.com/api/v1/user/expenses";
    final String incomesApiUrl =
        "https://walletapp-cr96.onrender.com/api/v1/income/$userId";
    final String salaryRestApiUrl =
        "https://walletapp-cr96.onrender.com/api/v1/salary/salaryRest";

    final String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc0xvZ2luIjp0cnVlLCJpZCI6IjY1ZTc3ZGZjMWM0YTE1YWU3YzIwNTZkNiIsImlhdCI6MTcwOTkwMjE5NH0.tlhg5YeQ-EVv-cb-Z5sjPBQCRwxmwLKlXrE7ZGThLOY";

    try {
      // Fetch expenses
      final Response<dynamic> expensesResponse = await Dio().get(
        expensesApiUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final List<dynamic> expensesData = expensesResponse.data['userExpenses'];
      int totalExpenses = expensesData.fold<int>(
          0, (previous, current) => previous + (current['amount'] as int));

      // Fetch incomes
      final Response<dynamic> incomesResponse = await Dio().get(
        incomesApiUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final List<dynamic> incomesData = incomesResponse.data;
      int totalIncomes = incomesData.fold<int>(
          0, (previous, current) => previous + (current['cost'] as int));

      // Calculate the difference between incomes and expenses
      int salaryRest = totalIncomes - totalExpenses;

      // Send the calculated data to the salary REST API
      final Response<dynamic> salaryRestResponse = await Dio().post(
        salaryRestApiUrl,
        data: {
          "userId": userId,
          "incomes": totalIncomes,
          "expenses": totalExpenses
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // Show the received message in notifications
      final Map<String, dynamic> responseData = salaryRestResponse.data;
      String message = responseData['message'];
      setState(() {
        notifications.add(NotificationModel(message: message));
      });
    } catch (error) {
      // Handle errors
      print("Error: $error");
      setState(() {
        notifications.add(NotificationModel(
            message: "An error occurred while fetching data."));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data and show notifications when the screen is initialized
    fetchDataAndShowNotification();
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
                          if (isAllRead) {
                            // If "Mark all Read" is checked, change the color of all containers to white
                            for (var notification in notifications) {
                              notification.isRead = true;
                            }
                          }
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
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () {
                    deleteAllNotifications();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: notifications[index].isRead
                          ? Colors.white
                          : Colors.grey[
                              300], // Change color to white if the notification is read
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            ' ${notifications[index].message}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notifications[index].isRead
                                  ? Colors.black
                                  : Color.fromARGB(255, 0, 55,
                                      255), // Change text color if needed
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded,
                              color: Colors.red),
                          onPressed: () {
                            deleteNotification(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
