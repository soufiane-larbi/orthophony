import 'package:flutter/material.dart';

class AnswersList extends StatefulWidget {
  const AnswersList({Key? key, this.torF = true, this.onTap}) : super(key: key);
  final bool torF;
  final Function? onTap;

  @override
  _AnswersListState createState() => _AnswersListState();
}

class _AnswersListState extends State<AnswersList> {
  double selected = -1;

  Widget option({index, text}) {
    return InkWell(
      onTap: () {
        setState(() {
          selected = index;
        });
        widget.onTap!(text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: widget.torF ? 8 : 16),
        decoration: BoxDecoration(
          color: selected == index ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(text),
      ),
    );
  }

  List<Widget> answers() {
    List<Widget> list = [];
    if (widget.torF) {
      list.add(option(index: 0, text: 'Oui'));
      list.add(option(index: 1, text: 'Non'));
    } else {
      for (double i = 1; i < 4; i = i + 0.5) {
        list.add(
          option(index: i, text: i.toString()),
        );
      }
    }

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
