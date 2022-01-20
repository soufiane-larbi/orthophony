import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/helper/formater.dart';
import 'package:orthophonie/ui_elements/answers.dart';
import 'dart:convert' as convert;

class AddTest extends StatefulWidget {
  const AddTest({Key? key, required this.patient, required this.test}) : super(key: key);
  final int patient;
  final int test;
  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  final _patient = [], _test = [], _answers = [];
  bool _isTorF = false;

  initDB() async {
    _patient.addAll(
      await getResult(
        query: "select * from patient where id = ${widget.patient}",
      ),
    );
    _test.addAll(
      await getResult(
        query: "select * from test where testCategory = ${widget.test}",
      ),
    );
    if (_test[0]['TF'] == 1) _isTorF = true;
    for (int i = 0; i < _test.length; i++) {
      _answers.add('N/A');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Widget testWidget() {
    return ListView.builder(
      itemCount: _test.length,
      itemBuilder: (_, index) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(_test[index]['question']),
                  ),
                  Center(
                    child: Expanded(
                      flex: _isTorF ? 1 : 4,
                      child: AnswersList(
                        torF: _isTorF,
                        onTap: (value) {
                          _answers[index] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(width: double.infinity, height: 0.5, color: Colors.grey),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_patient.isEmpty) return Container();
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Annuler",
                    style: TextStyle(color: Colors.red),
                  )),
              const Spacer(),
              Text("${_patient[0]['name']} ${_patient[0]['prename']}"),
              const Spacer(),
              TextButton(
                  onPressed: () async {
                    if (_answers.contains('N/A')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Il faut répondre à toutes les questions",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      return;
                    }
                    String test = convert.jsonEncode(_answers);
                    String date = parseDate(
                      day: DateTime.now().day.toString(),
                      month: DateTime.now().month.toString(),
                      year: DateTime.now().year.toString(),
                    );
                    int patientId = widget.patient;
                    var result = await getResult(
                      query: '''
                      insert into patientTest (patientId,date,test,catId) 
                      values($patientId,'$date','$test',${widget.test})
                      ''',
                    );
                    if (!result.toString().contains('Error')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Test ajouté avec succès",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            result.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Ajouter")),
            ],
          ),
        ),
        Expanded(
          child: testWidget(),
        ),
      ],
    );
  }
}
