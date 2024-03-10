import 'package:flutter/material.dart';
import 'package:gp/Models/newincome.dart';

class NewIncomeProvider extends ChangeNotifier {
  List<NewIncomeModel> _newIncomes = [];

  List<NewIncomeModel> get newIncomes => _newIncomes;

  void addNewIncome(NewIncomeModel newIncome) {
    _newIncomes.add(newIncome);
    notifyListeners();
  }
}
