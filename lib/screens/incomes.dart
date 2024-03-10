import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gp/Models/incomeModel.dart';
import 'package:gp/Services/addincome.dart';
import 'package:gp/Services/deleteincome.dart';
import 'package:gp/Services/income.dart';
import 'package:gp/screens/addIncomes.dart';
import 'package:gp/screens/editIncome.dart';
import 'package:intl/intl.dart';

class IncomesScreen extends StatefulWidget {
  @override
  _IncomesScreenState createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  final GetIncome _getIncomeService = GetIncome();
  final AddIncome _addIncomeService = AddIncome();
  final DeleteIncome _deleteIncomeService = DeleteIncome();
  late List<IncomeModel> incomes;
  late StreamController<IncomeModel> _incomeController;

  @override
  void initState() {
    super.initState();
    incomes = [];
    _incomeController = StreamController<
        IncomeModel>.broadcast(); // Create a broadcast stream controller
    _fetchIncomeData();
  }

  @override
  void dispose() {
    _incomeController.close(); // Close the stream controller when not needed
    super.dispose();
  }

  void _fetchIncomeData() async {
    try {
      List<IncomeModel> fetchedIncomes = await _getIncomeService.fetchData();
      setState(() {
        incomes = fetchedIncomes;
      });
    } catch (e) {
      print('Error fetching income data: $e');
    }
  }

  Future<void> _deleteIncome(String incomeId, int index) async {
    setState(() {
      incomes.removeAt(index);
    });

    try {
      await _deleteIncomeService.deleteData(incomeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Income deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting income: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete income: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Incomes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: incomes.isEmpty
          ? const Center(
              child: Text('No data available'),
            )
          : StreamBuilder<IncomeModel>(
              stream:
                  _incomeController.stream, // Subscribe to the income stream
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: incomes.length,
                        itemBuilder: (context, index) {
                          IncomeModel income = incomes[index];
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      income.title ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(
                                              DateTime.parse(income.createdAt!))
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  income.cost.toString() ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            EditIncomeScreen(
                                                income: income,
                                                incomeController:
                                                    _incomeController), // Pass the income controller to the EditIncomeScreen
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xff19F622),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    _deleteIncome(income.sId!, index);
                                  },
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xffFF0000),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Divider(
                        indent: 30,
                        endIndent: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 55),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE7C9),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Total Incomes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                width: 100,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    "${_calculateTotalIncome()} EGP",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIncomeScreen()),
          );
          if (result == true) {
            _fetchIncomeData(); // Reload income data if a new income is added
          }
        },
        backgroundColor: const Color(0xFF294B29),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  int _calculateTotalIncome() {
    return incomes.fold(
        0, (previousValue, element) => previousValue + (element.cost ?? 0));
  }
}
