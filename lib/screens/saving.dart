import 'package:flutter/material.dart';
import 'package:gp/screens/addSaving.dart';
import 'package:gp/screens/editsaving.dart';

class SavingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Bills',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Column(
        children: [
          Center(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Electricity"),
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  "22-1-2024",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Text("500 EGP"),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      EditSavingScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Color(0xff19F622),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xffFF0000),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      indent: 30,
                      endIndent: 30,
                    )
                  ],
                );
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Divider(
              indent: 30,
              endIndent: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    child: Center(
                        child: Text(
                      "1000 EG",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    width: 90,
                    height: 30,
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSavingScreen()),
          );
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
