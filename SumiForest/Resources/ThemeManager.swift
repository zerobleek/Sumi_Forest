//
//  ThemeManager.swift
//  Sumi Forest
//
//  Manages light/dark mode state and yin/yang transition animation
//

import SwiftUI

/// Manages the app's color scheme with animated yin/yang transitions.
/// Light mode = Yang (paper ground), Dark mode = Yin (ink ground).
@Observable
final class ThemeManager {

    /// The currently active color scheme
    var currentScheme: ColorScheme = .light

    /// Whether a transition animation is in progress
    var isTransitioning: Bool = false

    /// The screen-space origin point of the circular reveal
    var transitionOrigin: CGPoint = .zero

    /// Animation progress (0 = start, 1 = fully revealed)
    var transitionProgress: CGFloat = 0

    /// The scheme we're transitioning FROM (used by the overlay snapshot)
    var previousScheme: ColorScheme = .light

    /// Triggers the yin/yang mode transition from a given origin point.
    func toggle(from origin: CGPoint) {
        guard !isTransitioning else { return }

        previousScheme = currentScheme
        transitionOrigin = origin
        isTransitioning = true
        transitionProgress = 0

        // Flip the scheme immediately (new state renders underneath)
        currentScheme = (currentScheme == .light) ? .dark : .light

        // Animate the reveal circle
        withAnimation(Theme.Animation.modeTransition) {
            transitionProgress = 1
        }

        // Clean up after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [weak self] in
            self?.isTransitioning = false
            self?.transitionProgress = 0
        }
    }

    /// Whether the current mode is dark (Yin)
    var isYin: Bool { currentScheme == .dark }

    /// Symbol name for the toggle button
    var toggleSymbol: String {
        isYin ? "sun.max.fill" : "moon.fill"
    }
}
