import 'package:anagram/capello.dart';
import 'package:anagram/pastille.dart';
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

  List<Effect> shake = [ShakeEffect(duration: 1.seconds)];
  List<Effect> none = [];
  late List<Effect> actual = [];

  // retourne la liste de pastilles sous forme de String
  String getWordAsString() {
    String word = '';
    for (var pastille in accepted) {
      word += pastille.lettre;
    }
    return word;
  }

  // en cas de validation du mot
  void validated() {
    print('mot validé ${getWordAsString()}');
    setState(() {
      accepted = accepted
          .map(
            (past) => Pastille(
                key: past.key,
                lettre: past.lettre,
                color: Colors.deepPurple,
                animation: PastAnim.validated),
          )
          .toList();
    });

    playerChoice.value = GameAction.valid;
  }

  // en cas de refus du mot
  void refused() {
    setState(() {
      actual = shake;
      Future.delayed(const Duration(seconds: 1)).then((_) {
        actual = none;
      });
    });
    print('mot refusé ${getWordAsString()}');
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.isSelected) {
                      Capello().checkWord(getWordAsString().toUpperCase())
                          ? validated()
                          : refused();
                    } else {
                      print('Valide sur ligne non selectionnée');
                    }
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                IconButton(
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
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: DragTarget<Pastille>(
              onWillAccept: (pastille) =>
                  accepted.length < 12 &&
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: widget.isSelected ||
                          (candidates.isNotEmpty && !widget.isOneSelected)
                      ? Colors.amber
                      : Colors.grey,
                ),
                height: 60,
                width: 700,
                child: Stack(children: [
                  ReorderableListView(
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
                        .toList(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      child: Opacity(
                        opacity: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            widget.id.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ).animate(effects: actual),
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
                    lettre: suggested!,
                    color: Colors.amber,
                    animation: PastAnim.appear)
          ]
        ],
      ),
    );
  }
}
