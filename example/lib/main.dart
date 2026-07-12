import 'package:flutter/material.dart';
import 'package:tournament_bracket_kit/tournament_bracket_kit.dart';

void main() => runApp(const BracketExampleApp());

class BracketExampleApp extends StatelessWidget {
  const BracketExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tournament Bracket Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D7A5A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BracketDemoPage(),
    );
  }
}

class BracketDemoPage extends StatefulWidget {
  const BracketDemoPage({super.key});

  @override
  State<BracketDemoPage> createState() => _BracketDemoPageState();
}

class _BracketDemoPageState extends State<BracketDemoPage> {
  @override
  Widget build(BuildContext context) {
    final rounds = dummyBracketRounds();

    return Scaffold(
      appBar: AppBar(
        title: const Text('tournament_bracket_kit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TournamentBracket(
            rounds: rounds,
            cardHeight: 110,
            cardWidth: 240,
            itemsMarginVertical: 28,
            enableScale: true,
            onMatchTap: (match) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${match.home?.name ?? 'TBD'} vs ${match.away?.name ?? 'TBD'}',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
