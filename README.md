# Sumi Forest 🌳

A minimal to-do list app with a beautiful watercolor forest visualization where completed tasks bloom into trees.

![Sumi Forest](https://img.shields.io/badge/iOS-17.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green)

## Overview

Sumi Forest combines task management with mindful visualization. Each completed task grows a watercolor tree in your personal forest, creating a living record of your accomplishments.

### Key Features

- ✅ **Simple Task Management**: Create, edit, and complete tasks with ease
- 🌲 **Living Forest**: Completed tasks transform into beautiful watercolor trees
- 🎨 **Japanese Aesthetic**: Sumi-e calligraphy and watercolor-inspired design
- 🌗 **Dark Mode**: Elegant dark theme for evening use
- ♿️ **Accessible**: Full VoiceOver support and Dynamic Type
- 📱 **iOS Native**: Built with SwiftUI and SwiftData for optimal performance

## Tree Species

Tasks grow into different tree species based on priority:

| Priority | Species | Color |
|----------|---------|-------|
| Low (0) | Bamboo 🎋 | Green |
| Medium (1) | Maple 🍁 | Red-Brown |
| High (2) | Pine 🌲 | Dark Green |
| Critical (3) | Sakura 🌸 | Pink |

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/sumi-forest.git
cd sumi-forest
```

2. Open the project in Xcode:
```bash
open SumiForest.xcodeproj
```

3. Select your target device or simulator

4. Build and run (⌘R)

## Architecture

Sumi Forest follows clean MVVM architecture:

```
SumiForest/
├── App/                    # App entry point
│   └── SumiForestApp.swift
├── Models/                 # Data models
│   ├── TodoItem.swift
│   └── AppError.swift
├── ViewModels/            # Business logic
│   ├── TodoListViewModel.swift
│   └── ForestViewModel.swift
├── Views/                 # Main views
│   ├── ContentView.swift
│   ├── TodoListView.swift
│   └── ForestView.swift
├── Components/            # Reusable components
│   ├── TodoRowView.swift
│   ├── TodoEditorView.swift
│   └── TreeView.swift
├── Services/              # Services
│   ├── Haptics.swift
│   └── Logger.swift
├── Resources/             # Resources
│   └── Theme.swift
└── Tests/                 # Unit & UI tests
    ├── TodoModelTests.swift
    ├── ForestLayoutTests.swift
    └── TreeGeneratorTests.swift
```

## Usage

### Managing Tasks

1. **Quick Add**: Tap the text field at the top to quickly add a task
2. **Detailed Add**: Tap the + button to add a task with notes, due date, and priority
3. **Complete**: Swipe right or tap the checkbox to complete a task
4. **Edit**: Swipe left and tap the edit button
5. **Delete**: Swipe left and tap the delete button

### Viewing Your Forest

1. Switch to the **Forest** tab
2. See your completed tasks as watercolor trees
3. Tap any tree to view its associated task details
4. Watch new trees animate in as you complete tasks

### Filters & Sorting

Use the filter chips to view:
- **All**: All tasks
- **Today**: Tasks due today
- **Upcoming**: Future tasks
- **Completed**: Finished tasks

Sort by:
- **Created**: When the task was created
- **Due Date**: When the task is due
- **Priority**: Task importance

## Development

### Running Tests

Run all tests:
```bash
xcodebuild -scheme SumiForest -destination 'platform=iOS Simulator,name=iPhone 15' test
```

Run specific test:
```bash
xcodebuild -scheme SumiForest -destination 'platform=iOS Simulator,name=iPhone 15' test -only-testing:SumiForestTests/TodoModelTests
```

### Code Style

- Swift code follows standard Swift conventions
- Use SwiftFormat and SwiftLint for consistency
- All public types have documentation comments
- Follow MVVM strictly - no business logic in views

### Logging

The app uses `os.Logger` with categorized loggers:

```swift
AppLogger.todo.info("Created new task")
AppLogger.forest.debug("Generated tree positions")
AppLogger.persistence.error("Failed to save: \(error)")
```

Categories:
- `todo`: Task operations
- `forest`: Forest view operations
- `persistence`: Data persistence
- `ui`: UI events

## Troubleshooting

### Common Issues

**Problem**: Forest appears empty after completing tasks
- **Solution**: Check that tasks are actually marked as completed. Pull down to refresh the forest view.

**Problem**: Trees overlapping too much
- **Solution**: The layout engine uses Poisson-disk sampling with a minimum distance. If you have many trees in a small space, some overlap is expected.

**Problem**: Slow scrolling in task list
- **Solution**: This shouldn't happen with < 1000 tasks. If it does, check for excessive view modifiers in TodoRowView.

**Problem**: Data not persisting
- **Solution**: Check SwiftData model container initialization. Look for errors in AppLogger.persistence logs.

**Problem**: Missing tree textures
- **Solution**: Trees are rendered using SwiftUI shapes, not image assets. Check TreeView and tree shape definitions.

### Performance

- Target: ≥55 FPS with 100+ trees
- Launch time: <300ms
- List scroll: <12ms per frame

Use Instruments Time Profiler to identify bottlenecks:
```bash
instruments -t "Time Profiler" -D trace.trace -l 10000 SumiForest.app
```

### Debug Menu

In development builds, a debug menu is available (if implemented) with:
- Reset all data
- Spawn sample trees
- Toggle dark mode
- View performance metrics

## Accessibility

### VoiceOver Support

All interactive elements have descriptive labels:
- Task rows: "Task name. Completed/Not completed."
- Completion buttons: "Mark as complete" / "Mark as incomplete"
- Trees: "Sakura tree from task: Task name"

### Dynamic Type

All text scales with user's preferred text size. Test with:
Settings → Accessibility → Display & Text Size → Larger Text

### Reduce Motion

Tree growth animations respect reduce motion settings:
Settings → Accessibility → Motion → Reduce Motion

## Roadmap

Future enhancements:

- [ ] iCloud sync across devices
- [ ] Home screen widget
- [ ] Gentle reminder notifications
- [ ] Forest themes (seasons)
- [ ] Export forest as image
- [ ] Task templates
- [ ] Statistics view
- [ ] Apple Watch companion

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - See LICENSE file for details

## Credits

Created with ❤️ using SwiftUI and SwiftData

Inspired by Japanese sumi-e calligraphy and watercolor art.

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact: support@sumiforest.app

---

*"Write one brushstroke at a time."* 🖌️
