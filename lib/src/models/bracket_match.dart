import 'bracket_score.dart';
import 'bracket_team.dart';

/// A single matchup in a tournament bracket round.
class BracketMatch {
  /// Creates a [BracketMatch].
  const BracketMatch({
    required this.id,
    this.home,
    this.away,
    this.score,
    this.isCompleted = false,
    this.metadata,
  });

  /// Unique identifier for the match.
  final String id;

  /// Home / team A. Null when the slot is TBD / bye.
  final BracketTeam? home;

  /// Away / team B. Null when the slot is TBD / bye.
  final BracketTeam? away;

  /// Optional score / winner info.
  final BracketScore? score;

  /// Whether the match has finished.
  final bool isCompleted;

  /// Free-form bag for host-app data (e.g. match date, venue).
  final Map<String, Object?>? metadata;

  /// Both teams have been assigned.
  bool get isAssigned => home != null && away != null;

  /// Whether [teamId] won this match.
  bool isWinner(String teamId) =>
      isCompleted && score?.winnerId != null && score!.winnerId == teamId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BracketMatch &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          home == other.home &&
          away == other.away &&
          score == other.score &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => Object.hash(id, home, away, score, isCompleted);

  @override
  String toString() =>
      'BracketMatch(id: $id, home: ${home?.name}, away: ${away?.name})';
}
