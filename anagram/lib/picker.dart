import 'dart:math';

import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  final List<Pastille> pastList = [];
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
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
            IconButton(
                onPressed: () {
                  int rnd = Random().nextInt(letters.length);
                  setState(() {
                    pastList.add(
                      Pastille(
                        lettre: letters[rnd],
                        color: Colors.blue,
                        key: UniqueKey(),
                      ),
                    );
                    letters.remove(letters[rnd]);
                  });
                },
                icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
