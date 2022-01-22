import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orthophonie/helper/database.dart';
import 'package:orthophonie/helper/formater.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key, this.onTap, this.onAdd, this.patient}) : super(key: key);
  final Function? onTap;
  final Function? onAdd;
  final Map<dynamic, dynamic>? patient;

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
  bool _edit = false;

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _edit = true;
      _nameController.text = widget.patient!['name'] ?? '';
      _prenameController.text = widget.patient!['prename'] ?? '';
      _yearController.text = getDateYMD(date: widget.patient!['birth'])['year'] ?? '';
      _monthController.text = getDateYMD(date: widget.patient!['birth'])['month'] ?? '';
      _dayController.text = getDateYMD(date: widget.patient!['birth'])['day'] ?? '';
      initDB();
    }
  }

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
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  itemCount: _bilan.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.7,
                  ),
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 75,
                            child: Text(
                              _bilan[index].path.split('\\').last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _bilan.removeAt(index);
                              });
                            },
                            child: const Icon(Icons.cancel_outlined, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _bilan.add(File(result.files.single.path!));
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
                  onPressed: () {
                    editPatientDB();
                  },
                  child: Text(
                    _edit ? "Mettre à jour" : "Ajouter",
                    style: const TextStyle(
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

  initDB() async {
    var result = await getResult(
      query: '''
      select * from bilan where patientId = ${widget.patient!['id']}
      ''',
    );
    for (var bilan in result) {
      File file = File(bilan['name']);
      await file.writeAsBytes(bilan['bilan']);
      _bilan.add(file);
    }
    setState(() {});
  }

  Future<void> editPatientDB() async {
    if (_nameController.text == '' || _prenameController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Nom et Prénom doivent être renseignés.",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }
    if (_yearController.text == '' || _monthController.text == '' || _dayController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "L'année, le mois et le jour doivent être renseignés.",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }
    try {
      if (_edit) {
        await updateRows(
          table: 'patient',
          values: {
            'name': _nameController.text,
            'prename': _prenameController.text,
            'birth': parseDate(day: _dayController.text, month: _monthController.text, year: _yearController.text),
          },
          where: "id = ?",
          whereArgs: [widget.patient!['id']],
        );
        int patientId = widget.patient!['id'];
        await getResult(
          query: '''
          delete from bilan where patientId = ${widget.patient!['id']}
          ''',
        );
        for (File file in _bilan) {
          await insertBlob(
            id: patientId,
            bilan: file,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Patient modifié avec succès.",
              textAlign: TextAlign.center,
            ),
          ),
        );
        widget.onTap!();
      } else {
        var result = await insertRow(
          table: 'patient',
          values: {
            'name': _nameController.text,
            'prename': _prenameController.text,
            'birth': parseDate(day: _dayController.text, month: _monthController.text, year: _yearController.text),
          },
        );
        int patientId = result;
        for (File file in _bilan) {
          await insertBlob(
            id: patientId,
            bilan: file,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Patient ajouté avec succès.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      widget.onTap!();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } finally {
      widget.onAdd!();
    }
  }
}
