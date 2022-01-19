import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/helper/formater.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key, this.onTap, this.onAdd}) : super(key: key);
  final Function? onTap;
  final Function? onAdd;

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  DateTime now = DateTime.now();

  final List<File> _bilan = [];
  String _uploadedBilan = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Nom"),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                height: 30,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Nom',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Prénom"),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                height: 30,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _prenameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Prénom',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Née"),
              const Spacer(),
              SizedBox(
                width: 250,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: _dayController.text == '' || int.parse(_dayController.text) > 31 || int.parse(_dayController.text) < 1 ? Colors.red[100]!.withOpacity(0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _dayController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'(^\d*?\d*)')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: 'JJ',
                        ),
                      ),
                    ),
                    const Text("/"),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: _monthController.text == '' || int.parse(_monthController.text) > 12 || int.parse(_monthController.text) < 1 ? Colors.red[100]!.withOpacity(0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _monthController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'(^\d*?\d*)')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: 'MM',
                        ),
                      ),
                    ),
                    const Text("/"),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        color: _yearController.text == '' || int.parse(_yearController.text) > now.year ? Colors.red[100]!.withOpacity(0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _yearController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'(^\d*?\d*)')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: 'AAAA',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Text("Bilan"),
              const Spacer(),
              Container(
                width: 220.5,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _uploadedBilan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    _bilan.add(File(result.files.single.path!));
                    setState(() {
                      _uploadedBilan += result.files.single.name + ', ';
                    });
                  }
                },
                child: const SizedBox(width: 17, child: Icon(Icons.file_upload_outlined)),
              ),
              const SizedBox(
                width: 7.5,
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onTap!();
                  },
                  child: const Text(
                    "Annuler",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    var result = await insertRow(
                      table: 'patient',
                      values: {
                        'name': _nameController.text,
                        'prename': _prenameController.text,
                        'birth': parseDate(day: _dayController.text, month: _monthController.text, year: _yearController.text),
                      },
                    );
                    try {
                      int patientId = result;
                      for (File file in _bilan) {
                        await insertBlob(
                          id: patientId,
                          bilan: file,
                        );
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    } finally {
                      widget.onAdd!();
                    }
                  },
                  child: const Text(
                    "Ajouter",
                    //_operation == 0 ? "Mettre à jour" : "Ajouter",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
