import 'dart:math';
import 'package:anagram/notifier.dart';
import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  final List<Pastille> pastList = [];
  final List<Pastille> preserved = [];
  List<String> letters = [
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'a',
    'b',
    'b',
    'c',
    'c',
    'd',
    'd',
    'd',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'e',
    'f',
    'f',
    'g',
    'g',
    'h',
    'h',
    'i',
    'i',
    'i',
    'i',
    'i',
    'i',
    'i',
    'i',
    'j',
    'k',
    'l',
    'l',
    'l',
    'l',
    'l',
    'm',
    'm',
    'm',
    'n',
    'n',
    'n',
    'n',
    'n',
    'n',
    'o',
    'o',
    'o',
    'o',
    'o',
    'o',
    'p',
    'p',
    'q',
    'r',
    'r',
    'r',
    'r',
    'r',
    'r',
    's',
    's',
    's',
    's',
    's',
    's',
    't',
    't',
    't',
    't',
    't',
    't',
    'u',
    'u',
    'u',
    'u',
    'u',
    'u',
    'v',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

// complète la pioche si besoin
  void autoPick() {
    print('appel autopick');
    while (pastList.length < 10) {
      int rnd = Random().nextInt(letters.length);
      setState(() {
        pastList.add(
          Pastille(
            lettre: letters[rnd],
            color: Colors.purple,
            key: UniqueKey(),
            animation: PastAnim.appear,
          ),
        );
        letters.remove(letters[rnd]);
      });
      // pickerStock.value = pastList.map((e) => e.lettre).toList();
    }

    pickerStock.value = pastList.map((e) => e.lettre).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (pastList.isEmpty) {
      autoPick();
    }

    // à l'écoute de si une ligne est sélectionnée
    selectedLine.addListener(() {
      if (selectedLine.value != 0) {
        setState(() {
          preserved.clear();
          preserved.addAll(pastList);
        });
      }
    });

    // à l'écoute de si une ligne libère la sélection
    playerChoice.addListener(() {
      if (playerChoice.value == GameAction.cancel) {
        List<Pastille> transfert =
            preserved.where((past) => !pastList.contains(past)).toList();
        print('Picker : $transfert');
        setState(() {
          pastList.addAll(transfert);
        });
      } else {
        autoPick();
      }
      playerChoice.value = GameAction.wait;
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: pastList
              .map(
                (pastille) => Draggable<Pastille>(
                  data: pastille,
                  feedback: pastille,
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: pastille,
                  ),
                  child: pastille,
                  onDragCompleted: () {
                    setState(() {
                      pastList.removeWhere((past) => past == pastille);
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
