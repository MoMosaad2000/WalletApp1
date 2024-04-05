import 'package:dio/dio.dart';

class UpdateBills {
  final Dio _dio = Dio();

  Future<void> updateData(String id, String title, int cost) async {
    try {
      // Define the data to be sent in the request body
      Map<String, dynamic> data = {
        'title': title,
        'cost': cost,
      };

      // Send a PUT request with the data to the specified URL
      Response response = await _dio.put(
        'https://walletapp-cr96.onrender.com/api/v1/saving/bills/65e77dfc1c4a15ae7c2056d6/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        // If the request is successful (status code 200), do something
        print('Data updated successfully');
      } else {
        // If the request is not successful, throw an exception
        throw Exception('Failed to update data');
      }
    } catch (e) {
      // If an error occurs during the request, throw an exception
      throw Exception('Failed to update data: $e');
    }
  }
}
