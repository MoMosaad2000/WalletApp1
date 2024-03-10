import 'package:flutter/material.dart';
import 'package:gp/Models/expensesmodel.dart';
import 'package:gp/Services/PostExpense.dart';
import 'package:gp/Services/deleteExp.dart';
import 'package:gp/Services/getExpen.dart';
import 'package:gp/screens/addExp.dart';
import 'package:gp/screens/editExp.dart';
import 'dart:async';

class ExpensiveScreen extends StatefulWidget {
  @override
  _ExpensiveScreenState createState() => _ExpensiveScreenState();
}

class _ExpensiveScreenState extends State<ExpensiveScreen> {
  final DeleteExpense deleteExpenseService = DeleteExpense();
  final GetExpense _getExpenseService = GetExpense();
  final AddExpense _addExpenseService = AddExpense();
  late List<Expense> expense;
  late StreamController<Expense> _expenseController;
  int totalExpense = 0;
  String categoryId = '65e781eb708e682e7263d7fc';

  @override
  void initState() {
    super.initState();
    expense = [];
    _expenseController = StreamController<Expense>.broadcast();
    _fetchExpenseData(categoryId);
  }

  void _fetchExpenseData(String categoryId) async {
    try {
      List<Expense> fetchedExpenses =
          await _getExpenseService.fetchExpenses(categoryId);
      setState(() {
        expense = fetchedExpenses;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'An error occurred while fetching expenses. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _deleteExpense(String expenseId, int index) async {
    setState(() {
      expense.removeAt(index);
    });

    try {
      await deleteExpenseService.deleteExpense(expenseId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete expense: $e'),
        ),
      );
    }
  }

  int _calculateTotalExpense() {
    int total = 0;
    for (Expense exp in expense) {
      total += exp.amount ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Food & Drink',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      height: 800,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.refresh),
                            title: Text('Reset'),
                            onTap: () {
                              // Reset logic
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.sort),
                            title: Text('Sort'),
                            onTap: () {
                              // Sort logic
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.search),
                            title: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: expense.isEmpty
          ? Center(
              child: Text('No data available'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: expense.length,
                    itemBuilder: (context, index) {
                      Expense expenses = expense[index];
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expenses.description ?? 'No Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  expenses.createdAt ?? 'No Date',
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              expenses.amount.toString() ?? '0',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                        EditExpenseScreen(
                                      expense: expenses,
                                      expenseController: _expenseController,
                                      refreshExpenses: (String categoryId) {
                                        _fetchExpenseData(categoryId);
                                      },
                                      subCategoryId:
                                          categoryId, // Pass the categoryId as subCategoryId
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Color(0xff19F622),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                _deleteExpense(expenses.id!, index);
                              },
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xffFF0000),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
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
                        color: Color(0xFFDBE7C9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total Expenses",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "${_calculateTotalExpense()} EGP",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            width: 90,
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddExpensiveScreen(
                    refreshExpenses: _fetchExpenseData,
                    categoryId: categoryId)),
          );
          if (result == true) {
            _fetchExpenseData(categoryId);
          }
        },
        backgroundColor: Color(0xFF294B29),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
