import 'dart:math' as math;

/// Vertical gap between match cards for a given round index.
///
/// Spacing grows as `2^roundIndex` so later rounds stay centered between
/// their parent matches — the same layout math used by classic bracket UIs.
double calculateSeparatorHeight({
  required int roundIndex,
  required double itemsMarginVertical,
  required double cardHeight,
}) {
  var separatorHeight = 0.0;
  for (var i = 0; i <= roundIndex; i++) {
    final factor = math.pow(2, i).toDouble();
    separatorHeight =
        (cardHeight * (factor - 1)) + (itemsMarginVertical * ((factor - 1) + 1));
  }
  return separatorHeight;
}

/// Total height of a bracket given the first round's match count.
double calculateBracketHeight({
  required int firstRoundMatchCount,
  required double cardHeight,
  required double itemsMarginVertical,
}) {
  final count = firstRoundMatchCount < 1 ? 1 : firstRoundMatchCount;
  return (count * cardHeight) + ((count - 1) * itemsMarginVertical);
}
