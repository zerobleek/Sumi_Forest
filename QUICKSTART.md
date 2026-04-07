# Quick Start Guide

Get up and running with Sumi Forest development in minutes.

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- iOS 17.0+ device or simulator

## Installation

### 1. Get the Code

```bash
# Clone the repository
git clone https://github.com/yourusername/sumi-forest.git
cd sumi-forest

# Or download and extract the ZIP
```

### 2. Open in Xcode

```bash
open SumiForest.xcodeproj
```

### 3. Select Target

- Choose your target device or simulator from the dropdown
- Recommended: iPhone 15 simulator for development

### 4. Build and Run

- Press `⌘R` or click the Play button
- App should launch in simulator/device

## First Run

The app will:
1. Create a SwiftData model container
2. Initialize with empty state
3. Show the Todo List tab

## Adding Sample Data

For development, you can add sample data:

```swift
// In your preview or debug code
SampleDataGenerator.insertSampleData(
    into: modelContext,
    todoCount: 10,
    completedCount: 5
)
```

Or use the sample data in Previews:

```swift
#Preview {
    let container = try! ModelContainer(
        for: TodoItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    SampleDataGenerator.insertSampleData(into: container.mainContext)
    return TodoListView()
        .modelContainer(container)
}
```

## Project Structure

```
SumiForest/
├── App/
│   └── SumiForestApp.swift          # App entry point
├── Models/
│   ├── TodoItem.swift               # Core data model
│   └── AppError.swift               # Error handling
├── ViewModels/
│   ├── TodoListViewModel.swift      # Todo logic
│   └── ForestViewModel.swift        # Forest logic
├── Views/
│   ├── ContentView.swift            # Main tabbed view
│   ├── TodoListView.swift           # Todo list UI
│   └── ForestView.swift             # Forest visualization
├── Components/
│   ├── TodoRowView.swift            # Task row
│   ├── TodoEditorView.swift         # Task editor
│   └── TreeView.swift               # Tree rendering
├── Services/
│   ├── Haptics.swift                # Haptic feedback
│   ├── Logger.swift                 # Logging
│   └── SampleDataGenerator.swift    # Test data
├── Resources/
│   ├── Theme.swift                  # Design system
│   └── Info.plist                   # App config
└── Tests/
    ├── TodoModelTests.swift
    ├── ForestLayoutTests.swift
    └── TreeGeneratorTests.swift
```

## Running Tests

### All Tests
```bash
xcodebuild test -scheme SumiForest \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Specific Test Class
```bash
xcodebuild test -scheme SumiForest \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:SumiForestTests/TodoModelTests
```

### In Xcode
- Press `⌘U` to run all tests
- Click the diamond next to a test to run it individually

## Common Tasks

### Creating a New View

1. Create file in `Views/` or `Components/`
2. Follow MVVM pattern
3. Add Preview at bottom
4. Use Theme for styling

```swift
struct MyNewView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text("Hello")
            .font(Theme.Typography.body)
            .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
    }
}

#Preview {
    MyNewView()
}
```

### Adding a New Model Property

1. Update `TodoItem` model
2. SwiftData handles migration automatically
3. Update relevant ViewModels
4. Add tests

### Modifying Theme

All design tokens are in `Resources/Theme.swift`:
- Colors
- Typography
- Spacing
- Layout constants
- Animations

Change once, updates everywhere.

### Debugging

Enable detailed logging:
```swift
AppLogger.todo.debug("Detailed debug info")
AppLogger.forest.info("Important information")
AppLogger.persistence.error("Error occurred")
```

View logs in Console.app or Xcode console.

## Development Tips

### Hot Tips
- Use Xcode Previews for rapid iteration
- CMD+Option+P to pin previews
- CMD+Option+Enter to toggle canvas
- Use Live Previews for interactive testing

### Performance Profiling
```bash
# Time Profiler
instruments -t "Time Profiler" SumiForest.app

# Allocations
instruments -t "Allocations" SumiForest.app
```

### Accessibility Testing
- Enable VoiceOver in Settings
- Use Accessibility Inspector
- Test with Dynamic Type at different sizes
- Enable Reduce Motion and verify

## Troubleshooting

### Simulator Issues
```bash
# Reset simulator
xcrun simctl erase all

# Boot specific simulator
xcrun simctl boot "iPhone 15"
```

### Build Issues
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean in Xcode: Shift+CMD+K
```

### SwiftData Issues
- Data persists between runs
- Delete and reinstall app to reset
- Or use in-memory container for testing

## Next Steps

1. Read the [README](README.md) for full documentation
2. Check [CONTRIBUTING](CONTRIBUTING.md) for guidelines
3. Explore the codebase
4. Try implementing a small feature
5. Run the tests
6. Create a pull request!

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Guide](https://developer.apple.com/documentation/swiftdata)
- [Swift Style Guide](https://google.github.io/swift/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

## Getting Help

- Open an issue for bugs
- Start a discussion for questions
- Check existing issues and PRs
- Read the documentation

Happy coding! 🌳
