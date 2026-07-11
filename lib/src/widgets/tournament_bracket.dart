import 'package:flutter/material.dart';

import '../models/bracket_match.dart';
import '../models/bracket_round.dart';
import '../utils/bracket_layout.dart';
import 'bracket_connector.dart';
import 'bracket_round_column.dart';
import 'bracket_round_tabs.dart';
import 'default_bracket_match_card.dart';

/// Builder for a single match card inside [TournamentBracket].
typedef BracketMatchBuilder = Widget Function(
  BuildContext context,
  BracketMatch match,
);

/// Callback when a match card is tapped (used by the default card).
typedef BracketMatchTapCallback = void Function(BracketMatch match);

/// A pannable single-elimination tournament bracket.
///
/// Pass ordered [rounds] (first round → final). Customize look via
/// [matchBuilder], sizing, and line colors. Round tabs pan the viewport
/// when [showRoundTabs] is true.
///
/// ```dart
/// TournamentBracket(
///   rounds: dummyBracketRounds(),
///   onMatchTap: (match) => debugPrint(match.id),
/// )
/// ```
class TournamentBracket extends StatefulWidget {
  /// Creates a [TournamentBracket].
  const TournamentBracket({
    super.key,
    required this.rounds,
    this.matchBuilder,
    this.onMatchTap,
    this.cardHeight = 100,
    this.cardWidth = 220,
    this.itemsMarginVertical = 24,
    this.connectorWidth = 80,
    this.lineColor,
    this.lineWidth = 2,
    this.showRoundTabs = true,
    this.enablePan = true,
    this.enableScale = false,
    this.minScale = 0.4,
    this.maxScale = 2.5,
    this.transformationController,
  });

  /// Bracket rounds from earliest round to final.
  final List<BracketRound> rounds;

  /// Custom match card. Defaults to [DefaultBracketMatchCard].
  final BracketMatchBuilder? matchBuilder;

  /// Fired when the default card is tapped. Ignored if [matchBuilder] is set
  /// (handle taps inside your builder instead).
  final BracketMatchTapCallback? onMatchTap;

  /// Height of each match card slot.
  final double cardHeight;

  /// Width of each match card / round column.
  final double cardWidth;

  /// Base vertical margin between first-round cards.
  final double itemsMarginVertical;

  /// Width of the elbow connector between rounds.
  final double connectorWidth;

  /// Bracket line color. Defaults to [ThemeData.dividerColor].
  final Color? lineColor;

  /// Bracket line stroke width.
  final double lineWidth;

  /// Whether to show the round tab bar above the bracket.
  final bool showRoundTabs;

  /// Whether the bracket can be panned via [InteractiveViewer].
  final bool enablePan;

  /// Whether pinch-to-zoom is enabled.
  final bool enableScale;

  /// Minimum zoom when [enableScale] is true.
  final double minScale;

  /// Maximum zoom when [enableScale] is true.
  final double maxScale;

  /// Optional external transformation controller.
  final TransformationController? transformationController;

  @override
  State<TournamentBracket> createState() => _TournamentBracketState();
}

class _TournamentBracketState extends State<TournamentBracket>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  TabController? _tabController;
  var _ownsTransformationController = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant TournamentBracket oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rounds.length != widget.rounds.length ||
        oldWidget.transformationController != widget.transformationController) {
      _disposeControllers();
      _initControllers();
    }
  }

  void _initControllers() {
    if (widget.transformationController != null) {
      _transformationController = widget.transformationController!;
      _ownsTransformationController = false;
    } else {
      _transformationController = TransformationController();
      _ownsTransformationController = true;
    }

    if (widget.showRoundTabs && widget.rounds.isNotEmpty) {
      _tabController = TabController(length: widget.rounds.length, vsync: this)
        ..addListener(_onTabChanged);
    } else {
      _tabController = null;
    }
  }

  void _disposeControllers() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _tabController = null;
    if (_ownsTransformationController) {
      _transformationController.dispose();
    }
  }

  void _onTabChanged() {
    final controller = _tabController;
    if (controller == null || !controller.indexIsChanging) return;
    _panToRound(controller.index);
  }

  void _panToRound(int index) {
    final dx = -index * (widget.cardWidth + widget.connectorWidth) * 0.85;
    _transformationController.value = Matrix4.translationValues(dx, 0, 0);
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  BracketMatchBuilder get _resolvedMatchBuilder {
    return widget.matchBuilder ??
        (context, match) => DefaultBracketMatchCard(
              match: match,
              onTap: widget.onMatchTap == null
                  ? null
                  : () => widget.onMatchTap!(match),
            );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rounds.isEmpty) {
      return const SizedBox.shrink();
    }

    final lineColor = widget.lineColor ?? Theme.of(context).dividerColor;
    final firstRoundCount = widget.rounds.first.matches.length;
    final bracketHeight = calculateBracketHeight(
      firstRoundMatchCount: firstRoundCount,
      cardHeight: widget.cardHeight,
      itemsMarginVertical: widget.itemsMarginVertical,
    );

    final bracketBody = SizedBox(
      height: bracketHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.rounds.length,
        itemBuilder: (context, index) {
          final round = widget.rounds[index];
          final separatorHeight = calculateSeparatorHeight(
            roundIndex: index,
            itemsMarginVertical: widget.itemsMarginVertical,
            cardHeight: widget.cardHeight,
          );
          return BracketRoundColumn(
            matches: round.matches,
            separatorHeight: separatorHeight,
            cardHeight: widget.cardHeight,
            cardWidth: widget.cardWidth,
            matchBuilder: _resolvedMatchBuilder,
          );
        },
        separatorBuilder: (context, index) {
          final source = widget.rounds[index];
          final separatorHeight = calculateSeparatorHeight(
            roundIndex: index,
            itemsMarginVertical: widget.itemsMarginVertical,
            cardHeight: widget.cardHeight,
          );
          return BracketConnector(
            sourceMatchCount: source.matches.length,
            separatorHeight: separatorHeight,
            cardHeight: widget.cardHeight,
            lineColor: lineColor,
            connectorWidth: widget.connectorWidth,
            lineWidth: widget.lineWidth,
          );
        },
      ),
    );

    final viewer = InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      scaleEnabled: widget.enableScale,
      panEnabled: widget.enablePan,
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      child: bracketBody,
    );

    if (!widget.showRoundTabs || _tabController == null) {
      return viewer;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BracketRoundTabs(
          titles: [for (final r in widget.rounds) r.title],
          controller: _tabController!,
        ),
        Expanded(child: viewer),
      ],
    );
  }
}
