import 'package:flutter/material.dart';
import 'welcom.dart'; // Import your Welcome screen file

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingScreen(
                  imagePath: 'images/mansittingonchair2.png',
                  title: 'Manage Incomes',
                  description: 'You can manage your incomes and know where you spent it.',
                  pageIndex: 0,
                  currentIndex: _currentIndex,
                ),
                OnboardingScreen(
                  imagePath: 'images/manholdingmobilefinance2.png',
                  title: 'Real Time Tracking',
                  description: 'Provides real-time insights into your spending habits, helping you to set and track financial goals.',
                  pageIndex: 1,
                  currentIndex: _currentIndex,
                ),
              ],
            ),
          ),
          if (_currentIndex == 0 || _currentIndex == 1) // Show dots only when the PageView is being displayed
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildDot(isSelected: _currentIndex == 0),
                  const SizedBox(width: 10),
                  BuildDot(isSelected: _currentIndex == 1),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class BuildDot extends StatelessWidget {
  final bool isSelected;

  const BuildDot({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF294B29) : Colors.grey,
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int pageIndex;
  final int currentIndex;

  const OnboardingScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.pageIndex,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            imagePath,
            width: 330,
            height: 220,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 45),
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
