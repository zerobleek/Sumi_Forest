//
//  SpriteKitForestView.swift
//  Sumi Forest
//
//  UIViewRepresentable bridge between SwiftUI and the SpriteKit forest scene
//

import SwiftUI
import SpriteKit

/// SwiftUI wrapper that hosts the SpriteKit calligraphy forest scene.
struct SpriteKitForestView: UIViewRepresentable {
    let completedTasks: [TodoTask]
    let colorScheme: ColorScheme
    let onTreeSelected: (TodoTask) -> Void

    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.ignoresSiblingOrder = true

        #if DEBUG
        skView.showsFPS = false
        skView.showsNodeCount = false
        #endif

        let scene = ForestSpriteKitScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.colorScheme = colorScheme
        scene.onTreeSelected = onTreeSelected
        skView.presentScene(scene)

        context.coordinator.scene = scene

        return skView
    }

    func updateUIView(_ skView: SKView, context: Context) {
        guard let scene = context.coordinator.scene else { return }

        // Update color scheme if changed
        if scene.colorScheme != colorScheme {
            scene.colorScheme = colorScheme
        }

        // Resize scene if view bounds changed
        if scene.size != skView.bounds.size && skView.bounds.size != .zero {
            scene.size = skView.bounds.size
        }

        // Update tree callback (captures may change)
        scene.onTreeSelected = onTreeSelected

        // Update trees with current task list
        scene.updateTrees(with: completedTasks)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var scene: ForestSpriteKitScene?
    }
}
