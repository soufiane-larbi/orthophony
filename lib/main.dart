import 'package:flutter/material.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/interface/history.dart';
import 'package:orthophonie/interface/patient.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userKey;
String productKey = "Khaled|Brahimi|2022";
late final prefs;
void main() async {
  await initDatabase();
  prefs = await SharedPreferences.getInstance();
  userKey = prefs.getString('userKey') ?? "";
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _activationController = TextEditingController();
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
      body: userKey == productKey ? _screens[_selectedScreen] : activation(),
    );
  }

  Widget activation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text("Entrer le code d'activation")),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _activationController,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Code d'Activation",
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              prefs.setString('userKey', _activationController.text);
              userKey = _activationController.text;
            });
            if (userKey != productKey) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Le Code Est Invalide",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
          child: const Text('Valider'),
        ),
      ],
    );
  }

  Widget mainScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        image: const DecorationImage(
          image: AssetImage('assets/home.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
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
                },
                background: 'assets/patiantImg.jpeg'),
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
                background: 'assets/historyImg.jpeg'),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: menu(
              title: 'Info',
              image: 'assets/About.png',
              background: 'assets/aboutImg.jpeg',
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

  Widget menu({title, image, ontap, background}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/$background'),
            fit: BoxFit.cover,
          ),
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
