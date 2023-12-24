import 'dart:io';

import 'package:anagram/notifier.dart';
import 'package:flutter/material.dart';

class Capello {
  static final Capello _singleton = Capello._internal();

  factory Capello() {
    return _singleton;
  }

  Capello._internal();

  /*  Future<String?> loadAsset() async {
    print('début de lecture dans cappelo');
    await rootBundle.loadString('assets/res/ODS231219.txt').then((value) {
      return 'dico lu';
    }).catchError((error) {
      return '$error';
    });
  } */

  Map<int, List<String>> dico = {};
  List<String> _pickerStock = [];

  Future<String?> initiate() {
    pickerStock.addListener(() {
      _pickerStock = pickerStock.value;
      print('stock : $_pickerStock');
    });

    File file = File('./assets/res/ODS231219.txt');
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
      return 'Anna Gram';
    });
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
    } else {
      search(candidate);
    }
    return isOk;
  }

  void search(String validated) {
    print('recherche de complément pour $validated');
    List<String> lettersCandidate = [];
    for (String letter in validated.characters) {
      lettersCandidate.add(letter);
    }

    for (var mot in dico[(validated.length + 1)]!) {
      List<String> diff = [];
      List<String> motTest = mot.split('');

      for (var lettre in lettersCandidate) {
        if (motTest.contains(lettre)) {
          motTest.removeAt(motTest.indexOf(lettre));
        } else {
          diff.add(lettre);
        }
      }
      motTest.addAll(diff);
      if (motTest.length == 1) {
        print(
            '$validated et $mot sont séparés de ${motTest} - pioche : ${_pickerStock.contains(motTest.first.toLowerCase())}');
      }
    }
  }
}
