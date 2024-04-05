import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gp/Models/billsModel.dart';
import 'package:gp/Services/updateBills.dart';



class EditBillsScreen extends StatefulWidget {
  final BillsModel bill;
  final StreamController<BillsModel> billsController;

  const EditBillsScreen(
      {required this.bill, required this.billsController});

  @override
  _EditBillsScreenState createState() => _EditBillsScreenState();
}

class _EditBillsScreenState extends State<EditBillsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for text fields based on the provided income model
    descriptionController.text = widget.bill.title ?? '';
    costController.text = widget.bill.cost?.toString() ?? '';
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
                  // Extract data from text fields
                  final title = descriptionController.text;
                  final cost = int.tryParse(costController.text) ?? 0;

                  try {
                    // Call the updateData method to send a PUT request
                    await UpdateBills()
                        .updateData(widget.bill.sId ?? '', title, cost);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bill updated successfully'),
                      ),
                    );
                    // Update the income object with the new values
                    widget.bill.title = title;
                    widget.bill.cost = cost;
                    // Emit the updated income object through the stream controller
                    widget.billsController.add(widget.bill);
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update Bill: $e'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF294B29),
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
