import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'dart:convert' as convert;

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedRow = 0;
  final _history = [];
  final _answers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: FutureBuilder(
                future: getResult(
                  query: '''Select patient.name,patient.prename,patientTest.date,patientTest.test,patientTest.catId from patientTest INNER JOIN patient on patient.id = patientTest.patientId''',
                ),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    _history.addAll((snapshot.data) as List<dynamic>);
                    return Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: ((snapshot.data) as List<dynamic>).length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRow = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _selectedRow == index ? Colors.blue : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: _selectedRow == index ? 0 : 0.7,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              _history[index]['name'],
                                              style: TextStyle(
                                                fontSize: _selectedRow == index ? 18 : 14,
                                                fontWeight: _selectedRow == index ? FontWeight.w600 : FontWeight.normal,
                                                color: _selectedRow == index ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              _history[index]['prename'],
                                              style: TextStyle(
                                                fontSize: _selectedRow == index ? 18 : 14,
                                                fontWeight: _selectedRow == index ? FontWeight.w600 : FontWeight.normal,
                                                color: _selectedRow == index ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _history[index]['date'],
                                              style: TextStyle(
                                                fontSize: _selectedRow == index ? 18 : 14,
                                                fontWeight: _selectedRow == index ? FontWeight.w600 : FontWeight.normal,
                                                color: _selectedRow == index ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: _selectedRow == index ? 0 : 0.7,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: FutureBuilder(
                              future: getResult(
                                query: '''
                                    select * from test where testCategory = ${_history[_selectedRow]['catId']}
                                    ''',
                              ),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  var data = [];
                                  data.addAll(snapshot.data as List<dynamic>);
                                  _answers.clear();
                                  _answers.addAll(convert.jsonDecode(_history[_selectedRow]['test']));
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (_, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(6),
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(data[index]['question']),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Container(
                                              height: 7,
                                              width: 7,
                                              margin: const EdgeInsets.symmetric(horizontal: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(_answers[index]),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                          // child: FutureBuilder(
                          //   future: testResult(_selectedRow),
                          //   builder: (_, snapshot) {
                          //     if (snapshot.hasData) {
                          //       return answerWidget(snapshot.hasData);
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const Text("Chargement"),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
