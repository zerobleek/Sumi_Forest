//
//  ForestSpriteKitScene.swift
//  Sumi Forest
//
//  Main SpriteKit scene for the calligraphy forest
//

import SpriteKit
import SwiftUI

/// The main SpriteKit scene that renders the sumi-e forest.
/// Manages tree nodes, rice paper background, and ambient ink particles.
final class ForestSpriteKitScene: SKScene {

    // MARK: - Properties

    /// Callback when a tree is tapped (passes the associated task)
    var onTreeSelected: ((TodoTask) -> Void)?

    /// Current color scheme for background adaptation
    var colorScheme: ColorScheme = .light {
        didSet { updateBackground() }
    }

    /// Layout engine reused from the existing ForestViewModel
    private let layoutEngine = ForestLayoutEngine()

    /// Currently displayed tree nodes keyed by task ID
    private var treeNodes: [UUID: TreeNode] = [:]

    /// Ambient ink particle emitter
    private var ambientEmitter: SKEmitterNode?

    /// Background node
    private var backgroundNode: SKSpriteNode?

    // MARK: - Scene Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
        setupBackground()
        setupAmbientParticles()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateBackground()
        ambientEmitter?.position = CGPoint(x: size.width / 2, y: 0)
        ambientEmitter?.particlePositionRange = CGVector(dx: size.width, dy: 0)
    }

    // MARK: - Background

    private func setupBackground() {
        let bg = SKSpriteNode(color: .clear, size: size)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -10
        bg.name = "background"
        addChild(bg)
        backgroundNode = bg
        updateBackground()
    }

    private func updateBackground() {
        guard let bg = backgroundNode else { return }
        bg.size = size
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)

        // Rice paper color
        let paperColor: UIColor = colorScheme == .dark
            ? UIColor(Theme.Colors.paperDark)
            : UIColor(Theme.Colors.paper)
        bg.color = paperColor

        // Add subtle paper grain texture
        let grainKey = "paperGrain_\(colorScheme == .dark ? "dark" : "light")"
        let texture = TextureCache.shared.texture(forKey: grainKey) {
            generatePaperTexture(isDark: colorScheme == .dark)
        }
        bg.texture = texture
    }

    private func generatePaperTexture(isDark: Bool) -> SKTexture {
        let texSize = CGSize(width: 256, height: 256)
        let renderer = UIGraphicsImageRenderer(size: texSize)
        let image = renderer.image { ctx in
            let baseColor = isDark ? UIColor(Theme.Colors.paperDark) : UIColor(Theme.Colors.paper)
            baseColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: texSize))

            // Add subtle noise grain
            let grainAlpha: CGFloat = isDark ? 0.05 : 0.03
            var rng = SeededRandom(seed: 42)
            for x in stride(from: 0, to: Int(texSize.width), by: 2) {
                for y in stride(from: 0, to: Int(texSize.height), by: 2) {
                    let brightness = rng.nextCGFloat(in: 0...1)
                    let grainColor = isDark
                        ? UIColor.white.withAlphaComponent(brightness * grainAlpha)
                        : UIColor.black.withAlphaComponent(brightness * grainAlpha)
                    grainColor.setFill()
                    ctx.fill(CGRect(x: x, y: y, width: 2, height: 2))
                }
            }
        }
        return SKTexture(image: image)
    }

    // MARK: - Ambient Particles

    private func setupAmbientParticles() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 0.8
        emitter.particleLifetime = 8.0
        emitter.particleLifetimeRange = 4.0
        emitter.particleSpeed = 5
        emitter.particleSpeedRange = 3
        emitter.emissionAngle = .pi / 2 // Upward
        emitter.emissionAngleRange = .pi / 6
        emitter.particleAlpha = 0.08
        emitter.particleAlphaRange = 0.04
        emitter.particleAlphaSpeed = -0.008
        emitter.particleScale = 0.1
        emitter.particleScaleRange = 0.08
        emitter.particleColor = UIColor(Theme.Colors.ink.opacity(0.3))
        emitter.particleColorBlendFactor = 1.0
        emitter.position = CGPoint(x: size.width / 2, y: 0)
        emitter.particlePositionRange = CGVector(dx: size.width, dy: 0)
        emitter.zPosition = -5
        emitter.xAcceleration = 1.5 // Slight wind

        // Small dot texture
        let dotSize = CGSize(width: 4, height: 4)
        let renderer = UIGraphicsImageRenderer(size: dotSize)
        let image = renderer.image { ctx in
            UIColor(Theme.Colors.ink).setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: dotSize))
        }
        emitter.particleTexture = SKTexture(image: image)
        emitter.name = "ambientInk"

        addChild(emitter)
        ambientEmitter = emitter
    }

    // MARK: - Tree Management

    /// Updates the scene with the current set of completed tasks.
    /// Adds new trees and removes ones no longer in the list.
    func updateTrees(with tasks: [TodoTask]) {
        let taskIDs = Set(tasks.map(\.id))
        let existingIDs = Set(treeNodes.keys)

        // Remove trees for tasks that are no longer completed
        let toRemove = existingIDs.subtracting(taskIDs)
        for id in toRemove {
            if let node = treeNodes.removeValue(forKey: id) {
                node.removeWithInkDispersion()
            }
        }

        // Add trees for newly completed tasks
        let toAdd = tasks.filter { !existingIDs.contains($0.id) }
        guard !toAdd.isEmpty else { return }

        // Generate positions for ALL tasks to keep layout stable
        let positions = layoutEngine.generatePositions(count: tasks.count, bounds: size)

        for (index, task) in tasks.enumerated() where !existingIDs.contains(task.id) {
            let treeNode = createTreeNode(for: task)
            let position = index < positions.count ? positions[index] : CGPoint(
                x: CGFloat.random(in: 40...(size.width - 40)),
                y: CGFloat.random(in: 40...(size.height - 40))
            )
            // SpriteKit has Y-up; position directly
            treeNode.position = position
            treeNode.zPosition = CGFloat(index)
            addChild(treeNode)
            treeNodes[task.id] = treeNode

            // Paint the tree with animation
            treeNode.paintTree()
        }
    }

    private func createTreeNode(for task: TodoTask) -> TreeNode {
        switch task.treeSpecies {
        case .bamboo: return BambooNode(task: task)
        case .maple: return MapleNode(task: task)
        case .pine: return PineNode(task: task)
        case .sakura: return SakuraNode(task: task)
        }
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Find the nearest tree within a reasonable tap radius
        var closestTree: TreeNode?
        var closestDistance: CGFloat = 40 // Tap radius threshold

        for (_, node) in treeNodes {
            let distance = hypot(location.x - node.position.x, location.y - node.position.y)
            if distance < closestDistance {
                closestDistance = distance
                closestTree = node
            }
        }

        if let tree = closestTree {
            tree.addSelectionRipple()
            Haptics.selection()
            onTreeSelected?(tree.task)
        }
    }
}
