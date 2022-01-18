import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';

class Patient extends StatefulWidget {
  Patient({Key? key, this.onTap}) : super(key: key);
  Function? onTap;

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final ScrollController _scrollController = ScrollController();
  final _patientList = [];
  int _selectedPatient = 0;

  initDB() async {
    _patientList.addAll(
      await getResult(
        query: "select * from patient",
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: topBar(),
          ),
          Expanded(
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
            widget.onTap!();
          },
          child: const Icon(
            Icons.add,
            color: Colors.grey,
            size: 40,
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Icon(
            Icons.edit,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ],
    );
  }
}
