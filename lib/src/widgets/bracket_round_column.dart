import 'package:flutter/material.dart';

import '../models/bracket_match.dart';

/// Vertical column of match cards for a single bracket round.
class BracketRoundColumn extends StatelessWidget {
  /// Creates a [BracketRoundColumn].
  const BracketRoundColumn({
    super.key,
    required this.matches,
    required this.separatorHeight,
    required this.cardHeight,
    required this.cardWidth,
    required this.matchBuilder,
  });

  /// Matches rendered top-to-bottom.
  final List<BracketMatch> matches;

  /// Vertical gap between cards.
  final double separatorHeight;

  /// Fixed height of each match card slot.
  final double cardHeight;

  /// Fixed width of the column / cards.
  final double cardWidth;

  /// Builds the match card widget.
  final Widget Function(BuildContext context, BracketMatch match) matchBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ListView.separated(
              itemCount: matches.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final match = matches[index];
                return SizedBox(
                  height: cardHeight,
                  child: matchBuilder(context, match),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
            ),
          ),
        ],
      ),
    );
  }
}
