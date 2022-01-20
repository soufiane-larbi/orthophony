import 'package:flutter/material.dart';
import 'package:orthophonie/interface/history.dart';
import 'package:orthophonie/interface/patient.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Widget> _screens;
  int _selectedScreen = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      mainScreen(),
      Patient(
        onTap: () {
          setState(() {
            _selectedScreen = 0;
          });
        },
      ),
      History(
        onTap: () {
          setState(() {
            _selectedScreen = 0;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.blue[100],
          height: double.infinity,
          width: double.infinity,
          child: _screens[_selectedScreen],
        ),
      ),
    );
  }

  Widget mainScreen() {
    return Column(
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menu(
                title: 'Patiants',
                image: 'assets/Patients.png',
                ontap: () {
                  setState(() {
                    _selectedScreen = 1;
                  });
                }),
            menu(
              title: 'Tests',
              image: 'assets/Tests.png',
              ontap: () {
                setState(() {
                  _selectedScreen = 2;
                });
              },
            ),
            menu(title: 'Patiants', image: 'assets/Patients.png'),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menu(title: 'Patiants', image: 'assets/Patients.png'),
            menu(title: 'Tests', image: 'assets/Tests.png'),
            menu(title: 'Patiants', image: 'assets/Patients.png'),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget menu({title, image, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 270,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Image.asset(
                image,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
