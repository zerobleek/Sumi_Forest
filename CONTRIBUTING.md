# Contributing to Sumi Forest

Thank you for your interest in contributing to Sumi Forest! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Device and iOS version

### Suggesting Features

1. Check if the feature has been suggested in Issues
2. Create a new issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Potential implementation approach

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the coding standards below
4. **Write tests** for new functionality
5. **Update documentation** if needed
6. **Commit with conventional commits**:
   ```bash
   git commit -m "feat: add forest export feature"
   ```
7. **Push to your fork** and create a pull request

## Coding Standards

### Swift Style Guide

- Follow standard Swift naming conventions
- Use `PascalCase` for types and protocols
- Use `camelCase` for properties, variables, and functions
- Add documentation comments for all public types and methods
- Use meaningful variable and function names

### Architecture

- Follow MVVM strictly
- Keep business logic in ViewModels
- Views should be purely presentational
- Use SwiftData for persistence
- Use `@Observable` for view models (not `ObservableObject`)

### File Organization

```
SumiForest/
├── App/          # App entry point
├── Models/       # Data models
├── ViewModels/   # Business logic
├── Views/        # SwiftUI views
├── Components/   # Reusable components
├── Services/     # Services and utilities
├── Resources/    # Assets and theme
└── Tests/        # Unit and UI tests
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add iCloud sync support
fix: resolve tree overlap issue
docs: update README with new features
test: add tests for forest layout engine
```

### Testing

- Write unit tests for models and business logic
- Write UI tests for critical user flows
- Ensure all tests pass before submitting PR
- Aim for >80% code coverage

Run tests:
```bash
xcodebuild test -scheme SumiForest -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Code Review

Pull requests will be reviewed for:
- Code quality and style
- Test coverage
- Documentation
- Performance
- Accessibility
- Design consistency

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sumi-forest.git
   cd sumi-forest
   ```

2. Open in Xcode:
   ```bash
   open SumiForest.xcodeproj
   ```

3. Build and run (⌘R)

## Areas for Contribution

Current priorities:
- [ ] iCloud sync implementation
- [ ] Widget development
- [ ] Notification system
- [ ] Forest themes
- [ ] Performance optimizations
- [ ] Additional tree species
- [ ] Localization
- [ ] Accessibility improvements

## Questions?

- Open an issue for questions about the codebase
- Tag issues with `question` label
- Join discussions in pull requests

## Recognition

Contributors will be acknowledged in:
- Release notes
- README contributors section
- Project documentation

Thank you for making Sumi Forest better! 🌳
