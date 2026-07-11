import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_bracket_kit/tournament_bracket_kit.dart';

void main() {
  group('bracket_layout', () {
    test('separator height grows with round index', () {
      final r0 = calculateSeparatorHeight(
        roundIndex: 0,
        itemsMarginVertical: 20,
        cardHeight: 100,
      );
      final r1 = calculateSeparatorHeight(
        roundIndex: 1,
        itemsMarginVertical: 20,
        cardHeight: 100,
      );
      expect(r1, greaterThan(r0));
    });

    test('bracket height matches first round geometry', () {
      expect(
        calculateBracketHeight(
          firstRoundMatchCount: 4,
          cardHeight: 100,
          itemsMarginVertical: 20,
        ),
        460,
      );
    });
  });

  group('dummy data', () {
    test('8-team bracket has 3 rounds', () {
      final rounds = dummyBracketRounds();
      expect(rounds.length, 3);
      expect(rounds.first.matches.length, 4);
      expect(rounds.last.matches.length, 1);
    });

    test('16-team bracket has 4 rounds', () {
      final rounds = dummySixteenTeamBracketRounds();
      expect(rounds.length, 4);
      expect(rounds.first.matches.length, 8);
    });
  });

  group('TournamentBracket', () {
    testWidgets('renders round tabs and match names', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TournamentBracket(
              rounds: dummyBracketRounds(),
              cardHeight: 100,
              cardWidth: 200,
            ),
          ),
        ),
      );

      expect(find.text('Quarter Finals'), findsOneWidget);
      expect(find.text('Kathmandu FC'), findsWidgets);
      expect(find.text('Final'), findsOneWidget);
    });

    testWidgets('empty rounds render nothing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TournamentBracket(rounds: []),
          ),
        ),
      );
      expect(find.byType(InteractiveViewer), findsNothing);
    });
  });
}
