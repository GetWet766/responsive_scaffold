# Responsive Scaffold

A Flutter package that implements Material 3 adaptive layout specifications.

## Features

- **Breakpoints**: Automatic detection of Window Size Classes (Compact, Medium, Expanded, Large, Extra-large).
- **Navigation**: Automatically switches between Navigation Bar, Navigation Rail, and Navigation Drawer based on screen width.
- **Adaptive Panes**: Automatically displays 1, 2, or 3 panes based on available width and Material 3 recommendations.
- **Material 3 Support**: Built strictly on Material 3 components and design principles.

## Breakpoints

| Window Size Class | Range | Navigation | Recommendation |
| --- | --- | --- | --- |
| Compact | < 600dp | Navigation Bar | 1 Pane |
| Medium | 600–839dp | Navigation Rail | 1-2 Panes |
| Expanded | 840–1199dp | Navigation Rail | 1-2 Panes |
| Large | 1200–1599dp | Navigation Rail (Collapsed Drawer) | 1-2 Panes |
| Extra-large | 1600+dp | Navigation Drawer (Expanded) | 1-3 Panes |

## Usage

```dart
ResponsiveScaffold(
  title: const Text('My App'),
  selectedIndex: _index,
  onDestinationSelected: (int index) => setState(() => _index = index),
  destinations: const [
    ResponsiveScaffoldDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    // ...
  ],
  bodyPanes: [
    Container(child: const Text('Pane 1')),
    Container(child: const Text('Pane 2')),
    Container(child: const Text('Pane 3')),
  ],
)
```
