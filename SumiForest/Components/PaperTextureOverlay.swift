//
//  PaperTextureOverlay.swift
//  Sumi Forest
//
//  Subtle paper grain texture overlay for SwiftUI views.
//  Matches the SpriteKit scene's rice paper aesthetic.
//

import SwiftUI

/// Renders a subtle deterministic noise pattern that simulates paper grain.
/// Applied as an overlay on the root background so the todo list
/// matches the SpriteKit forest's rice paper texture.
struct PaperTextureOverlay: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Canvas { context, size in
            let grainAlpha = colorScheme == .dark
                ? Theme.Texture.grainAlphaDark
                : Theme.Texture.grainAlphaLight
            let grainColor: Color = colorScheme == .dark ? .white : .black
            let step = 3

            // Deterministic noise using a simple hash
            for x in stride(from: 0, to: Int(size.width), by: step) {
                for y in stride(from: 0, to: Int(size.height), by: step) {
                    let hash = (x &* 2654435761) ^ (y &* 2246822519)
                    let brightness = Double(abs(hash) % 256) / 255.0
                    let alpha = brightness * grainAlpha

                    let rect = CGRect(x: x, y: y, width: step, height: step)
                    context.fill(
                        Path(rect),
                        with: .color(grainColor.opacity(alpha))
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .drawingGroup()
    }
}
