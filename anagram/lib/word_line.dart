import 'dart:ffi';

import 'package:anagram/capello.dart';
import 'package:anagram/pastille.dart';
import 'package:anagram/shared_effects.dart';
import 'package:flutter/material.dart';
import 'package:anagram/notifier.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  String? suggested;
  WordLineState wordLineState = WordLineState.neutral;

  // retourne la suite de pastilles sous forme de String
  String getWordAsString() {
    String word = '';
    for (var pastille in accepted) {
      word += pastille.lettre;
    }
    return word;
  }

  // déclenché lors de la validation d'un mot
  void validated() {
    playerChoice.value = GameAction.valid;
    wordLineState = WordLineState.validated;
    print('ligne ${widget.id} validée ');
  }

// déclenché lors du refus d'un mot
  void refused() {
    wordLineState = WordLineState.refused;
    print('mot inconnu ${getWordAsString()}');
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
          wordLineState = WordLineState.neutral;
        }
      });
    });

    // à l'écoute de si une ligne libère la sélection
    playerChoice.addListener(() {
      setState(() {
        widget.isSelected = false;
        widget.isOneSelected = false;
        suggested = null;
      });
      selectedLine.value = 0;
    });

    dynamic getPastilleList() {
      List<Widget> pastilles = accepted
          .map(
            (pastille) => widget.isSelected
                ? ReorderableDragStartListener(
                    key: pastille.key,
                    index: accepted.indexOf(pastille),
                    child: Container(child: pastille),
                  )
                : IgnorePointer(
                    key: pastille.key,
                    child: Container(child: pastille),
                  ),
          )
          .toList();

      switch (wordLineState) {
        case WordLineState.validated:
          print("liste animée pour validation");
          return AnimateList(
              effects: validatedWord,
              interval: const Duration(milliseconds: 400),
              children: pastilles);
        case WordLineState.refused:
          print("liste animée pour refus");
          return AnimateList(
              effects: validatedWord,
              interval: const Duration(milliseconds: 400),
              children: pastilles);
        case WordLineState.neutral:
          return ReorderableListView(
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
            children: pastilles,
          );
      }
    }

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
                      Capello().checkWord(getWordAsString().toUpperCase())
                          ? validated()
                          : refused();
                    } else {
                      print('Valide sur ligne non selectionnée');
                    }
                  },
                  child: const Icon(Icons.check_circle),
                ),
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
                  child: const Icon(Icons.close),
                ),
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
              child: getPastilleList(),
            ),
          ),
          if (accepted.isNotEmpty) ...[
            null == suggested || suggested!.length > 1
                ? IconButton(
                    onPressed: () => setState(() {
                      suggested = Capello().searchOpti(getWordAsString());
                    }),
                    icon: null == suggested
                        ? const Icon(Icons.lightbulb)
                        : const Icon(Icons.close),
                  )
                : Pastille(
                    lettre: suggested!, color: Colors.amber, animated: true)
          ]
        ],
      ),
    );
  }
}

enum WordLineState { validated, refused, neutral }
