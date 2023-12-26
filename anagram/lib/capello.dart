import 'dart:convert';
import 'dart:io';

import 'package:anagram/notifier.dart';
import 'package:flutter/material.dart';

class Capello {
  static final Capello _singleton = Capello._internal();

  factory Capello() {
    return _singleton;
  }

  Capello._internal();

  Map<int, List<String>> dico = {};
  List<String> _pickerStock = [];

  Future<String?> initiate() {
    pickerStock.addListener(() {
      _pickerStock = pickerStock.value;
      //    print('stock : $_pickerStock');
    });

    File file = File('./assets/res/myODS.txt');
    Future<List<String>> futureContent = file.readAsLines();
    return futureContent.then((list) {
      print('fichier lu. début répartition');
      // List<String> ccut = c.split('\n');
      print('nb mots ${list.length}');

      for (String word in list) {
        if (word.length > 2 && word.length < 15) {
          if (dico[word.length] == null) {
            dico[word.length] = [];
          }
          dico[word.length]!.add(word.toLowerCase());
        }
      }
      /*   dico.keys.forEach((letterNb) {
        print('$letterNb => ${dico[letterNb]?.length ?? 0}');
      });

      print('${dico[3]}');
      print('${dico[3]!.last}'); */
      return 'Anna Gram';
    });
  }

  bool checkWord(String candidate) {
    int nbLetters = candidate.length;
    bool isOk;
    List<String> around;

    candidate = candidate.toLowerCase();

    isOk =
        dico[nbLetters] == null ? false : dico[nbLetters]!.contains(candidate);

    if (!isOk) {
      around = [...dico[nbLetters]!];
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
      if (motTest.length == 1 &&
          _pickerStock.contains(motTest.first.toLowerCase())) {
        print(
            '$validated et $mot sont séparés de ${motTest} - pioche : ${_pickerStock.contains(motTest.first.toLowerCase())}');
      }
    }
  }
}
