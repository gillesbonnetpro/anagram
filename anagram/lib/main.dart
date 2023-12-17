import 'dart:math';

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
  List<String> pastList = [];
  List<String> accepted = [];
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
          children: [
            Container(
              height: 70,
              width: 500,
              color: Colors.amber,
              child: DragTarget<String>(
                onWillAccept: (letter) => letter != null,
                onAccept: (letter) => setState(() {
                  pastList.removeWhere((element) => element == letter);
                  accepted.add(letter);
                }),
                onLeave: null,
                builder: (context, candidates, rejected) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: accepted
                      .map((e) => Draggable<String>(
                            data: e,
                            feedback: Pastille(lettre: e),
                            child: Pastille(lettre: e),
                          ))
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pastList
                  .map((e) => Draggable<String>(
                        data: e,
                        feedback: Pastille(lettre: e),
                        child: Pastille(lettre: e),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int rnd = Random().nextInt(letters.length);
          setState(() {
            pastList.add(letters[rnd]);
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
