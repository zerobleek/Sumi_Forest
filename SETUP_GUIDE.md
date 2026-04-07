# Setup Guide

Complete guide for setting up and running Sumi Forest on your development machine.

## 📋 Prerequisites

### Required Software
- **macOS**: 13.0 (Ventura) or later
- **Xcode**: 15.0 or later
- **iOS Device/Simulator**: iOS 17.0 or later
- **Git**: 2.30 or later

### Recommended Tools
- **SwiftLint**: For code linting (optional)
- **Instruments**: For performance profiling (included with Xcode)
- **Console.app**: For viewing logs (included with macOS)

### Hardware Requirements
- Mac with Apple Silicon or Intel processor
- 8GB RAM minimum (16GB recommended)
- 10GB free disk space

## 🚀 Quick Start

### 1. Get the Code

**Option A: Clone Repository**
```bash
git clone https://github.com/yourusername/SumiForest.git
cd SumiForest
```

**Option B: Download ZIP**
1. Download the project ZIP
2. Extract to your desired location
3. Navigate to the folder in Terminal

### 2. Open in Xcode

```bash
# From the project root directory
open SumiForest.xcodeproj
```

Or double-click `SumiForest.xcodeproj` in Finder.

### 3. Select Target Device

In Xcode:
1. Click the device selector (next to the Run button)
2. Choose a simulator (e.g., iPhone 15)
3. Or connect a physical device

### 4. Build and Run

**Keyboard Shortcut**: ⌘R

**Menu**: Product → Run

**Expected Result**: 
- App launches with empty to-do list
- Sample data may be generated on first launch
- Forest view accessible via tab bar

## 🔧 Detailed Setup

### Configuring the Project

#### 1. Bundle Identifier
Default: `com.example.SumiForest`

To change:
1. Select project in Xcode navigator
2. Select SumiForest target
3. Update "Bundle Identifier" under Signing & Capabilities

#### 2. Signing
**For Simulator**: No configuration needed

**For Physical Device**:
1. Select your development team
2. Xcode will automatically manage signing
3. Trust the developer on your device (Settings → General → Device Management)

#### 3. Build Settings
Default settings should work. To verify:
- Swift Language Version: Swift 5
- iOS Deployment Target: iOS 17.0
- Build Active Architecture Only: Debug=Yes, Release=No

### Installing Optional Tools

#### SwiftLint
```bash
# Using Homebrew
brew install swiftlint

# Verify installation
swiftlint version
```

To enable in project:
1. Uncomment SwiftLint build phase in Xcode
2. Or add manually: Target → Build Phases → + → New Run Script Phase
3. Script: `swiftlint`

## 🧪 Running Tests

### All Tests
```bash
# In Xcode
⌘U

# Command line
xcodebuild -scheme SumiForest \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  test
```

### Specific Test Suite
```bash
xcodebuild -scheme SumiForest \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:SumiForestTests/TodoModelTests \
  test
```

### Test Coverage
1. Enable code coverage: Scheme → Test → Options → Code Coverage
2. Run tests (⌘U)
3. View coverage: Report Navigator (⌘9) → Coverage tab

## 🐛 Debugging

### Console Logs
View logs in Xcode console (⌘⇧Y) or Console.app.

**Filter logs:**
```
# All app logs
process:SumiForest

# Specific category
process:SumiForest category:todo
process:SumiForest category:forest
process:SumiForest category:persistence
```

### Breakpoints
1. Click line number gutter in Xcode
2. Or ⌘\ on the line
3. Run with debugger attached (⌘R)

### Instruments
Profile performance:
1. Product → Profile (⌘I)
2. Choose instrument:
   - Time Profiler (CPU usage)
   - Allocations (memory)
   - Leaks (memory leaks)

## 📱 Testing on Device

### Physical Device Setup
1. **Connect device** via USB
2. **Trust computer** (on device)
3. **Enable Developer Mode**:
   - Settings → Privacy & Security → Developer Mode → On
   - Device will restart
4. **Select device** in Xcode
5. **Build and run** (⌘R)

### Common Device Issues

**"Developer Mode required"**
- Enable as described above

**"Untrusted Developer"**
- Settings → General → Device Management
- Tap your certificate
- Trust

**"Failed to verify code signature"**
- Check signing configuration
- Verify team selection
- Clean build folder (⌘⇧K)

## 🎨 Viewing Assets

### Asset Catalog
1. Open `Assets.xcassets`
2. Browse colors, images, icons
3. Preview in different appearances

