import 'package:flutter/material.dart';

import '../models/bracket_match.dart';
import '../models/bracket_team.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    // Card surface — prefer a slightly elevated neutral tone.
    final bg = backgroundColor ??
        (isDark
            ? Color.lerp(theme.colorScheme.surface, Colors.white, 0.04)!
            : theme.colorScheme.surface);

    // Border: subtle but actually visible — 1.5px with a mid-tone.
    final border = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.10));

    final accent = accentColor ?? theme.colorScheme.primary;

    final homeWinner = match.home != null && match.isWinner(match.home!.id);
    final awayWinner = match.away != null && match.isWinner(match.away!.id);
    final hasResult = match.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1.5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: accent.withValues(alpha: 0.08),
            highlightColor: accent.withValues(alpha: 0.04),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Team names ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TeamRow(
                            team: match.home,
                            isWinner: homeWinner,
                            isLoser:
                                hasResult && !homeWinner && match.away != null,
                            accent: accent,
                            isDark: isDark,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: border,
                            ),
                          ),
                          _TeamRow(
                            team: match.away,
                            isWinner: awayWinner,
                            isLoser:
                                hasResult && !awayWinner && match.home != null,
                            accent: accent,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Score column ───────────────────────────────────────
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.03)
                          : Colors.black.withValues(alpha: 0.025),
                      border: Border(
                        left: BorderSide(color: border, width: 1.5),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ScoreBox(
                          value: match.score?.homeScore,
                          isWinner: homeWinner,
                          isLoser:
                              hasResult && !homeWinner && match.away != null,
                          accent: accent,
                          isDark: isDark,
                        ),
                        SizedBox(
                          height: 1,
                          child: ColoredBox(color: border),
                        ),
                        _ScoreBox(
                          value: match.score?.awayScore,
                          isWinner: awayWinner,
                          isLoser:
                              hasResult && !awayWinner && match.home != null,
                          accent: accent,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Team row
// ─────────────────────────────────────────────────────────────────────────────

class _TeamRow extends StatelessWidget {
  const _TeamRow({
    required this.team,
    required this.isWinner,
    required this.isLoser,
    required this.accent,
    required this.isDark,
  });

  final BracketTeam? team;
  final bool isWinner;
  final bool isLoser;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final String name = team?.name ?? 'TBD';
    final isTBD = team == null;

    // High-contrast colour decisions — avoids opacity chains.
    final Color nameColor;
    if (isTBD) {
      nameColor =
          (isDark ? Colors.white : Colors.black).withValues(alpha: 0.28);
    } else if (isWinner) {
      nameColor = isDark ? Colors.white : Colors.black;
    } else if (isLoser) {
      nameColor =
          (isDark ? Colors.white : Colors.black).withValues(alpha: 0.38);
    } else {
      nameColor = isDark
          ? Colors.white.withValues(alpha: 0.80)
          : Colors.black.withValues(alpha: 0.75);
    }

    return Row(
      children: [
        _CircleAvatar(
          team: team,
          accent: accent,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isWinner ? FontWeight.w600 : FontWeight.w400,
              fontSize: 12.5,
              letterSpacing: isWinner ? 0.1 : 0,
              color: nameColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circular avatar
// ─────────────────────────────────────────────────────────────────────────────

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({
    required this.team,
    required this.accent,
    required this.isDark,
  });

  final BracketTeam? team;
  final Color accent;
  final bool isDark;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    final isTBD = team == null;
    final logoUrl = team?.logoUrl;
    final name = team?.name ?? '';
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    if (!isTBD && logoUrl != null && logoUrl.isNotEmpty) {
      final isNetwork =
          logoUrl.startsWith('http') || logoUrl.startsWith('https');
      return _ringWrap(
        child: ClipOval(
          child: SizedBox.square(
            dimension: _size,
            child: isNetwork
                ? Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _letterFill(letter, isTBD: false),
                  )
                : Image.asset(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _letterFill(letter, isTBD: false),
                  ),
          ),
        ),
        isTBD: false,
      );
    }

    return _ringWrap(
      child: _letterFill(letter, isTBD: isTBD),
      isTBD: isTBD,
    );
  }

  Widget _ringWrap({required Widget child, required bool isTBD}) {
    final ringColor = isTBD
        ? (isDark ? Colors.white12 : Colors.black12)
        : accent.withValues(alpha: 0.25);
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 1.5),
      ),
      child: ClipOval(child: child),
    );
  }

  Widget _letterFill(String letter, {required bool isTBD}) {
    final bg = isTBD
        ? (isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06))
        : accent.withValues(alpha: 0.12);

    final fg = isTBD
        ? (isDark
            ? Colors.white.withValues(alpha: 0.30)
            : Colors.black.withValues(alpha: 0.28))
        : accent;

    return Container(
      color: bg,
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          height: 1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Score box
// ─────────────────────────────────────────────────────────────────────────────

class _ScoreBox extends StatelessWidget {
  const _ScoreBox({
    required this.value,
    required this.isWinner,
    required this.isLoser,
    required this.accent,
    required this.isDark,
  });

  final int? value;
  final bool isWinner;
  final bool isLoser;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = value?.toString() ?? '–';

    final Color color;
    if (isWinner) {
      color = accent;
    } else if (isLoser) {
      color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.28);
    } else {
      color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.55);
    }

    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
            fontSize: 13,
            color: color,
          ),
        ),
      ),
    );
  }
}
