import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tournament_bracket_kit/tournament_bracket_kit.dart';

void main() {
  testWidgets('example app loads bracket', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TournamentBracket(rounds: dummyBracketRounds()),
        ),
      ),
    );
    expect(find.text('Quarter Finals'), findsOneWidget);
  });
}
