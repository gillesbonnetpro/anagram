import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

class WordLine extends StatefulWidget {
  WordLine(
      {super.key,
      required this.id,
      required this.callback,
      required this.isSelected,
      required this.isOneSelected});

  int id;
  Function(int) callback;
  bool isSelected;
  bool isOneSelected;

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
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () => widget.callback(0),
                    child: const Icon(Icons.check_circle)),
                ElevatedButton(
                    onPressed: () {
                      widget.callback(0);
                    },
                    child: const Icon(Icons.close)),
              ],
            ),
          ),
          DragTarget<Pastille>(
            onWillAccept: (pastille) =>
                accepted.length < 11 &&
                (widget.isSelected || !widget.isOneSelected),
            onAccept: (pastille) {
              setState(() {
                accepted.add(pastille);
              });
              widget.callback(widget.id);
            },
            onLeave: null,
            builder: (context, candidates, rejected) => Container(
              height: 60,
              width: 700,
              color: widget.isSelected ||
                      (candidates.isNotEmpty && !widget.isOneSelected)
                  ? Colors.amber
                  : Colors.grey,
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
