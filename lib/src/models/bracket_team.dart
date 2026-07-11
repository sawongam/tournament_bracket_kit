/// A participant in a tournament bracket match.
class BracketTeam {
  /// Creates a [BracketTeam].
  const BracketTeam({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  /// Unique identifier for the team.
  final String id;

  /// Display name of the team.
  final String name;

  /// Optional logo URL (network or asset path resolved by the host app).
  final String? logoUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BracketTeam &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          logoUrl == other.logoUrl;

  @override
  int get hashCode => Object.hash(id, name, logoUrl);

  @override
  String toString() => 'BracketTeam(id: $id, name: $name)';
}
