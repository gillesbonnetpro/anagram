import 'package:anagram/capello.dart';
import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';
import 'package:anagram/notifier.dart';

class WordLine extends StatefulWidget {
  WordLine({
    super.key,
    required this.id,
  }) {
    isOneSelected = false;
    isSelected = false;
  }

  int id;
  late bool isSelected;
  late bool isOneSelected;

  @override
  State<WordLine> createState() => _WordLineState();
}

class _WordLineState extends State<WordLine> {
  List<Pastille> accepted = [];
  List<Pastille> preserved = [];

  String getWord() {
    String word = '';
    for (var pastille in accepted) {
      word += pastille.lettre;
    }
    return word;
  }

  @override
  Widget build(BuildContext context) {
// à l'écoute de si une ligne est sélectionnée
    selectedLine.addListener(() {
      setState(() {
        widget.isSelected = selectedLine.value == widget.id;
        widget.isOneSelected = selectedLine.value != 0;
        if (widget.isSelected) {
          preserved.clear();
          preserved = [...accepted];
          print('ligne ${widget.id} sauvegarde $preserved ');
        }
      });
      print('line ${widget.id} - selection ligne : ${selectedLine.value}');
    });

    // à l'écoute de si une ligne libère la sélection
    playerChoice.addListener(() {
      print(
          'line ${widget.id} - action : ${playerChoice.value} - selected : ${widget.isSelected}');
      setState(() {
        widget.isSelected = false;
        widget.isOneSelected = false;
      });
      selectedLine.value = 0;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (widget.isSelected) {
                        Capello().checkWord(getWord().toUpperCase())
                            ? playerChoice.value = GameAction.valid
                            : print('mot inconnu ${getWord()}');
                        print('ligne ${widget.id} validée ');
                      } else {
                        print('Valide sur ligne non selectionnée');
                      }
                    },
                    child: const Icon(Icons.check_circle)),
                ElevatedButton(
                    onPressed: () {
                      if (widget.isSelected) {
                        setState(() {
                          accepted.clear();
                          accepted = [...preserved];
                        });
                        playerChoice.value = GameAction.cancel;
                      } else {
                        // todo informer user
                        print('Cancel sur ligne non selectionnée');
                      }
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
              if (!widget.isSelected) {
                selectedLine.value = widget.id;
              }
              setState(() {
                accepted.add(pastille);
              });
              print(
                  'ligne actuelle : ${widget.id} - selected ? ${widget.isSelected}');
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
