import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gp/Models/billsModel.dart';
import 'package:gp/Services/addBills.dart';
import 'package:gp/Services/deleteBills.dart';
import 'package:gp/Services/getBills.dart';
import 'package:gp/screens/addBills.dart';
import 'package:gp/screens/updateBills.dart';


import 'package:intl/intl.dart';

class BillsScreen extends StatefulWidget {
  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final GetBills _getBillsService = GetBills();
  final AddBills _addBillsService = AddBills();
  final DeleteBills _deleteBillsService = DeleteBills();
  late List<BillsModel> Bills;
  late StreamController<BillsModel> _billsController;

  @override
  void initState() {
    super.initState();
    Bills = [];
    _billsController = StreamController<
        BillsModel>.broadcast(); // Create a broadcast stream controller
    _fetchBillsData();
  }

  @override
  void dispose() {
    _billsController.close(); // Close the stream controller when not needed
    super.dispose();
  }

  void _fetchBillsData() async {
    try {
      List<BillsModel> fetchedBills = await _getBillsService.fetchData();
      setState(() {
        Bills = fetchedBills;
      });
    } catch (e) {
      print('Error fetching income data: $e');
    }
  }

  Future<void> _deleteBills(String billId, int index) async {
    setState(() {
      Bills.removeAt(index);
    });

    try {
      await _deleteBillsService.deleteData(billId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bill deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting Bill: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete Bill: $e'),
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
          'Bills',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Bills.isEmpty
          ? const Center(
              child: Text('No data available'),
            )
          : StreamBuilder<BillsModel>(
              stream:
                  _billsController.stream, // Subscribe to the bills stream
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: Bills.length,
                        itemBuilder: (context, index) {
                          BillsModel bill = Bills[index];
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bill.title ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(
                                              DateTime.parse(bill.createdAt!))
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  bill.cost.toString() ?? '',
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
                                            EditBillsScreen(
                                                bill: bill,
                                                billsController:
                                                    _billsController), // Pass the income controller to the EditIncomeScreen
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
                                    _deleteBills(bill.sId!, index);
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
                                "Total Bills",
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
                                    "${_calculateTotalBills()} EGP",
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
            MaterialPageRoute(builder: (context) => AddBillsScreen()),
          );
          if (result == true) {
            _fetchBillsData(); // Reload bills data if a new income is added
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

  int _calculateTotalBills() {
    return Bills.fold(
        0, (previousValue, element) => previousValue + (element.cost ?? 0));
  }
}
