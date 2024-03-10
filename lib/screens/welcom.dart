import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'We are happy to see you here.',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color(0xFF294B29), // Text color for Login button
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      width: 2,
                      color: Color(0xFF294B29)), // Border color and width
                ),
                minimumSize: const Size(200, 0), // Fixed width
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to sign up screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF294B29),
                backgroundColor: Colors.white, // Text color for Sign Up button
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      width: 2,
                      color: Color(0xFF294B29)), // Border color and width
                ),
                minimumSize: const Size(200, 0), // Fixed width
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
