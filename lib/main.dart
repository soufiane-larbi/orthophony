import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/interface/history.dart';
import 'package:orthophonie/interface/patient.dart';

void main() async {
  await initDatabase();
  runApp(const MaterialApp(home: MyApp()));
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
    return Scaffold(
      body: _screens[_selectedScreen],
    );
  }

  Widget mainScreen() {
    return Container(
      color: Colors.blue[100],
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 200),
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
          const SizedBox(width: 30),
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
          const SizedBox(width: 30),
          Expanded(
            child: menu(
              title: 'Info',
              image: 'assets/About.png',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      titlePadding: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      title: const Center(child: Text("Information")),
                      content: Container(
                        color: Colors.white,
                        width: 300,
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                  child: Icon(Icons.info_outlined),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Logiciel: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Orthophonie"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                  child: Icon(Icons.account_tree_rounded),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Version: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("1.0.0+55"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                  child: Icon(Icons.phone),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Developpeur: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Soufiane Larbi Aloui"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                  child: Icon(Icons.account_circle_outlined),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Mobile: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                SelectableText("0550 45 31 17"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                  child: Icon(Icons.email_outlined),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                SelectableText("larbialoui.soufiane@gmail.com"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
