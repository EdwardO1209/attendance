// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class menu extends StatefulWidget {
  final rfid;
  menu({required this.rfid});
  @override
  State<menu> createState() => _menuState(rfid: rfid);
}

DateTime datenow = DateTime.now();
const urlImg = "http://20.10.0.19/empImg/luffy.jpg";

class _menuState extends State<menu> {
  String rfid;
  _menuState({required this.rfid});
  late List<Employee> employees;
  EmployeeDataSource? employeeDataSource;
  SharedPreferences? sharedPreferences;
  String firstname = "";
  String employeeID = "";
  String lastname = "";

  Future<List<Employee>> getAttendance() async {
    var uri = 'http://20.10.0.19/conn/view_data.php/';
    final response = await http.post(Uri.parse(uri),
        body: ({'rfid': rfid, 'logdate': datenow.toString()}));
    var list = json.decode(response.body);
    print(datenow);
    List<Employee> employees =
        await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    employeeDataSource = EmployeeDataSource(employees);
    if (kDebugMode) {
      print(list);
    }
    return employees;
  }

  _showDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: datenow,
      firstDate: DateTime.utc(2020),
      lastDate: DateTime.utc(2050),
    );
    if (picked != null && picked != datenow) {
      setState(() {
        datenow = picked;
        _getEmployees();
      });
    }
  }

  _getEmployees() {
    getAttendance().then((value) {
      setState(() {
        employees = [];
        employees = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDet();
    _getEmployees();
    employees = [];
  }

  void getDet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      firstname = pref.getString('firstname')!;
      lastname = pref.getString('lastname')!;
      employeeID = pref.getString('employeeID')!;
      rfid = pref.getString('rfid')!;
    });
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Status',
          //width: 100,
          label: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: const Text('Status'))),
      GridColumn(
          columnName: 'Logdate',
          //width: 100,
          label: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: const Text('Logdate'))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log Dates",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 143, 204, 145),
                Color.fromARGB(255, 70, 182, 128)
              ])),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Select a Date",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 3),
          //Date
          ElevatedButton(
            onPressed: () {
              _showDatePicker(context);
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(15),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            child: const Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

//          const SizedBox(
//            height: 10,
//          ),
//
          SizedBox(
            height: 408,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              shadowColor: const Color.fromARGB(255, 41, 234, 140),
              elevation: 10,
              margin: const EdgeInsets.only(top: 10),
              child: FutureBuilder<List<Employee>>(
                  future: getAttendance(),
                  builder: (context, data) {
                    return data.hasData
                        ? SfDataGrid(
                            source: employeeDataSource!,
                            columnWidthMode: ColumnWidthMode.fill,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            columns: getColumns())
                        : Center(
                            child: Text(
                            "NO RECORD FOUND ON \n ${DateFormat.yMMMd().format(datenow)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ));
                  }),
            ),
          )
        ]),
      ),
    );
  }
}

class Employee {
  String status;
  int logdate;
  Employee({
    required this.status,
    required this.logdate,
  });
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      status: json['status'],
      logdate: int.parse(json['logdate']),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.employees) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _employeeDataGridRows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Status', value: e.status),
              DataGridCell<String>(
                  columnName: 'Logdate',
                  value: DateFormat('MMMM, dd yyyy \n \t\t\t\t\t\t KK:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          e.logdate * 1000))),
            ]))
        .toList();
  }

  List<Employee> employees = [];

  List<DataGridRow> _employeeDataGridRows = [];

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void updateDataGrid() {
    notifyListeners();
  }
}
