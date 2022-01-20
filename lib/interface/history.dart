import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'dart:convert' as convert;

class History extends StatefulWidget {
  const History({Key? key, this.onTap}) : super(key: key);
  final Function? onTap;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final ScrollController _patientControler = ScrollController();
  final ScrollController _testController = ScrollController();
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
          const SizedBox(
            height: 6,
          ),
          topBar(),
          const SizedBox(
            height: 6,
          ),
          Container(
            height: 45,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
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
                        child: Text('Date Du Test'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text('Question'),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      SizedBox(
                        width: 57,
                        child: Text('Reponse'),
                      ),
                    ],
                  ),
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
                          flex: 5,
                          child: ListView.builder(
                            controller: _patientControler,
                            itemCount: ((snapshot.data) as List<dynamic>).length,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _answers.clear();
                                    _answers.addAll(convert.jsonDecode(_history[index]['test']));
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
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: FutureBuilder(
                              future: getResult(
                                query: '''
                                    select * from test where testCategory = ${_history[_selectedRow]['catId']}
                                    ''',
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                  return ListView.builder(
                                    controller: _testController,
                                    itemCount: (snapshot.data as List<dynamic>).length,
                                    itemBuilder: (_, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(6),
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text((snapshot.data as List<dynamic>)[index]['question']),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Container(
                                              height: 7,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
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
          const SizedBox(
            height: 6,
          ),
        ],
      ),
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
      ],
    );
  }
}
