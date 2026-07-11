import 'package:flutter/material.dart';

/// Horizontal tab bar for jumping between bracket rounds.
class BracketRoundTabs extends StatelessWidget {
  /// Creates [BracketRoundTabs].
  const BracketRoundTabs({
    super.key,
    required this.titles,
    required this.controller,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
  });

  /// Round titles, left-to-right.
  final List<String> titles;

  /// Shared [TabController].
  final TabController controller;

  /// Selected tab label color.
  final Color? labelColor;

  /// Unselected tab label color.
  final Color? unselectedLabelColor;

  /// Underline / indicator color.
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor:
            unselectedLabelColor ?? theme.colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [for (final title in titles) Tab(text: title)],
      ),
    );
  }
}
