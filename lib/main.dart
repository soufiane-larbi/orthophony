import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/interface/history.dart';
import 'package:orthophonie/interface/patient.dart';

void main() async {
  await initDatabase();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 110),
      child: Row(
        children: [
          Expanded(
            child: menu(
                title: 'Patiants',
                image: 'assets/Patients.png',
                ontap: () {
                  setState(() {
                    _selectedScreen = 1;
                  });
                }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: menu(
              title: 'Historique',
              image: 'assets/Tests.png',
              ontap: () {
                setState(() {
                  _selectedScreen = 2;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: menu(title: 'Info', image: 'assets/About.png'),
          ),
        ],
      ),
    );
  }

  Widget menu({title, image, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
