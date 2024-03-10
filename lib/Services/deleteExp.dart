import 'package:dio/dio.dart';

class DeleteExpense {
  final Dio _dio = Dio();

  Future<void> deleteExpense(String expenseId) async {
    final String apiUrl =
        'https://walletapp-cr96.onrender.com/api/v1/expense/deletedExpense/$expenseId';

    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          headers: {
            // Add any headers if required, such as authorization token
          },
        ),
      );

      if (response.statusCode == 200) {
        // Expense deleted successfully
      } else {
        throw Exception('Failed to delete expense');
      }
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }
}
