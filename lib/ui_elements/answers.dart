import 'package:flutter/material.dart';

class AnswersList extends StatefulWidget {
  const AnswersList({Key? key, this.torF = true,this.onTap}) : super(key: key);
  final bool torF;
  final Function? onTap;

  @override
  _AnswersListState createState() => _AnswersListState();
}

class _AnswersListState extends State<AnswersList> {
  int selected = -1;

  List<Widget> answers() {
    List<Widget> list = [];
    list.add(
      InkWell(
        onTap: () {
          setState(() {
            selected = 0;
          });
          widget.onTap!('Oui');
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: selected == 0 ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Oui'),
        ),
      ),
    );
    list.add(
      InkWell(
        onTap: () {
          setState(() {
            selected = 1;
          });
          widget.onTap!('Non');
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: selected == 1 ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Non'),
        ),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: answers(),
    );
  }
}
