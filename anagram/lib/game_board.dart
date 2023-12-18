import 'package:anagram/picker.dart';
import 'package:anagram/wordLine.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  GameBoard({super.key});
  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<WordLine> lineList = [];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    lineList = [
      WordLine(
          id: 1,
          callback: setSelected,
          isSelected: selected == 1,
          isOneSelected: selected != 0),
      WordLine(
          id: 2,
          callback: setSelected,
          isSelected: selected == 2,
          isOneSelected: selected != 0),
      WordLine(
          id: 3,
          callback: setSelected,
          isSelected: selected == 3,
          isOneSelected: selected != 0),
      WordLine(
          id: 4,
          callback: setSelected,
          isSelected: selected == 4,
          isOneSelected: selected != 0),
      WordLine(
          id: 5,
          callback: setSelected,
          isSelected: selected == 5,
          isOneSelected: selected != 0),
    ];

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [...lineList]..add(const Picker())),
    );
  }

  void setSelected(int id) {
    print('callback ${id}');

    setState(() {
      selected = id;
    });
  }
}
