# Project Structure

This document describes the complete structure of the Sumi Forest project.

## Overview

Sumi Forest is organized following Apple's recommended project structure with clear separation of concerns and MVVM architecture.

## Directory Tree

```
SumiForest/
├── SumiForest.xcodeproj/          # Xcode project file
│   └── project.pbxproj            # Project configuration
│
├── SumiForest/                    # Main app source code
│   ├── App/                       # Application entry point
│   │   └── SumiForestApp.swift   # App lifecycle & container setup
│   │
│   ├── Models/                    # Data models
│   │   ├── TodoItem.swift        # Core task model (SwiftData)
│   │   └── AppError.swift        # Centralized error types
│   │
│   ├── Services/                  # Business services
│   │   ├── Haptics.swift         # Haptic feedback manager
│   │   └── Logger.swift          # Logging service (os.Logger)
│   │
│   ├── ViewModels/                # MVVM ViewModels
│   │   ├── TodoViewModel.swift   # To-do list business logic
│   │   └── ForestViewModel.swift # Forest visualization logic
│   │
│   ├── Views/                     # SwiftUI views
│   │   ├── ContentView.swift     # Main tab container
│   │   ├── TodoListView.swift    # To-do list interface
│   │   ├── TodoEditorView.swift  # Task creation/editing sheet
│   │   └── ForestView.swift      # Forest visualization
│   │
│   ├── Components/                # Reusable UI components
│   │   └── TodoRowView.swift     # Individual task row
│   │
│   ├── Resources/                 # Assets and resources
│   │   ├── Theme.swift           # Design system (single source of truth)
│   │   ├── Assets.xcassets/      # Asset catalog
│   │   │   ├── Colors/           # Color assets
│   │   │   │   ├── Background.colorset/
│   │   │   │   ├── PrimaryText.colorset/
│   │   │   │   ├── SecondaryText.colorset/
│   │   │   │   ├── Accent.colorset/
│   │   │   │   └── Divider.colorset/
│   │   │   └── AppIcon.appiconset/
│   │   └── LaunchScreen.storyboard
│   │
│   ├── Widgets/                   # Home Screen widgets (future)
│   │
│   ├── Tests/                     # Unit and UI tests
│   │   ├── TodoModelTests.swift
│   │   ├── ForestLayoutTests.swift
│   │   └── TreeGeneratorTests.swift
│   │
│   └── Info.plist                 # App configuration
│
├── Documentation/
│   ├── README.md                  # Main documentation
│   ├── TROUBLESHOOTING.md        # Issue resolution guide
│   ├── CONTRIBUTING.md           # Contribution guidelines
│   ├── CHANGELOG.md              # Version history
│   └── PROJECT_STRUCTURE.md      # This file
│
├── Configuration/
│   ├── .gitignore                # Git ignore rules
│   ├── .swiftlint.yml           # SwiftLint configuration
│   └── Package.swift            # Swift Package (if needed)
│
└── Scripts/                       # Build and utility scripts
    ├── setup.sh                  # Project setup script
    └── test.sh                   # Test runner script
```

## File Responsibilities

### App Layer
**SumiForestApp.swift**
- App entry point
- SwiftData container configuration
- App lifecycle management
- Haptics preparation

### Models
**TodoItem.swift**
- SwiftData model for tasks
- Task properties (title, note, dates, priority, etc.)
- Completion state management
- Tree species and size calculation

**AppError.swift**
- Centralized error types
- User-friendly error messages
- Recovery suggestions

### Services
**Haptics.swift**
- Light impact (add actions)
- Success feedback (completions)
- Selection feedback (taps)
- Error feedback

**Logger.swift**
- Categorized logging (todo, forest, persistence, ui)
- os.Logger wrapper
- Debug/release log levels

### ViewModels
**TodoViewModel.swift**
- Task CRUD operations
- Filtering (All, Today, Upcoming, Completed)
- Sorting (Created, Due, Priority)
- Search functionality
- Error state management
- Fetch from SwiftData

**ForestViewModel.swift**
- Load completed tasks as trees
- Generate tree layout (Poisson disk sampling)
- Calculate tree sizes
- Forest statistics
- Tree selection state

### Views
**ContentView.swift**
- Tab navigation
- ViewModel initialization
- Tab state management

**TodoListView.swift**
- Task list display
- Quick add field
- Filter/sort controls
- Swipe actions
- Empty state
- Error alerts

**TodoEditorView.swift**
- Task creation form
- Task editing form
- Input validation
- Priority picker
- Due date selection

**ForestView.swift**
- Forest canvas
- Tree rendering
- Statistics header
- Empty state
- Refresh action
- Tree detail sheet

### Components
**TodoRowView.swift**
- Task row UI
- Completion indicator
- Priority color dot
- Due date display
- Overdue highlighting

