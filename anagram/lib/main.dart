import 'dart:math';

import 'package:anagram/wordLine.dart';
import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anagram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Anagram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pastille> pastList = [];
  List<Pastille> accepted = [];
  List<String> letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DragTarget<Pastille>(
              onWillAccept: (pastille) => pastille != null,
              onAccept: (pastille) => setState(() {
                pastList.removeWhere((pastilleOld) => pastille == pastilleOld);
                accepted.add(pastille);
              }),
              onLeave: null,
              builder: (context, candidates, rejected) => Container(
                height: 70,
                width: 500,
                color: candidates.isEmpty ? Colors.grey : Colors.amber,
                child: ReorderableListView(
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
                  children: accepted,
                ),
              ),
            ),
            const WordLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
