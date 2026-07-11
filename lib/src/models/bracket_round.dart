import 'bracket_match.dart';

/// A single round (column) in a tournament bracket, e.g. "Quarter Finals".
class BracketRound {
  /// Creates a [BracketRound].
  const BracketRound({
    required this.title,
    required this.matches,
  });

  /// Display title shown in round tabs / headers.
  final String title;

  /// Matches in this round, top-to-bottom.
  final List<BracketMatch> matches;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BracketRound &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          _listEquals(matches, other.matches);

  @override
  int get hashCode => Object.hash(title, Object.hashAll(matches));

  @override
  String toString() =>
      'BracketRound(title: $title, matches: ${matches.length})';
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
