//
//  TreeNode.swift
//  Sumi Forest
//
//  Base SpriteKit tree node with sumi-e ink painting effects
//

import SpriteKit
import SwiftUI

// MARK: - Texture Cache

/// Singleton cache for reusing generated SpriteKit textures
final class TextureCache {
    static let shared = TextureCache()
    private var cache: [String: SKTexture] = [:]
    private let queue = DispatchQueue(label: "com.sumiforest.texturecache")

    private init() {}

    func texture(forKey key: String, generator: () -> SKTexture) -> SKTexture {
        queue.sync {
            if let existing = cache[key] { return existing }
            let tex = generator()
            cache[key] = tex
            return tex
        }
    }

    func clear() {
        queue.sync { cache.removeAll() }
    }
}

// MARK: - Seeded Random

/// Deterministic random number generator using LCG algorithm
struct SeededRandom {
    private var state: UInt64

    init(seed: Int) {
        state = UInt64(abs(seed) &+ 1)
    }

    mutating func nextDouble() -> Double {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        let value = (state >> 32) ^ state
        return Double(value) / Double(UInt64.max)
    }

    mutating func nextCGFloat(in range: ClosedRange<CGFloat> = 0...1) -> CGFloat {
        let d = nextDouble()
        return range.lowerBound + CGFloat(d) * (range.upperBound - range.lowerBound)
    }
}

// MARK: - TreeNode Base Class

/// Base class for all tree types in the SpriteKit forest scene.
/// Provides shared sumi-e ink painting utilities.
class TreeNode: SKNode {
    let task: TodoTask
    let species: TreeSpecies
    var random: SeededRandom

    /// The ink color for this tree (derived from species/priority)
    var inkColor: UIColor {
        UIColor(species.inkUIColor)
    }

    init(task: TodoTask) {
        self.task = task
        self.species = task.treeSpecies
        self.random = SeededRandom(seed: task.id.hashValue)
        super.init()
        self.name = "tree_\(task.id.uuidString)"
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Paint (override in subclasses)

    /// Paints the tree with stroke-by-stroke animation.
    /// Subclasses must override this.
    func paintTree() {
        // Override in subclasses
    }

    // MARK: - Ink Fade Animation

    /// Animates a node fading in like ink soaking into rice paper.
    func animateInkFade(node: SKNode, duration: TimeInterval = 0.8, delay: TimeInterval = 0) {
        node.alpha = 0
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        fadeIn.timingMode = .easeIn
        let sequence = SKAction.sequence([
            .wait(forDuration: delay),
            fadeIn
        ])
        node.run(sequence)
    }

    // MARK: - Ink Bloom Effect

    /// Adds a radial ink bloom (like wet ink spreading on paper) at a point.
    func addInkBloomEffect(at position: CGPoint, radius: CGFloat = 12, color: UIColor? = nil) {
        let bloomColor = color ?? inkColor
        let bloom = SKShapeNode(circleOfRadius: radius)
        bloom.fillColor = bloomColor.withAlphaComponent(0.15)
        bloom.strokeColor = .clear
        bloom.position = position
        bloom.alpha = 0
        bloom.setScale(0.3)
        addChild(bloom)

        let appear = SKAction.group([
            .fadeAlpha(to: 0.25, duration: 0.4),
            .scale(to: 1.0, duration: 0.6)
        ])
        appear.timingMode = .easeOut
        let fade = SKAction.fadeAlpha(to: 0.08, duration: 1.0)
        bloom.run(.sequence([appear, fade]))
    }

    // MARK: - Tapered Stroke Path

    /// Creates a calligraphic tapered stroke between two points with organic wobble.
    func createTaperedStroke(from start: CGPoint, to end: CGPoint, baseWidth: CGFloat = 3.0) -> SKShapeNode {
        let path = CGMutablePath()
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = hypot(dx, dy)
        guard length > 0 else { return SKShapeNode() }

        let perpX = -dy / length
        let perpY = dx / length

        let steps = max(Int(length / 4), 6)

        // Build outline with pressure taper
        var leftPoints: [CGPoint] = []
        var rightPoints: [CGPoint] = []

        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            // Pressure curve: thin at start, thick in middle, thin at end
            let pressure = sin(t * .pi) * baseWidth
            // Organic wobble
            let wobble = random.nextCGFloat(in: -0.8...0.8)

            let cx = start.x + dx * t + wobble
            let cy = start.y + dy * t + wobble

            leftPoints.append(CGPoint(x: cx + perpX * pressure, y: cy + perpY * pressure))
            rightPoints.append(CGPoint(x: cx - perpX * pressure, y: cy - perpY * pressure))
        }

        // Draw the outline
        path.move(to: leftPoints[0])
        for point in leftPoints.dropFirst() {
            path.addLine(to: point)
        }
        for point in rightPoints.reversed() {
            path.addLine(to: point)
        }
        path.closeSubpath()

        let stroke = SKShapeNode(path: path)
        stroke.fillColor = inkColor
        stroke.strokeColor = inkColor.withAlphaComponent(0.6)
        stroke.lineWidth = 0.5
        return stroke
    }

