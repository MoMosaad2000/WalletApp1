import 'package:flutter/material.dart';
import 'package:gp/screens/bills.dart';
import 'package:gp/screens/expense.dart';
import 'package:gp/screens/notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
