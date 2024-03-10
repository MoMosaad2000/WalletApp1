import 'package:dio/dio.dart';
import 'package:gp/Models/expensesmodel.dart';

class GetExpense {
  final Dio _dio = Dio();

  Future<List<Expense>> fetchExpenses(String categoryId) async {
    final String apiUrl = 'https://walletapp-cr96.onrender.com/api/v1/user/expenses?categoryId=$categoryId';
    final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc0xvZ2luIjp0cnVlLCJpZCI6IjY1ZTc3ZGZjMWM0YTE1YWU3YzIwNTZkNiIsImlhdCI6MTcwOTkwMjE5NH0.tlhg5YeQ-EVv-cb-Z5sjPBQCRwxmwLKlXrE7ZGThLOY';

    try {
      final response = await _dio.get(apiUrl, options: Options(headers: {
        'Authorization': 'Bearer $token',
      }));

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData.containsKey('userExpenses')) {
          // If 'userExpenses' key is present, extract and map its value to List<Expense>
          final List<dynamic> expensesData = responseData['userExpenses'];
          return expensesData.map((data) => Expense.fromJson(data)).toList();
        } else {
          throw Exception('Unexpected response format: $responseData');
        }
      } else {
        throw Exception('Failed to load expenses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load expenses: $e');
    }
  }
}
