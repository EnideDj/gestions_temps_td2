import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'minuteur.dart';
import 'button.dart';
import 'page_parametres.dart';

class PageAccueilMinuterie extends StatelessWidget {
  final Minuteur minuteur = Minuteur();
  static const double REMPLISSAGE_DEFAUT = 5.0;

  void allerParametres(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageParametres()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> elementsMenu = [
      PopupMenuItem(
          value: 'Param',
          child: Text('Paramètres'
          )
      ),
    ];
    minuteur.demarrerTravail();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade500,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'La gestion du temps',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return elementsMenu.toList();
            },
            onSelected: (s) {
              if (s == 'Param') {
                allerParametres(context);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final largeurDisponible = constraints.maxWidth;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          REMPLISSAGE_DEFAUT
                      ),
                      child: BoutonGenerique(
                        couleur: Colors.teal.shade700,
                        texte: 'Travail',
                        taille: 100,
                        action: () => minuteur.demarrerTravail(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          REMPLISSAGE_DEFAUT
                      ),
                      child: BoutonGenerique(
                        couleur: Colors.blueGrey.shade500,
                        texte: 'Mini Pause',
                        taille: 100,
                        action: () => minuteur.demarrerPause(true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          REMPLISSAGE_DEFAUT
                      ),
                      child: BoutonGenerique(
                        couleur: Colors.blueGrey.shade800,
                        texte: 'Maxi Pause',
                        taille: 100,
                        action: () => minuteur.demarrerPause(false),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  initialData: ModeleMinuteur(
                      '30:00',
                      1
                  ),
                  stream: minuteur.stream(),
                  builder: (context, snapshot) {
                    ModeleMinuteur chrono = snapshot.data!;
                    return CircularPercentIndicator(
                      radius: (largeurDisponible - 60.0) / 2.0,
                      lineWidth: 10,
                      percent: chrono.pourcentage ?? 1.0,
                      center: Text(
                        chrono.temps ?? '00:00',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      progressColor: Color(
                          0xff009688
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          REMPLISSAGE_DEFAUT
                      ),
                      child: BoutonGenerique(
                        couleur: Colors.black,
                        texte: 'Arrêter',
                        taille: 100,
                        action: () => minuteur.arreterMinuteur(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          REMPLISSAGE_DEFAUT
                      ),
                      child: BoutonGenerique(
                        couleur: Colors.teal.shade700,
                        texte: 'Relancer',
                        taille: 100,
                        action: () => minuteur.relancerMinuteur(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}