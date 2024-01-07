import 'dart:io';
import 'dart:ui';
import 'package:anagram/capello.dart';
import 'package:anagram/game_board.dart';
import 'package:anagram/notifier.dart';
import 'package:anagram/pastille.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // gestion taille des fenetres desktop
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        size: Size(300, 800),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        title: 'Ana Gram',
        fullScreen: false);
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      debugShowCheckedModeBanner: false,
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
  var cappello = Capello();
  int _score = 0;
  bool _scoreChanged = false;
  /*  Pastille scorePast =
      Pastille(lettre: '0', color: Colors.blue, animation: PastAnim.none);
 */
  @override
  Widget build(BuildContext context) {
    scoreNotifier.addListener(() {
      print(
          'value ${scoreNotifier.value} - score : $_score - ${scoreNotifier.value > _score}');
      if (scoreNotifier.value > _score) {
        setState(() {
          _score = scoreNotifier.value;
          _scoreChanged = !_scoreChanged;
          print('changed $_scoreChanged');
        });
      }
    });

    return FutureBuilder<String?>(
        future: cappello.initiate(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: FittedBox(
                      child: Text(snapshot.data!),
                    ),
                    actions: [
                      FittedBox(
                        child: Pastille(
                                lettre: '$_score',
                                color: Colors.deepPurple,
                                animation: PastAnim.none,
                                maxSize: 50)
                            .animate(target: _scoreChanged ? 0 : 1)
                            .shimmer(duration: 1000.ms, color: Colors.amber)
                            .shake()
                            .then(delay: 100.milliseconds)
                            .animate(effects: List.empty()),
                      ),
                    ],
                  ),
                  body: const GameBoard(),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
