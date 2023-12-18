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
  List<String> letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        height: 120,
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
                  });
                },
                icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