### Previews
Each view has SwiftUI previews:
1. Open any View file
2. Click "Resume" in canvas (⌥⌘↩)
3. Or Editor → Canvas

## 📝 Code Organization

### Adding New Files
1. File → New → File (⌘N)
2. Choose Swift File
3. Place in appropriate folder:
   - Views: SwiftUI views
   - ViewModels: Business logic
   - Models: Data structures
   - Services: Shared services
   - Components: Reusable UI

### Naming Conventions
- **Views**: `*View.swift` (e.g., `TodoListView.swift`)
- **ViewModels**: `*ViewModel.swift`
- **Models**: Descriptive name (e.g., `TodoItem.swift`)
- **Tests**: `*Tests.swift`

## 🔄 Version Control

### Initial Commit
```bash
git init
git add .
git commit -m "Initial commit"
```

### Branching
```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: Add my feature"

# Push to remote
git push origin feature/my-feature
```

### .gitignore
Already configured to ignore:
- Xcode user data
- Build artifacts
- .DS_Store files
- SwiftLint cache

## 🚨 Troubleshooting Setup

### Xcode Won't Open Project
**Solution**:
```bash
# Verify Xcode is installed
xcode-select -p

# If not, install from App Store
# Then set path:
sudo xcode-select -s /Applications/Xcode.app
```

### Build Fails with "Missing Module"
**Solution**:
1. Clean build folder: Product → Clean Build Folder (⌘⇧K)
2. Delete derived data: 
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Restart Xcode
4. Build again (⌘B)

### Simulator Not Listed
**Solution**:
1. Xcode → Settings → Platforms
2. Download iOS simulators
3. Wait for download to complete
4. Restart Xcode

### "Command Line Tools Not Found"
**Solution**:
```bash
xcode-select --install
```

### Port Already in Use
**Solution**:
- Quit other Xcode instances
- Reset simulator: Device → Erase All Content and Settings

## 📊 Performance Profiling

### Setup for Profiling
1. Build for profiling: Product → Profile (⌘I)
2. Choose Release build configuration
3. Select instrument
4. Record session

### Key Metrics to Watch
- **Launch Time**: Target < 300ms
- **Frame Rate**: Target ≥ 55 FPS
- **Memory**: Target < 50MB
- **CPU**: Target < 20% average

### Profiling Tips
- Use Release build
- Test on physical device
- Run multiple scenarios
- Compare before/after changes

## 🔐 Security

### Code Signing
Automatic signing is enabled by default.

**Manual Signing**:
1. Disable automatic signing
2. Select provisioning profile
3. Configure for each target

### Secrets Management
- No API keys in this project
- Future: Use Keychain for sensitive data
- Never commit secrets to git

## 🌐 Localization (Future)

### Adding Languages
1. Project → Info → Localizations
2. Click + to add language
3. Select files to localize
4. Translate strings files

## 📱 Distribution

### TestFlight
1. Archive: Product → Archive
2. Upload to App Store Connect
3. Configure TestFlight
4. Add testers

### App Store
1. Create app in App Store Connect
2. Upload archive
3. Submit for review

## ✅ Setup Checklist

Before first run:
- [ ] Xcode 15.0+ installed
- [ ] Project opened successfully
- [ ] Bundle identifier configured
- [ ] Signing configured (if device testing)
- [ ] Target device/simulator selected
- [ ] Build succeeds (⌘B)
- [ ] Tests pass (⌘U)
- [ ] App launches successfully (⌘R)
- [ ] Can add and complete tasks
- [ ] Forest view displays trees
- [ ] Dark mode works
- [ ] No console errors

## 🆘 Getting Help

If you encounter issues:

1. **Check documentation**:
   - README.md
   - TROUBLESHOOTING.md
   - This guide

2. **Search issues**:
   - GitHub issues
   - Stack Overflow

3. **Report bug**:
   - Open GitHub issue
   - Include error messages
   - Attach console logs
   - Describe steps to reproduce

## 📚 Additional Resources

### Apple Documentation
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [SwiftData](https://developer.apple.com/documentation/swiftdata)
- [Xcode](https://developer.apple.com/documentation/xcode)

### Community
- [Swift Forums](https://forums.swift.org)
- [r/SwiftUI](https://reddit.com/r/SwiftUI)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)

### Tools
- [SwiftLint](https://github.com/realm/SwiftLint)
- [Instruments](https://developer.apple.com/instruments)

---

**Ready to build! 🎉**

*Next: Open `README.md` for feature overview and usage guide.*
