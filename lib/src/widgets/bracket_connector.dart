import 'package:flutter/material.dart';

/// Elbow connectors drawn between two adjacent bracket rounds.
class BracketConnector extends StatelessWidget {
  /// Creates a [BracketConnector].
  const BracketConnector({
    super.key,
    required this.sourceMatchCount,
    required this.separatorHeight,
    required this.cardHeight,
    required this.lineColor,
    this.connectorWidth = 80,
    this.lineWidth = 2,
    this.cornerRadius = 7,
  });

  /// Number of matches in the *source* (left) round.
  final int sourceMatchCount;

  /// Vertical gap used by the source round (drives elbow height).
  final double separatorHeight;

  /// Match card height.
  final double cardHeight;

  /// Color of the bracket lines.
  final Color lineColor;

  /// Total width of the connector column.
  final double connectorWidth;

  /// Stroke width of the lines.
  final double lineWidth;

  /// Corner radius on the elbow joints.
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    final pairCount = sourceMatchCount ~/ 2;
    if (pairCount <= 0) return SizedBox(width: connectorWidth);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: SizedBox(
            width: connectorWidth,
            child: ListView.separated(
              itemCount: pairCount,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, __) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: separatorHeight + cardHeight,
                      width: connectorWidth / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(cornerRadius),
                          bottomRight: Radius.circular(cornerRadius),
                        ),
                        border: Border(
                          top: BorderSide(color: lineColor, width: lineWidth),
                          right: BorderSide(color: lineColor, width: lineWidth),
                          bottom: BorderSide(color: lineColor, width: lineWidth),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: lineWidth,
                        color: lineColor,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) =>
                  SizedBox(height: cardHeight + separatorHeight),
            ),
          ),
        ),
      ],
    );
  }
}
