import 'package:anagram/capello.dart';
import 'package:anagram/game_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*   print('je lance la lecture');
    rootBundle.loadString('assets/res/ODS231219.txt').then((value) {
      print('$value');
    }).catchError((error) {
      print('$error');
    });
 */
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
  var s1 = Capello();

  @override
  Widget build(BuildContext context) {
    ;
    return FutureBuilder<String?>(
        future: s1.readFileAsync(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: FittedBox(child: Text(snapshot.data!)),
                  ),
                  body: const GameBoard(),
                )
              : Center(child: CircularProgressIndicator());
        });
  }
}