### Resources
**Theme.swift**
- Color palette (single source)
- Typography scale
- Spacing constants
- Corner radius values
- Animation presets

## Architecture Patterns

### MVVM (Model-View-ViewModel)
```
┌─────────────┐
│    View     │ ← SwiftUI views, no business logic
└──────┬──────┘
       │
       ↓
┌─────────────┐
│ ViewModel   │ ← Business logic, state management
└──────┬──────┘
       │
       ↓
┌─────────────┐
│    Model    │ ← SwiftData models, data structures
└─────────────┘
```

### Data Flow
```
User Action → View → ViewModel → Model → SwiftData
                                    ↓
                              State Change
                                    ↓
                              View Update
```

### Error Handling
```
Operation → Try/Catch → AppError → ViewModel.appError → Alert
```

## Dependencies

### Internal
- SwiftUI (UI framework)
- SwiftData (persistence)
- Observation (state management)
- OSLog (logging)
- UIKit (haptics only)

### External
- **None** - Zero third-party dependencies

## Build Targets

### SumiForest (Main App)
- Platform: iOS 17.0+
- Language: Swift 5.9+
- Deployment: iPhone & iPad
- Orientation: Portrait preferred

### SumiForestTests (Unit Tests)
- Test framework: XCTest
- Target: SumiForest
- Host: SumiForest

## Asset Organization

### Colors
Adaptive colors supporting light and dark mode:
- Background (paper texture)
- PrimaryText
- SecondaryText
- Accent
- Divider

### Images
- AppIcon (1024x1024)
- Tree sprites (placeholder SF Symbols for MVP)
- Launch icon

## Configuration Files

### Info.plist
- Bundle identifier
- Display name
- Version info
- Supported orientations
- Launch screen configuration

### .swiftlint.yml
- Code style rules
- Line length limits
- Naming conventions
- Complexity thresholds

### .gitignore
- Xcode user data
- Build artifacts
- Derived data
- DS_Store files

## Testing Structure

### Unit Tests
- **TodoModelTests**: Model behavior
- **ForestLayoutTests**: Tree generation
- **TreeGeneratorTests**: Tree properties

### Test Organization
```
Tests/
├── Models/
│   └── TodoModelTests.swift
├── ViewModels/
│   ├── TodoViewModelTests.swift    # (future)
│   └── ForestViewModelTests.swift  # (future)
└── Services/
    ├── ForestLayoutTests.swift
    └── TreeGeneratorTests.swift
```

## Documentation Files

### README.md
- Project overview
- Features list
- Installation instructions
- Architecture explanation
- Usage examples
- Contributing guidelines

### TROUBLESHOOTING.md
- Common issues
- Diagnostic steps
- Solutions
- Debug information

### CONTRIBUTING.md
- Development setup
- Code style guide
- PR process
- Commit conventions
- Testing requirements

### CHANGELOG.md
- Version history
- Feature additions
- Bug fixes
- Breaking changes

## Scripts

### setup.sh (future)
```bash
#!/bin/bash
# Initialize project
# Install dependencies
# Configure git hooks
```

### test.sh
```bash
#!/bin/bash
# Run all tests
# Generate coverage report
# Lint code
```

## Future Structure

As the project grows, consider adding:

```
SumiForest/
├── Extensions/              # Swift extensions
├── Utilities/               # Helper functions
├── Network/                 # API layer (iCloud sync)
├── Persistence/             # Data migration
├── Localization/           # Internationalization
└── UI/
    ├── Modifiers/          # Custom view modifiers
    └── Styles/             # Custom styles
```

## Build Configurations

### Debug
- Optimization: None
- Logging: Verbose
- Debug menu: Enabled
- Assertions: Enabled

### Release
- Optimization: -O (speed)
- Logging: Error only
- Debug menu: Disabled
- Assertions: Disabled

## Performance Targets

- Launch time: < 300ms
- Frame rate: ≥ 55 FPS @ 200 trees
- Memory: < 50MB typical
- Battery: Minimal impact

## Accessibility

All views support:
- VoiceOver
- Dynamic Type
- Reduce Motion
- High Contrast
- Minimum touch target: 44x44pt

## Localization

Currently English only. Future expansion:
- Japanese (fitting theme)
- Chinese (Simplified & Traditional)
- Korean
- Spanish
- French

## Version Control

### Branch Strategy
- `main`: Stable releases
- `develop`: Development branch
- `feature/*`: Feature branches
- `bugfix/*`: Bug fix branches

### Tag Format
- `v1.0.0`: Release version
- `v1.0.0-beta.1`: Beta version
- `v1.0.0-rc.1`: Release candidate

## Distribution

### TestFlight (Beta)
- Internal testing
- External beta testing
- Crash reporting

### App Store (Production)
- Production builds
- App Store Connect
- Version management

---

*This structure supports scalability while maintaining simplicity for the MVP.*
