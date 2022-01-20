import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/ui_elements/addTest.dart';
import 'package:orthophonie/ui_elements/add_patient.dart';
import 'package:open_file/open_file.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key, this.onTap}) : super(key: key);
  final Function? onTap;

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final ScrollController _scrollController = ScrollController();
  final _patientList = [];
  final _bilan = [];
  int _selectedPatient = 0;
  bool _showPatientWindow = false;
  bool _addTest = false;

  initDB() async {
    _patientList.clear();
    _bilan.clear();
    var patient = await getResult(
      query: "select * from patient",
    );
    try {
      _patientList.addAll(patient);
      for (var p in _patientList) {
        _bilan.add(
          await getResult(
            query: "select * from bilan where patientId = ${p['id']}",
          ),
        );
      }
    } catch (_) {
      if (kDebugMode) {
        print(patient);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: addTest(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: topBar(),
              ),
              Container(
                width: double.infinity,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 4,
                      child: Text('Nom'),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text('Prénom'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Date De Naissance'),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text('Bilan'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _patientList.length,
                      itemBuilder: (context, index) {
                        return patientWidget(index);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          Visibility(
            visible: _showPatientWindow,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.6),
              alignment: Alignment.center,
              child: SizedBox(
                height: 300,
                width: 360,
                child: AddPatient(
                  onTap: () {
                    setState(() {
                      _showPatientWindow = false;
                    });
                  },
                  onAdd: () {
                    initDB();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget patientWidget(index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPatient = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _selectedPatient == index ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: _selectedPatient == index ? 0 : 0.7,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    _patientList[index]['name'],
                    style: TextStyle(
                      fontSize: _selectedPatient == index ? 18 : 14,
                      fontWeight: _selectedPatient == index ? FontWeight.w600 : FontWeight.normal,
                      color: _selectedPatient == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _patientList[index]['prename'],
                    style: TextStyle(
                      fontSize: _selectedPatient == index ? 18 : 14,
                      fontWeight: _selectedPatient == index ? FontWeight.w600 : FontWeight.normal,
                      color: _selectedPatient == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _patientList[index]['birth'],
                    style: TextStyle(
                      fontSize: _selectedPatient == index ? 18 : 14,
                      fontWeight: _selectedPatient == index ? FontWeight.w600 : FontWeight.normal,
                      color: _selectedPatient == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SizedBox(height: 30, child: patientBilan(index)),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: _selectedPatient == index ? 0 : 0.7,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget patientBilan(index) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _bilan[index].length,
      itemBuilder: (_, i) {
        return InkWell(
          onTap: () async {
            var result = await getResult(
              query: "select * from bilan where patientId=${_patientList[index]['id']} and name ='${_bilan[index][i]['name']}' ",
            );
            File file = File(result[0]['name']);
            await file.writeAsBytes(result[0]['bilan']);
            OpenFile.open(result[0]['name']);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            height: 30,
            decoration: BoxDecoration(
              color: index == _selectedPatient ? Colors.white : Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _bilan[index][i]['name'],
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  Widget topBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            widget.onTap!();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.grey,
            size: 40,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            setState(() {
              _showPatientWindow = true;
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.green[400],
            size: 40,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.edit,
            color: Colors.blue[400],
            size: 40,
          ),
        ),
        InkWell(
          onTap: () async {
            final int id = _patientList[_selectedPatient]['id'];
            if (_selectedPatient != -1) {
              await getResult(query: "delete from patient where id = $id");
              await initDB();
              if (_selectedPatient > _patientList.length - 1) {
                _selectedPatient = _patientList.length - 1;
              }
              getResult(query: "delete from bilan where patientId = $id");
              getResult(query: "delete from patientTest where patientId = $id");
            }
          },
          child: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget addTest() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                color: Colors.white,
                width: 900,
                height: 500,
                child: AddTest(
                  patient: _patientList[_selectedPatient]['id'],
                  test: 2,
                ),
              ),
            );
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.add,
            size: 25,
          ),
          Text('TEST'),
        ],
      ),
    );
  }
}
