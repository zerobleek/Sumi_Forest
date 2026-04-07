# Troubleshooting Guide

This guide helps you diagnose and fix common issues with Sumi Forest.

## 🌳 Forest Issues

### Problem: Blank Forest / No Trees Appearing

**Symptoms:**
- Forest view is empty despite having completed tasks
- Statistics show 0 trees

**Diagnostics:**
1. Check if you have any completed tasks:
   - Go to To-Do List tab
   - Filter by "Completed"
   - Verify tasks exist with checkmarks

2. Check console logs:
   ```
   Filter logs by "forest" category
   Look for "Loaded X trees" message
   ```

**Solutions:**
1. Complete a task:
   - Swipe right on any task in the list
   - Tap the circle icon
   - Switch to Forest tab

2. Force refresh:
   - Tap the refresh button (↻) in Forest view
   - This reloads all completed tasks

3. Reset data (last resort):
   - Use debug menu in development builds
   - Or reinstall the app

---

### Problem: Trees Overlapping Too Much

**Symptoms:**
- Multiple trees positioned on top of each other
- Forest looks cluttered

**Explanation:**
The layout algorithm uses Poisson disk sampling to space trees, but with many trees (50+), some overlap is natural and intentional for a dense forest effect.

**Solutions:**
1. This is expected behavior for dense forests (50+ trees)

2. Adjust spacing (for developers):
   - Open `ForestViewModel.swift`
   - Increase `minDistance` value (currently 60)
   - Rebuild the app

3. Clear old completed tasks:
   - Go to To-Do List
   - Filter by "Completed"
   - Swipe left to delete old tasks

---

### Problem: Trees Not Growing (Animation Issues)

**Symptoms:**
- Trees appear instantly without animation
- No smooth growth effect

**Solutions:**
1. Check Reduce Motion setting:
   - iOS Settings → Accessibility → Motion
   - Toggle "Reduce Motion" off
   - Return to app

2. Force quit and relaunch:
   - Swipe up to close app
   - Reopen from home screen

---

## 📝 To-Do List Issues

### Problem: Cannot Add Tasks

**Symptoms:**
- Quick add field doesn't respond
- "Add" button is disabled in editor

**Solutions:**
1. Verify you're entering text:
   - Title field cannot be empty
   - Remove leading/trailing spaces

2. Check for error alerts:
   - Look for error messages
   - Read the suggested fix

3. Check storage space:
   - iOS Settings → General → iPhone Storage
   - Ensure device has free space

---

### Problem: Tasks Not Saving

**Symptoms:**
- Added tasks disappear after app restart
- Changes to tasks are lost

**Diagnostics:**
Check console for persistence errors:
```
Filter logs by "persistence" category
Look for "Failed to save" messages
```

**Solutions:**
1. Restart the app:
   - Force quit
   - Reopen

2. Check storage permissions:
   - iOS Settings → SumiForest
   - Verify all permissions granted

3. Reinstall app (nuclear option):
   - Delete app
   - Reinstall
   - Note: This deletes all data

---

### Problem: Swipe Actions Not Working

**Symptoms:**
- Cannot swipe to complete/delete tasks
- Swipe gestures don't register

**Solutions:**
1. Ensure you're swiping on the task row:
   - Not the quick add field
   - Not empty space

2. Swipe fully:
   - Swipe right = complete
   - Swipe left = edit/delete
   - Full swipe required for action

3. Check VoiceOver:
   - iOS Settings → Accessibility → VoiceOver
   - Turn off if enabled (unless needed)

---

## 🎨 Visual Issues

### Problem: Wrong Colors / Theme Issues

**Symptoms:**
- Colors don't match screenshots
- Dark mode not working properly

**Solutions:**
1. Check iOS appearance:
   - iOS Settings → Display & Brightness
   - Verify Light/Dark mode setting

2. Restart app:
   - Force quit
   - Reopen

3. Verify assets:
   - Open Xcode
   - Check Assets.xcassets
   - Ensure all color sets exist

---

### Problem: Layout Issues / Overlapping Text

**Symptoms:**
- Text cut off
- UI elements overlapping
- Buttons not visible

**Solutions:**
1. Check Dynamic Type:
   - iOS Settings → Display & Brightness → Text Size
   - Reduce if at maximum
   - App supports Dynamic Type up to XXL

