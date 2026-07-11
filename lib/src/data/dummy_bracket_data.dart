import '../models/bracket_match.dart';
import '../models/bracket_round.dart';
import '../models/bracket_score.dart';
import '../models/bracket_team.dart';

/// Sample 8-team single-elimination bracket for demos and tests.
///
/// Rounds: Quarter Finals → Semi Finals → Final.
List<BracketRound> dummyBracketRounds() {
  const t1 = BracketTeam(id: '1', name: 'Kathmandu FC');
  const t2 = BracketTeam(id: '2', name: 'Lalitpur United');
  const t3 = BracketTeam(id: '3', name: 'Pokhara City');
  const t4 = BracketTeam(id: '4', name: 'Biratnagar Boys');
  const t5 = BracketTeam(id: '5', name: 'Chitwan Warriors');
  const t6 = BracketTeam(id: '6', name: 'Butwal Strikers');
  const t7 = BracketTeam(id: '7', name: 'Dharan FC');
  const t8 = BracketTeam(id: '8', name: 'Nepalgunj Stars');

  return const [
    BracketRound(
      title: 'Quarter Finals',
      matches: [
        BracketMatch(
          id: 'qf1',
          home: t1,
          away: t2,
          isCompleted: true,
          score: BracketScore(homeScore: 3, awayScore: 1, winnerId: '1'),
        ),
        BracketMatch(
          id: 'qf2',
          home: t3,
          away: t4,
          isCompleted: true,
          score: BracketScore(homeScore: 2, awayScore: 2, winnerId: '4'),
        ),
        BracketMatch(
          id: 'qf3',
          home: t5,
          away: t6,
          isCompleted: true,
          score: BracketScore(homeScore: 0, awayScore: 1, winnerId: '6'),
        ),
        BracketMatch(
          id: 'qf4',
          home: t7,
          away: t8,
          isCompleted: true,
          score: BracketScore(homeScore: 4, awayScore: 0, winnerId: '7'),
        ),
      ],
    ),
    BracketRound(
      title: 'Semi Finals',
      matches: [
        BracketMatch(
          id: 'sf1',
          home: t1,
          away: t4,
          isCompleted: true,
          score: BracketScore(homeScore: 2, awayScore: 0, winnerId: '1'),
        ),
        BracketMatch(
          id: 'sf2',
          home: t6,
          away: t7,
          isCompleted: false,
          score: BracketScore(homeScore: 1, awayScore: 1),
        ),
      ],
    ),
    BracketRound(
      title: 'Final',
      matches: [
        BracketMatch(
          id: 'f1',
          home: t1,
          away: null,
        ),
      ],
    ),
  ];
}

/// Larger 16-team bracket (round of 16 → final) with mostly TBD slots.
List<BracketRound> dummySixteenTeamBracketRounds() {
  BracketTeam team(int i) => BracketTeam(id: '$i', name: 'Team $i');

  final r16 = List<BracketMatch>.generate(8, (i) {
    final a = i * 2 + 1;
    final b = i * 2 + 2;
    return BracketMatch(
      id: 'r16_$i',
      home: team(a),
      away: team(b),
      isCompleted: i < 4,
      score: i < 4
          ? BracketScore(
              homeScore: 2,
              awayScore: 1,
              winnerId: '$a',
            )
          : null,
    );
  });

  final qf = List<BracketMatch>.generate(4, (i) {
    if (i < 2) {
      final winnerId = '${i * 2 + 1}';
      return BracketMatch(
        id: 'qf_$i',
        home: team(i * 2 + 1),
        away: team(i * 2 + 3),
        isCompleted: true,
        score: BracketScore(homeScore: 3, awayScore: 0, winnerId: winnerId),
      );
    }
    return BracketMatch(id: 'qf_$i');
  });

  return [
    BracketRound(title: 'Round of 16', matches: r16),
    BracketRound(title: 'Quarter Finals', matches: qf),
    const BracketRound(
      title: 'Semi Finals',
      matches: [
        BracketMatch(id: 'sf_0'),
        BracketMatch(id: 'sf_1'),
      ],
    ),
    const BracketRound(
      title: 'Final',
      matches: [BracketMatch(id: 'final')],
    ),
  ];
}
