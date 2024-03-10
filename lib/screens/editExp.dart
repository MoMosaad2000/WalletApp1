import 'package:flutter/material.dart';
import 'package:gp/Models/expensesmodel.dart';
import 'package:gp/Services/PutExpen.dart';
import 'dart:async';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final StreamController<Expense> expenseController;
  final Function refreshExpenses; // Function to refresh expenses
  final String subCategoryId; // Sub-category ID

  const EditExpenseScreen({
    required this.expense,
    required this.expenseController,
    required this.refreshExpenses,
    required this.subCategoryId,
  });

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.expense.description ?? '';
    costController.text = widget.expense.amount?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF294B29)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: costController,
              decoration: InputDecoration(
                labelText: 'Cost',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF294B29)),
                ),
              ),
            ),
            SizedBox(height: 70),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final description = descriptionController.text;
                  final amount = int.tryParse(costController.text) ?? 0;

                  try {
                    await UpdateExpense().updateExpense(
                      expenseId: widget.expense.id,
                      description: description,
                      amount: amount,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Expense updated successfully'),
                      ),
                    );
                    final updatedExpense = Expense(
                      id: widget.expense.id,
                      userId: widget.expense.userId,
                      categoryId: widget.expense.categoryId,
                      description: description,
                      amount: amount,
                      createdAt: widget.expense.createdAt,
                      updatedAt: widget.expense.updatedAt,
                    );
                    widget.expenseController.add(updatedExpense);
                    widget.refreshExpenses(widget.subCategoryId); // Refresh expenses after update
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update expense: $e'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF294B29),
                  minimumSize: Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
