//
//  InkRevealOverlay.swift
//  Sumi Forest
//
//  Circular mask reveal animation for yin/yang mode transitions.
//  Switching to dark: ink drop expands to fill the screen.
//  Switching to light: paper is revealed from beneath the ink.
//

import SwiftUI

/// A view modifier that overlays a circular reveal animation during mode transitions.
struct InkRevealModifier: ViewModifier {
    let themeManager: ThemeManager

    func body(content: Content) -> some View {
        content
            .overlay {
                if themeManager.isTransitioning {
                    InkRevealOverlay(themeManager: themeManager)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
    }
}

/// The actual overlay that renders the expanding circle mask.
struct InkRevealOverlay: View {
    let themeManager: ThemeManager

    var body: some View {
        GeometryReader { geometry in
            let maxRadius = maxCircleRadius(in: geometry.size)
            let currentRadius = maxRadius * themeManager.transitionProgress

            // Fill with the OLD scheme's background color, then cut a circle hole
            // revealing the NEW scheme underneath
            Canvas { context, size in
                // Fill the entire canvas with the previous background
                let bgColor = Theme.Colors.background(for: themeManager.previousScheme)
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(bgColor)
                )

                // Cut a circle at the origin point to reveal new scheme
                let origin = themeManager.transitionOrigin
                let circleRect = CGRect(
                    x: origin.x - currentRadius,
                    y: origin.y - currentRadius,
                    width: currentRadius * 2,
                    height: currentRadius * 2
                )
                context.blendMode = .clear
                context.fill(
                    Path(ellipseIn: circleRect),
                    with: .color(.white)
                )
            }
            .compositingGroup()
        }
    }

    /// Calculate the radius needed to cover the entire screen from the origin point
    private func maxCircleRadius(in size: CGSize) -> CGFloat {
        let origin = themeManager.transitionOrigin
        let corners: [CGPoint] = [
            .zero,
            CGPoint(x: size.width, y: 0),
            CGPoint(x: 0, y: size.height),
            CGPoint(x: size.width, y: size.height)
        ]
        let maxDistance = corners.map { corner in
            hypot(corner.x - origin.x, corner.y - origin.y)
        }.max() ?? hypot(size.width, size.height)

        return maxDistance
    }
}

// MARK: - View Extension

extension View {
    /// Adds the yin/yang ink reveal transition overlay
    func inkRevealTransition(_ themeManager: ThemeManager) -> some View {
        modifier(InkRevealModifier(themeManager: themeManager))
    }
}
