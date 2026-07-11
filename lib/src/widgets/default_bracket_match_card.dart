import 'package:flutter/material.dart';

import '../models/bracket_match.dart';

/// Default match card used when no custom [TournamentBracket.matchBuilder]
/// is provided.
class DefaultBracketMatchCard extends StatelessWidget {
  /// Creates a [DefaultBracketMatchCard].
  const DefaultBracketMatchCard({
    super.key,
    required this.match,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.accentColor,
    this.borderRadius = 10,
  });

  /// Match to render.
  final BracketMatch match;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Card background. Defaults to theme surface.
  final Color? backgroundColor;

  /// Card border color. Defaults to theme divider.
  final Color? borderColor;

  /// Accent used for scores / winner highlights.
  final Color? accentColor;

  /// Corner radius of the card.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final border = borderColor ?? theme.dividerColor;
    final accent = accentColor ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TeamRow(
                      name: match.home?.name ?? 'TBD',
                      isWinner: match.home != null &&
                          match.isWinner(match.home!.id),
                      accent: accent,
                    ),
                    const SizedBox(height: 8),
                    _TeamRow(
                      name: match.away?.name ?? 'TBD',
                      isWinner: match.away != null &&
                          match.isWinner(match.away!.id),
                      accent: accent,
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: border, width: 16),
              SizedBox(
                width: 36,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ScoreText(
                      value: match.score?.homeScore,
                      accent: accent,
                      emphasize: match.home != null &&
                          match.isWinner(match.home!.id),
                    ),
                    _ScoreText(
                      value: match.score?.awayScore,
                      accent: accent,
                      emphasize: match.away != null &&
                          match.isWinner(match.away!.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  const _TeamRow({
    required this.name,
    required this.isWinner,
    required this.accent,
  });

  final String name;
  final bool isWinner;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: accent.withValues(alpha: 0.15),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        if (isWinner)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(Icons.check_circle, size: 14, color: accent),
          ),
      ],
    );
  }
}

class _ScoreText extends StatelessWidget {
  const _ScoreText({
    required this.value,
    required this.accent,
    required this.emphasize,
  });

  final int? value;
  final Color accent;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Text(
      value?.toString() ?? '–',
      style: TextStyle(
        fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
        fontSize: 14,
        color: emphasize ? accent : null,
      ),
    );
  }
}
