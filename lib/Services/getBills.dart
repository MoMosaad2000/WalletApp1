import 'package:dio/dio.dart';
import 'package:gp/Models/billsModel.dart';


class GetBills {
  final Dio _dio = Dio();

  Future<List<BillsModel>> fetchData() async {
    try {
      Response response = await _dio.get('https://walletapp-cr96.onrender.com/api/v1/saving/bills/65e77dfc1c4a15ae7c2056d6');

      if (response.statusCode == 200) {
        // Parse the response data into a list of IncomeModel objects
        List<dynamic> jsonData = response.data;
        List<BillsModel> incomeList = jsonData.map((data) => BillsModel.fromJson(data)).toList();
        return incomeList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
