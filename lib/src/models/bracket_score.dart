/// Score and winner info for a completed (or in-progress) bracket match.
class BracketScore {
  /// Creates a [BracketScore].
  const BracketScore({
    this.homeScore,
    this.awayScore,
    this.winnerId,
  });

  /// Score for the home / team A side.
  final int? homeScore;

  /// Score for the away / team B side.
  final int? awayScore;

  /// Id of the winning [BracketTeam], if decided.
  final String? winnerId;

  /// Whether a winner has been decided.
  bool get hasWinner => winnerId != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BracketScore &&
          runtimeType == other.runtimeType &&
          homeScore == other.homeScore &&
          awayScore == other.awayScore &&
          winnerId == other.winnerId;

  @override
  int get hashCode => Object.hash(homeScore, awayScore, winnerId);

  @override
  String toString() =>
      'BracketScore(home: $homeScore, away: $awayScore, winner: $winnerId)';
}
