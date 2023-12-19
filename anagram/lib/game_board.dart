import 'package:anagram/picker.dart';
import 'package:anagram/word_line.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});
  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<WordLine> lineList = [];

  @override
  Widget build(BuildContext context) {
    lineList = [
      WordLine(id: 1),
      WordLine(id: 2),
      WordLine(id: 3),
      WordLine(id: 4),
      WordLine(id: 5),
    ];

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [...lineList, const Picker()]),
    );
  }
}
