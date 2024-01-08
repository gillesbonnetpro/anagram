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
              animation: PastAnim.validated,
            ),
          )
          .toList();
    });

    playerChoiceNotifier.value = GameAction.valid;
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
    selectedLineNotifier.addListener(() {
      setState(() {
        widget.isSelected = selectedLineNotifier.value == widget.id;
        widget.isOneSelected = selectedLineNotifier.value != 0;
        if (widget.isSelected) {
          preserved.clear();
          preserved = [...accepted];
        }
      });
    });

    // à l'écoute de si une ligne libère la sélection
    playerChoiceNotifier.addListener(() {
      setState(() {
        widget.isSelected = false;
        widget.isOneSelected = false;
        suggested = null;
      });
      selectedLineNotifier.value = 0;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, 3),
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  left: BorderSide(
                    color: Colors.amber,
                    width: 3.0,
                  ),
                  top: BorderSide(
                    color: Colors.amber,
                    width: 3.0,
                  ),
                  right: BorderSide(
                    color: Colors.amber,
                    width: 3.0,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: widget.isSelected ? Colors.amber : Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.isSelected) {
                        Capello().checkWord(
                                widget.id, getWordAsString().toUpperCase())
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
                        playerChoiceNotifier.value = GameAction.cancel;
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
                  if (accepted.isNotEmpty) ...[
                    null == suggested || suggested!.length > 1
                        ? IconButton(
                            onPressed: () => setState(() {
                              suggested =
                                  Capello().searchOpti(getWordAsString());
                            }),
                            icon: null == suggested
                                ? const Icon(Icons.lightbulb)
                                : const Icon(Icons.close),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 20),
                              width: 24,
                              child: Image(
                                image: AssetImage(
                                    'assets/res/lettres/${suggested!}.png'),
                              ),
                            )

                            /* Text(
                              suggested!,
                              style: const TextStyle().copyWith(fontSize: 25),
                            ), */
                            )
                  ]
                ],
              ),
            ),
          ),
          Center(
            child: IntrinsicHeight(
              child: DragTarget<Pastille>(
                onWillAccept: (pastille) =>
                    accepted.length < 12 &&
                    (widget.isSelected || !widget.isOneSelected),
                onAccept: (pastille) {
                  if (!widget.isSelected) {
                    selectedLineNotifier.value = widget.id;
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
                    border: Border.all(
                      color: Colors.amber,
                      width: 3.0,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: widget.isSelected ||
                            (candidates.isNotEmpty && !widget.isOneSelected)
                        ? Colors.amber
                        : Colors.white,
                  ),
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
                              (pastille) => widget.isSelected
                                  ? ReorderableDragStartListener(
                                      key: pastille.key,
                                      index: accepted.indexOf(pastille),
                                      child: Center(
                                        child: Pastille(
                                          lettre: pastille.lettre,
                                          color: pastille.color,
                                          animation: PastAnim.none,
                                        ),
                                      ),
                                    )
                                  : IgnorePointer(
                                      key: pastille.key,
                                      child: Center(
                                        child: Pastille(
                                          lettre: pastille.lettre,
                                          color: pastille.color,
                                          animation: PastAnim.validated,
                                        ),
                                      ),
                                    ),
                            )
                            .toList(),
                      ),
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
              ),
            ),
          )
        ],
      ).animate(effects: actual),
    );
  }
}
