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
  final TextEditingController _editingController = TextEditingController();
  String _filter = '';
  int _selectedRow = 0;
  //final _history = [];
  final _answers = [];

  @override
  void initState() {
    super.initState();
    _editingController.addListener(() {
      setState(() {
        if (_editingController.text != '') {
          _filter = '''
        WHERE instr(lower(patient.name ||' '|| patient.prename),("${_editingController.text.toLowerCase()}"))
                 OR  instr(lower(patient.prename ||' '|| patient.name),("${_editingController.text.toLowerCase()}"))
        ''';
        } else {
          setState(() {
            _filter = '';
          });
        }
      });
    });
  }

  Future<dynamic> initDB({filter = ''}) async {
    setState(() {
      _answers.clear();
    });
    return getResult(
      query:
          '''Select patient.name,patient.prename,patientTest.date,patientTest.test,patientTest.catId,testCategory.name as 'category' from patientTest INNER JOIN patient on patient.id = patientTest.patientId INNER JOIN testCategory on testCategory.id = patientTest.catId $filter''',
          close:false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          topBar(),
          Container(
            height: 45,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text('Nom'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Prénom'),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Date Du Test'),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text('Test'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Note'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: const [
                        // SizedBox(
                        //   width: 12,
                        // ),
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
                future: initDB(filter: _filter),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    //_history.addAll((snapshot.data) as List<dynamic>);
                    if (((snapshot.data) as List<dynamic>).isNotEmpty) _answers.addAll(convert.jsonDecode(((snapshot.data) as List<dynamic>)[_selectedRow]['test']));
                    if (((snapshot.data) as List<dynamic>).isEmpty) return Container();
                    return Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                              controller: _patientControler,
                              itemCount: ((snapshot.data) as List<dynamic>).length,
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _answers.clear();
                                      _answers.addAll(convert.jsonDecode(((snapshot.data) as List<dynamic>)[index]['test']));
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
                                              flex: 3,
                                              child: Text(
                                                ((snapshot.data) as List<dynamic>)[index]['name'],
                                                style: TextStyle(
                                                  fontSize: _selectedRow == index ? 18 : 14,
                                                  fontWeight: _selectedRow == index ? FontWeight.w600 : FontWeight.normal,
                                                  color: _selectedRow == index ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ((snapshot.data) as List<dynamic>)[index]['prename'],
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
                                                ((snapshot.data) as List<dynamic>)[index]['date'],
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
                                                ((snapshot.data) as List<dynamic>)[index]['category'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: _selectedRow == index ? 18 : 14,
                                                  fontWeight: _selectedRow == index ? FontWeight.w600 : FontWeight.normal,
                                                  color: _selectedRow == index ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                testResult(((snapshot.data) as List<dynamic>)[index]['test']),
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
                                    select * from test where testCategory = ${((snapshot.data) as List<dynamic>)[_selectedRow]['catId']}
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

  String testResult(result) {
    String note = '';
    List<dynamic> list = convert.jsonDecode(result);
    if (list.isNotEmpty) {
      if (list[0] == 'Oui' || list[0] == 'Non') {
        int ouiCount = 0, nonCount = 0;
        for (String str in list) {
          if (str == 'Oui') ouiCount++;
          if (str == 'Non') nonCount++;
        }
        note = "Oui($ouiCount),Non($nonCount)";
      } else {
        double value = 0;
        for (String str in list) {
          if (str != 'N/A') value += double.parse(str);
        }
        value = value;
        note = value.toStringAsFixed(1) + "/${list.length * 4}";
      }
    }
    return note;
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
          onTap: () {
            if (_editingController.text != '') {
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
}