    // MARK: - Brush Stroke Particles

    /// Creates a small particle burst at a point (like brush touching paper).
    func createBrushStrokeParticles(at position: CGPoint, color: UIColor? = nil) {
        let particleColor = color ?? inkColor
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 30
        emitter.numParticlesToEmit = 8
        emitter.particleLifetime = 0.6
        emitter.particleLifetimeRange = 0.3
        emitter.particleSpeed = 15
        emitter.particleSpeedRange = 10
        emitter.emissionAngleRange = .pi * 2
        emitter.particleAlpha = 0.4
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -0.6
        emitter.particleScale = 0.15
        emitter.particleScaleRange = 0.1
        emitter.particleColor = particleColor
        emitter.particleColorBlendFactor = 1.0
        emitter.position = position

        // Use a tiny circle texture
        let size = CGSize(width: 6, height: 6)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            particleColor.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
        }
        emitter.particleTexture = SKTexture(image: image)

        addChild(emitter)

        // Remove emitter after particles die
        emitter.run(.sequence([
            .wait(forDuration: 1.5),
            .removeFromParent()
        ]))
    }

    // MARK: - Ink Drip

    /// Adds a small gravity-affected ink drip from a point.
    func addInkDrip(at position: CGPoint) {
        let drip = SKShapeNode(ellipseOf: CGSize(width: 2, height: 4))
        drip.fillColor = inkColor.withAlphaComponent(0.3)
        drip.strokeColor = .clear
        drip.position = position
        drip.alpha = 0.5
        addChild(drip)

        let fall = SKAction.moveBy(x: random.nextCGFloat(in: -3...3), y: -random.nextCGFloat(in: 8...20), duration: 1.2)
        fall.timingMode = .easeIn
        let fade = SKAction.fadeOut(withDuration: 0.8)
        drip.run(.sequence([
            .group([fall, fade]),
            .removeFromParent()
        ]))
    }

    // MARK: - Selection Ripple

    /// Shows an expanding ink ripple when the tree is tapped.
    func addSelectionRipple() {
        let ripple = SKShapeNode(circleOfRadius: 5)
        ripple.strokeColor = inkColor.withAlphaComponent(0.5)
        ripple.fillColor = .clear
        ripple.lineWidth = 1.5
        ripple.position = .zero
        addChild(ripple)

        let expand = SKAction.group([
            .scale(to: 8, duration: 0.6),
            .fadeOut(withDuration: 0.6)
        ])
        expand.timingMode = .easeOut
        ripple.run(.sequence([expand, .removeFromParent()]))
    }

    // MARK: - Removal Animation

    /// Removes the tree with an ink dispersion effect.
    func removeWithInkDispersion(completion: (() -> Void)? = nil) {
        // Scatter particles outward
        let particleCount = 12
        for i in 0..<particleCount {
            let angle = CGFloat(i) / CGFloat(particleCount) * .pi * 2
            let dot = SKShapeNode(circleOfRadius: random.nextCGFloat(in: 1.5...3))
            dot.fillColor = inkColor.withAlphaComponent(0.5)
            dot.strokeColor = .clear
            dot.position = .zero
            addChild(dot)

            let distance = random.nextCGFloat(in: 20...50)
            let scatter = SKAction.group([
                .move(by: CGVector(dx: cos(angle) * distance, dy: sin(angle) * distance), duration: 0.6),
                .fadeOut(withDuration: 0.8),
                .scale(to: 0.2, duration: 0.8)
            ])
            scatter.timingMode = .easeOut
            dot.run(.sequence([scatter, .removeFromParent()]))
        }

        // Fade out the tree itself
        let fadeOut = SKAction.group([
            .fadeOut(withDuration: 0.5),
            .scale(to: 0.7, duration: 0.5)
        ])
        fadeOut.timingMode = .easeIn

        run(.sequence([fadeOut, .run { completion?() }, .removeFromParent()]))
    }
}

// MARK: - TreeSpecies SpriteKit Extensions

extension TreeSpecies {
    /// UIColor for SpriteKit rendering
    var inkUIColor: Color {
        switch self {
        case .bamboo: return Theme.Colors.bamboo
        case .maple: return Theme.Colors.maple
        case .pine: return Theme.Colors.pine
        case .sakura: return Theme.Colors.sakura
        }
    }
}
