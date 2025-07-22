import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Import DatabaseHelper
import 'models/test_result.dart';


class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, dynamic>> users = [];

  void fetchUsers() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<TestResult> results = await dbHelper.getResults();
  
  setState(() {
    users = results.map((result) => result.toMap()).toList();
  });
}


  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users List")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Username")),
            DataColumn(label: Text("Password")),
          ],
          rows: users.map((user) {
            return DataRow(cells: [
              DataCell(Text(user['id'].toString())),
              DataCell(Text(user['username'])),
              DataCell(Text(user['password'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
