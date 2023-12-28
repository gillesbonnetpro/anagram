import 'dart:convert';
import 'dart:io';
import 'package:anagram/notifier.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

    print('début lecture du fichier');
 
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
     
      return 'Anna Gram';
    });
  }

// vérifie si le mot existe
  bool checkWord(String candidate) {
    int nbLetters = candidate.length;
    print('recherche de mots : lng ${nbLetters} pour $candidate');
    print('recherche parmi ${dico[nbLetters]!.length}');
    bool isOk;
    List<String> around;
    

    candidate = candidate.toLowerCase();

    isOk = dico[nbLetters] == null
        ? false
        : dico[nbLetters]!.contains(candidate);

    if (!isOk) {
      around = [...dico[nbLetters]!];
      around.removeWhere((element) => element[0] != candidate[0]);
      print('initiales : $around');
    }
    return isOk;
  }


  // cherche si un mot avec une lettre de + est possible
  String searchOpti(String basis) {
    List<String> basisLetters = [];
    List<String> solutionLetters = [];
    Map<String, List<String>> solution = {};

    //éclatement mot de base en tableau de lettres
    for (String letter in basis.characters) {
      basisLetters.add(letter);
    }

    // recherche parmi tous les mots de longueur +1
    for (var mot in dico[(basis.length + 1)]!) {
      mot = mot.toLowerCase();
      // print('test du mot $mot');
      List<String> diff = [];
      List<String> motTest = mot.split('');

      for (var lettre in basisLetters) {
        if (motTest.contains(lettre)) {
          motTest.removeAt(motTest.indexOf(lettre));
        } else {
          diff.add(lettre);
        }

      motTest.addAll(diff);
      if (motTest.length == 1 &&
          _pickerStock.contains(motTest.first.toLowerCase())) {
        print(
            '$validated et $mot sont séparés de ${motTest} - pioche : ${_pickerStock.contains(motTest.first.toLowerCase())}');

      }
      // cumul des différences de lettres entre les 2 mots;
      diff.addAll(motTest);
      //print('diff $mot / $basis : $diff');

      // si une seule différence, on retient cette solution
      if (diff.length == 1 && _pickerStock.contains(diff.first)) {
        if (solution[diff.first] == null) {
          solution[diff.first] = [];
        }
        print('je retiens le mot $mot pour la lettre ${diff.first}');
        solution[diff.first]!.add(mot);
      }
    }

    // tous les mots sont passés en revue, on retourne
    // la lettre la plus fréquente
    solution.forEach((key, value) {
      print('lettre $key : ${value.length} mots');
    });

    if (solution.isEmpty) {
      return 'XXX';
    } else {
      solutionLetters = solution.keys.toList();

      solutionLetters.sort((a, b) => solution[b]!.length - solution[a]!.length);

      print(solutionLetters.isEmpty
          ? 'pas de solution'
          : 'je retourne la lettre ${solutionLetters.first}');

      return solutionLetters.first;
    }
  }
}