2. Try landscape orientation:
   - Rotate device
   - Check if issue persists

3. Restart app:
   - Force quit and reopen

---

## ⚡ Performance Issues

### Problem: App Feels Slow / Laggy

**Symptoms:**
- Scrolling stutters
- Animations drop frames
- App feels unresponsive

**Diagnostics:**
1. Check task count:
   - Go to To-Do List
   - Count total tasks
   - 100+ tasks may impact performance

2. Check tree count:
   - Go to Forest view
   - Note total trees
   - 200+ trees may slow rendering

**Solutions:**
1. Archive old tasks:
   - Filter by "Completed"
   - Delete tasks older than 30 days
   - Keep forest under 150 trees

2. Restart device:
   - Full device restart
   - Clears system memory

3. Close other apps:
   - Double-click home
   - Swipe up on other apps

---

### Problem: App Crashes

**Symptoms:**
- App suddenly closes
- Returns to home screen
- Data may be lost

**Diagnostics:**
1. Check iOS version:
   - iOS Settings → General → About
   - Requires iOS 17.0+

2. Review crash logs:
   - Connect to Mac
   - Open Console app
   - Filter by "SumiForest"

**Solutions:**
1. Update iOS:
   - iOS Settings → General → Software Update
   - Install latest version

2. Reinstall app:
   - Delete app
   - Reinstall
   - Note: Loses all data

3. Report bug:
   - Open GitHub issue
   - Include iOS version
   - Describe steps to reproduce

---

## 🔧 Development Issues

### Problem: Build Errors in Xcode

**Symptoms:**
- "Cannot find type" errors
- "Module not found" errors
- Build fails

**Solutions:**
1. Clean build folder:
   - Product → Clean Build Folder (⇧⌘K)
   - Build again (⌘B)

2. Reset package dependencies:
   - File → Packages → Reset Package Caches
   - Build again

3. Restart Xcode:
   - Quit Xcode completely
   - Reopen project

---

### Problem: SwiftData Migration Errors

**Symptoms:**
- App crashes on launch after update
- "Model version mismatch" errors

**Solutions:**
1. Delete app and reinstall (loses data)

2. Implement migration (for developers):
   - Update `ModelConfiguration`
   - Add migration plan
   - Test thoroughly

---

### Problem: Tests Failing

**Symptoms:**
- XCTest failures
- Tests timeout
- Assertion errors

**Solutions:**
1. Clean test bundle:
   - Product → Clean Build Folder
   - Run tests again (⌘U)

2. Check simulator:
   - Use iPhone 15 simulator
   - iOS 17.0+
   - Reset simulator if needed

3. Run tests individually:
   - Click diamond next to test method
   - Identify specific failing test

---

## 📊 Debug Menu

### Accessing Debug Features (Development Builds Only)

**Note:** Debug menu only available in development/debug builds, not release builds.

**Features:**
- Reset all data
- Spawn sample trees
- Toggle dark mode
- View performance metrics

**Access:**
1. Shake device (on physical device)
2. Or add debug button in code

---

## 🆘 Still Having Issues?

If none of the above solutions work:

1. **Check requirements:**
   - iOS 17.0 or later
   - iPhone 8 or newer
   - 50MB free storage

2. **Gather information:**
   - iOS version
   - Device model
   - Steps to reproduce
   - Console logs

3. **Report issue:**
   - Open GitHub issue
   - Include all gathered info
   - Attach screenshots if relevant

4. **Workarounds:**
   - Try different device
   - Use simulator for testing
   - Wait for next update

---

## 📝 Diagnostic Checklist

Use this checklist when troubleshooting:

- [ ] iOS version 17.0+?
- [ ] App up to date?
- [ ] Device storage available?
- [ ] App permissions granted?
- [ ] Tried force quit & reopen?
- [ ] Tried device restart?
- [ ] Checked console logs?
- [ ] Tried on different device?
- [ ] Issue reproducible?
- [ ] Reported to developers?

---

## 🔍 Console Log Filters

When viewing console logs in Xcode:

```
# View all app logs
process:SumiForest

# View only errors
process:SumiForest error

# View persistence issues
process:SumiForest category:persistence

# View forest rendering
process:SumiForest category:forest

# View todo operations
process:SumiForest category:todo
```

---

*Last updated: November 2025*
