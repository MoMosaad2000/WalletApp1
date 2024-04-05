import 'package:dio/dio.dart';

class DeleteBills {
  final Dio _dio = Dio();

  Future<void> deleteData(String billsId) async {
    try {
      // Send a DELETE request to the specified URL
      Response response = await _dio.delete(       
        'https://walletapp-cr96.onrender.com/api/v1/saving/bills/65e77dfc1c4a15ae7c2056d6/$billsId',
      );

      if (response.statusCode == 200) {
        // If the request is successful (status code 200), do something
        print('Data deleted successfully');
      } else {
        // If the request is not successful, throw an exception
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      // If an error occurs during the request, throw an exception
      throw Exception('Failed to delete data: $e');
    }
  }
}
