# tournament_bracket_kit

A customizable Flutter widget for **single-elimination tournament brackets**.

Pan across rounds, jump via round tabs, and fully customize match cards — or use the built-in default card.

## Features

- Single-elimination layout (round columns + elbow connectors)
- Pan (and optional pinch-zoom) via `InteractiveViewer`
- Round tabs that pan to the selected round
- Custom match card builder
- Default Material match card out of the box
- Dummy data helpers for demos / tests
- Zero third-party dependencies

## Install

```yaml
dependencies:
  tournament_bracket_kit: ^0.1.0
```

## Quick start

```dart
import 'package:tournament_bracket_kit/tournament_bracket_kit.dart';

TournamentBracket(
  rounds: dummyBracketRounds(),
  onMatchTap: (match) => debugPrint(match.id),
)
```

## Custom match card

```dart
TournamentBracket(
  rounds: myRounds,
  matchBuilder: (context, match) {
    return MyFancyCard(match: match);
  },
)
```

## Data model

```dart
final rounds = [
  BracketRound(
    title: 'Semi Finals',
    matches: [
      BracketMatch(
        id: 'sf1',
        home: BracketTeam(id: '1', name: 'Team A'),
        away: BracketTeam(id: '2', name: 'Team B'),
        isCompleted: true,
        score: BracketScore(homeScore: 2, awayScore: 1, winnerId: '1'),
      ),
      // ...
    ],
  ),
  BracketRound(title: 'Final', matches: [/* ... */]),
];
```

Map your API models into these types — the package stays UI-only.

## Example

```bash
cd example
flutter run
```

## License

MIT
