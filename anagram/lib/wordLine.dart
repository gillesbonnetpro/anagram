import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

class WordLine extends StatefulWidget {
  WordLine({super.key});

  bool isSelected = false;

  @override
  State<WordLine> createState() => _WordLineState();
}

class _WordLineState extends State<WordLine> {
  List<Pastille> accepted = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 50,
            child: const Column(
              children: [
                IconButton.filled(
                    onPressed: null, icon: Icon(Icons.check_circle)),
                IconButton.filled(onPressed: null, icon: Icon(Icons.close)),
              ],
            ),
          ),
          DragTarget<Pastille>(
            onWillAccept: (pastille) => accepted.length < 11,
            onAccept: (pastille) => setState(() {
              accepted.add(pastille);
            }),
            onLeave: null,
            builder: (context, candidates, rejected) => Container(
              height: 60,
              width: 700,
              color: candidates.isEmpty ? Colors.grey : Colors.amber,
              child: ReorderableListView(
                proxyDecorator: (child, index, animation) => child,
                padding: EdgeInsets.zero,
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
                    .map(
                      (pastille) => ReorderableDragStartListener(
                        key: pastille.key,
                        index: accepted.indexOf(pastille),
                        child: Container(child: pastille),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
