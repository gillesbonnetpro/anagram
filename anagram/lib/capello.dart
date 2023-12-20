import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

class Capello {
  static final Capello _singleton = Capello._internal();

  factory Capello() {
    return _singleton;
  }

  Capello._internal();

  Future<String> starter() {
    return Future.value('OK !!');
  }

  Future<String?> loadAsset() async {
    print('début de lecture dans cappelo');
    await rootBundle.loadString('assets/res/ODS231219.txt').then((value) {
      return 'dico lu';
    }).catchError((error) {
      return '$error';
    });
  }

  Map<int, List<String>> dico = {};

  Future<String?> readFileAsync() {
    print('début de lecture fichier');
    File file = File('./assets/res/ODS231219.txt'); // (1)
    Future<String> futureContent = file.readAsString();
    return futureContent.then((c) {
      print('fichier lu. début répartition');
      List<String> ccut = c.split(' ');
      for (var element in ccut) {
        if (element.length > 2 && element.length < 16) {
          if (!dico.keys.contains(element.length)) {
            dico[element.length] = [];
          }
          dico[element.length]!.add(element);
        }
      }
      print('fin répartition');

      dico.keys.forEach((lng) {
        print('$lng ${dico[lng]!.length}');
      });

      dico[3]!.forEach((element) {
        print(element);
      });

      return 'dico prêt';
    }); // (3)
  }

  bool checkWord(String candidate) {
    print('recherche de mots : lng ${candidate.length}');
    print('recherche parmi ${dico[candidate.length]!.length}');
    bool isOk;
    List<String> around;

    isOk = dico[candidate.length] == null
        ? false
        : dico[candidate.length]!.contains(candidate);

    if (!isOk) {
      around = [...dico[candidate.length]!];
      around.removeWhere((element) => element[0] != candidate[0]);
      print('initiales : $around');
    }
    return isOk;
  }
}
