import 'package:flutter/material.dart';
import 'package:gp/screens/editcategory.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFDBE7C9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                          child: Text(
                        "Shopping",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => EditCategoryScreen(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Color(0xff19F622),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xffFF0000),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
