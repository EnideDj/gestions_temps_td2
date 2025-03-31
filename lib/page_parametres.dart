import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'button.dart';

class PageParametres extends StatefulWidget {
  @override
  _ParametreState createState() => _ParametreState();
}

class _ParametreState extends State<PageParametres> {
  TextEditingController txtTempsTravail = TextEditingController();
  TextEditingController txtTempsPauseCourte = TextEditingController();
  TextEditingController txtTempsPauseLongue = TextEditingController();

  @override
  void initState() {
    super.initState();
    lireParametres();
  }

  Future<void> lireParametres() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? tempsTravail = prefs.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
    int? tempsPauseCourte = prefs.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
    int? tempsPauseLongue = prefs.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;

    setState(() {
      txtTempsTravail.text = tempsTravail.toString();
      txtTempsPauseCourte.text = tempsPauseCourte.toString();
      txtTempsPauseLongue.text = tempsPauseLongue.toString();
    });
  }

  void majParametres(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? current = prefs.getInt(key);
    int def = key == CLE_TEMPS_TRAVAIL
        ? TEMPS_TRAVAIL_DEFAUT
        : key == CLE_PAUSE_COURTE
        ? TEMPS_PAUSE_COURTE_DEFAUT
        : TEMPS_PAUSE_LONGUE_DEFAUT;

    int newVal = (current ?? def) + value;

    if (newVal >= 1 && newVal <= 180) {
      await prefs.setInt(key, newVal);
      setState(() {
        if (key == CLE_TEMPS_TRAVAIL) txtTempsTravail.text = newVal.toString();
        if (key == CLE_PAUSE_COURTE) txtTempsPauseCourte.text = newVal.toString();
        if (key == CLE_PAUSE_LONGUE) txtTempsPauseLongue.text = newVal.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleTexte = TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(title: Text('Paramètres')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3,
          children: <Widget>[
            Text('Temps de travail',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                )),
            SizedBox(),
            SizedBox(),
            BoutonParametre(
                couleur: Color(0xff455A64),
                texte: '-',
                valeur: -1,
                parametre: CLE_TEMPS_TRAVAIL,
                action: majParametres
            ),
            TextField(
              controller: txtTempsTravail,
              style: styleTexte,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            BoutonParametre(
                couleur: Color(0xff009688),
                texte: '+',
                valeur: 1,
                parametre: CLE_TEMPS_TRAVAIL,
                action: majParametres
            ),
            Text(
              'Temps pour une pause courte',
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
              )
            ),
            SizedBox(),
            SizedBox(),
            BoutonParametre(
                couleur: Color(0xff455A64),
                texte: '-',
                valeur: -1,
                parametre: CLE_PAUSE_COURTE,
                action: majParametres),
            TextField(
              controller: txtTempsPauseCourte,
              style: styleTexte,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            BoutonParametre(
                couleur: Color(0xff009688),
                texte: '+',
                valeur: 1,
                parametre: CLE_PAUSE_COURTE,
                action: majParametres
            ),
            Text('Temps pour une pause longue',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                )
            ),
            Text(''),
            Text(''),
            BoutonParametre(
                couleur: Color(0xff455A64),
                texte: '-',
                valeur: -1,
                parametre: CLE_PAUSE_LONGUE,
                action: majParametres
            ),
            TextField(
              controller: txtTempsPauseLongue,
              style: styleTexte,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            BoutonParametre(
                couleur: Color(0xff009688),
                texte: '+',
                valeur: 1,
                parametre: CLE_PAUSE_LONGUE,
                action: majParametres
            ),
          ],
        ),
      ),
    );
  }
}