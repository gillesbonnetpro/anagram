import 'package:anagram/picker.dart';
import 'package:anagram/word_line.dart';
import 'package:flutter/material.dart';
import 'package:anagram/notifier.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});
  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<WordLine> lineList = [
    WordLine(id: 1),
    WordLine(id: 2),
    WordLine(id: 3),
  ];

  void addLine() {
    selectedLine.value = 0;
    lineList.add(
      WordLine(
        id: (lineList.length + 1),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: lineList,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Picker(),
                Tooltip(
                  message: 'Ajouter une ligne',
                  child: ElevatedButton(
                    onPressed: () => addLine(),
                    child: const Text('+'),
                  ),
                )
              ],
            )
          ]),
    );
  }
}
