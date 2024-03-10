import 'package:dio/dio.dart';

class AddExpense {
  final Dio _dio = Dio();

  Future<void> addExpense({
    required String userId,
    required String categoryId,
    required String description,
    required int amount,
  }) async {
    final String apiUrl =
        'https://walletapp-cr96.onrender.com/api/v1/expense/addExpense';
    final String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc0xvZ2luIjp0cnVlLCJpZCI6IjY1ZTc3ZGZjMWM0YTE1YWU3YzIwNTZkNiIsImlhdCI6MTcwOTY3MDg0MX0.3ZBzxdpn25FMJTizPCF3V-gb4vuOT6-vqwup1i0bl5A';

    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          'userId': userId,
          'categoryId': categoryId,
          'description': description,
          'amount': amount,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Expense added successfully
      } else {
        throw Exception('Failed to add expense');
      }
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }
}
