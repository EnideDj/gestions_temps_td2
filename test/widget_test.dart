import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_temps/page_parametres.dart';

void main() {
  testWidgets('Affichage des champs de paramètre et test des boutons',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: PageParametres(),
          ),
        );

        expect(find.text('Temps de travail'), findsOneWidget);
        expect(find.text('Temps pour une pause courte'), findsOneWidget);
        expect(find.text('Temps pour une pause longue'), findsOneWidget);

        expect(find.text('+'), findsWidgets);
        expect(find.text('-'), findsWidgets);

        expect(find.byType(TextField), findsNWidgets(3));

        await tester.tap(find.text('+').first);
        await tester.pump();

        await tester.tap(find.text('-').first);
        await tester.pump();
      });
}