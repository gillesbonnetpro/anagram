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
  late List<WordLine> lineList;

  @override
  void initState() {
    lineList = [
      WordLine(id: 1),
      WordLine(id: 2),
      WordLine(id: 3),
    ];

    super.initState();
  }

  void addLine() {
    selectedLineNotifier.value = 0;
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: lineList,
                      ),
                    ]),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Picker()),
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
      ),
    );
  }
}
