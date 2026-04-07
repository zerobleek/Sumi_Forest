//
//  Haptics.swift
//  Sumi Forest
//
//  Haptic feedback service for user interactions
//

import UIKit

/// Manages haptic feedback throughout the app
enum Haptics {
    
    /// Light impact for adding items
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Success feedback for completing tasks
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Selection feedback for UI interactions
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    /// Warning feedback for invalid operations
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Error feedback for failed operations
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
