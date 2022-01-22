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
  final TextEditingController _editingController = TextEditingController();
  final _patientList = [];
  final _bilan = [];
  int _selectedPatient = 0;
  bool _showPatientWindow = false;
  bool _isAddPatient = true;
  bool _addTest = false;
  int _testId = 0;

  initDB({filter = ''}) async {
    _patientList.clear();
    _bilan.clear();
    var patient = await getResult(
      query: "select * from patient $filter",
      close: filter == '' ? true : false,
    );
    try {
      _patientList.addAll(patient);
      for (var p in _patientList) {
        _bilan.add(
          await getResult(
            query: "select * from bilan where patientId = ${p['id']}",
            close: filter == '' ? true : false,
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
    _editingController.addListener(() async {
      await initDB(
        filter: '''
                WHERE instr(lower(name ||' '|| prename) || ' '||
                 birth,("${_editingController.text.toLowerCase()}"))
                 OR  instr(lower(prename ||' '|| name)  || ' '||
                  birth,("${_editingController.text.toLowerCase()}"))
                ''',
      );
    });
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
              topBar(),
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
              color: Colors.black.withOpacity(0.5),
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
                  patient: _isAddPatient ? null : _patientList[_selectedPatient],
                  onAdd: () {
                    initDB();
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: _addTest,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.center,
              child: Card(
                child: Container(
                  height: 500,
                  width: 900,
                  margin: const EdgeInsets.all(10),
                  child: AddTest(
                    patient: _patientList.isNotEmpty ? _patientList[_selectedPatient]['id'] : 0,
                    test: _testId,
                    onTap: () {
                      setState(() {
                        _addTest = false;
                      });
                    },
                  ),
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
      itemCount: _bilan.isNotEmpty ? _bilan[index].length : 0,
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
              style: TextStyle(fontSize: 11, color: index == _selectedPatient ? Colors.black : Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget topBar() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                widget.onTap!();
              },
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: search(),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            height: double.infinity,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _showPatientWindow = true;
                      _isAddPatient = true;
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.green[400],
                    size: 40,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showPatientWindow = true;
                      _isAddPatient = false;
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue[400],
                    size: 40,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(15),
                          content: Container(
                            color: Colors.white,
                            width: 250,
                            height: 100,
                            child: Column(
                              children: [
                                Text("Voulez-vous vraiment supprimer le patient ${_patientList[_selectedPatient]['name']} ${_patientList[_selectedPatient]['prename']}"),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Anuller'),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          final int id = _patientList[_selectedPatient]['id'];
                                          final name = _patientList[_selectedPatient]['name'];
                                          final prename = _patientList[_selectedPatient]['prename'];
                                          if (_selectedPatient != -1) {
                                            await getResult(query: "delete from patient where id = $id");
                                            await initDB();
                                            if (_selectedPatient > _patientList.length - 1) {
                                              _selectedPatient = _patientList.length - 1;
                                            }
                                            getResult(query: "delete from bilan where patientId = $id");
                                            getResult(query: "delete from patientTest where patientId = $id");
                                          }
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Le patient $name $prename a été avec succès.",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget search() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _editingController,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Chercher",
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (_editingController.text != '') {
              await initDB();
              _editingController.text = '';
            }
          },
          child: Icon(
            _editingController.text == '' ? Icons.search : Icons.cancel_outlined,
            size: 35,
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
              contentPadding: const EdgeInsets.all(15),
              content: Container(
                color: Colors.white,
                width: 500,
                height: 80,
                child: FutureBuilder(
                    future: getResult(
                      query: "Select * from testCategory",
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: (snapshot.data as List<dynamic>).length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _testId = (snapshot.data as List<dynamic>)[index]['id'];
                                  _addTest = !_addTest;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 500,
                                height: 40,
                                padding: const EdgeInsets.all(6),
                                alignment: Alignment.centerLeft,
                                child: Text("${index + 1}- " + (snapshot.data as List<dynamic>)[index]['name']),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("Chargement"),
                        );
                      }
                    }),
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
