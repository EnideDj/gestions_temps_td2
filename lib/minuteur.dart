import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class ModeleMinuteur {
  String? temps;
  double? pourcentage;
  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _pourcentage = 1.0;
  bool _estActif = false;
  Duration _temps = Duration();
  Duration _tempsTotal = Duration();

  String temps = '00:00';
  double pourcentage = 1.0;

  int tempsTravail = TEMPS_TRAVAIL_DEFAUT;
  int tempsPauseCourte = TEMPS_PAUSE_COURTE_DEFAUT;
  int tempsPauseLongue = TEMPS_PAUSE_LONGUE_DEFAUT;

  void arreterMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() {
    if (_temps.inSeconds > 0) _estActif = true;
  }

  Future<void> lireParametres() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tempsTravail = prefs.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
    tempsPauseCourte = prefs.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
    tempsPauseLongue = prefs.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;
  }

  void demarrerTravail() async {
    await lireParametres();
    _temps = Duration(minutes: tempsTravail);
    _tempsTotal = _temps;
    _estActif = true;
  }

  void demarrerPause(bool courte) async {
    await lireParametres();
    _temps = Duration(minutes: courte ? tempsPauseCourte : tempsPauseLongue);
    _tempsTotal = _temps;
    _estActif = true;
  }

  String retournerTemps(Duration t) {
    String minutes = t.inMinutes.toString().padLeft(2, '0');
    int numSecondes = t.inSeconds - (t.inMinutes * 60);
    String secondes = numSecondes.toString().padLeft(2, '0');
    return '$minutes:$secondes';
  }

  Stream<ModeleMinuteur> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      if (_estActif) {
        _temps -= Duration(seconds: 1);
      }
      if (_temps.inSeconds <= 0) {
        _estActif = false;
        _temps = Duration();
      }

      _pourcentage = _tempsTotal.inSeconds != 0
          ? _temps.inSeconds / _tempsTotal.inSeconds
          : 1.0;

      temps = retournerTemps(_temps);
      pourcentage = _pourcentage;
      return ModeleMinuteur(temps, pourcentage);
    });
  }
}