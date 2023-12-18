import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

class WordLine extends StatefulWidget {
  const WordLine({super.key});

  @override
  State<WordLine> createState() => _WordLineState();
}

class _WordLineState extends State<WordLine> {
  /*List<Pastille> pastList = [];*/
  List<Pastille> accepted = [];

  @override
  Widget build(BuildContext context) {
    return DragTarget<Pastille>(
      onWillAccept: (pastille) => accepted.length < 6,
      onAccept: (pastille) => setState(() {
        accepted.add(pastille);
      }),
      onLeave: null,
      builder: (context, candidates, rejected) => Container(
        height: 70,
        width: 700,
        color: candidates.isEmpty ? Colors.grey : Colors.amber,
        child: ReorderableListView(
          buildDefaultDragHandles: false,
          scrollDirection: Axis.horizontal,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final Pastille item = accepted.removeAt(oldIndex);
              accepted.insert(newIndex, item);
              for (Pastille pastille in accepted) {
                print(pastille.lettre);
              }
            });
          },
          children: accepted
              .map((pastille) => ReorderableDragStartListener(
                  key: pastille.key,
                  index: accepted.indexOf(pastille),
                  child: pastille))
              .toList(),
        ),
      ),
    );
  }
}
