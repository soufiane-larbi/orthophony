import 'package:flutter/material.dart';

class AddTest extends StatefulWidget {
  const AddTest({Key? key, required this.patient, required this.test}) : super(key: key);
  final int patient;
  final int test;
  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
