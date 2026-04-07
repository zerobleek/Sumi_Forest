//
//  TreeNodes_Implementation.swift
//  Sumi Forest
//
//  Concrete tree species implementations with sumi-e ink painting animations
//

import SpriteKit
import SwiftUI

// MARK: - BambooNode

/// Bamboo tree: tall segmented trunk with radiating leaf strokes.
/// Paints segments bottom-to-top with sequential delays.
final class BambooNode: TreeNode {

    override func paintTree() {
        let segmentCount = 5
        let segmentHeight: CGFloat = 18
        let trunkWidth: CGFloat = 3.0
        let totalHeight = CGFloat(segmentCount) * segmentHeight

        // Paint trunk segments bottom to top
        for i in 0..<segmentCount {
            let delay = Double(i) * 0.15
            let bottomY = -totalHeight / 2 + CGFloat(i) * segmentHeight
            let topY = bottomY + segmentHeight * 0.85

            let segment = createTaperedStroke(
                from: CGPoint(x: 0, y: bottomY),
                to: CGPoint(x: random.nextCGFloat(in: -1...1), y: topY),
                baseWidth: trunkWidth
            )
            addChild(segment)
            animateInkFade(node: segment, duration: 0.5, delay: delay)

            // Node joint — small bloom
            if i > 0 {
                let jointAction = SKAction.sequence([
                    .wait(forDuration: delay + 0.2),
                    .run { [weak self] in
                        self?.addInkBloomEffect(
                            at: CGPoint(x: 0, y: bottomY),
                            radius: 4
                        )
                    }
                ])
                run(jointAction)
            }

            // Leaf strokes at alternating sides
            if i >= 2 {
                let leafDelay = delay + 0.3
                let side: CGFloat = (i % 2 == 0) ? 1 : -1
                let leafStart = CGPoint(x: 0, y: bottomY + segmentHeight * 0.5)
                let leafEnd = CGPoint(
                    x: side * random.nextCGFloat(in: 15...25),
                    y: bottomY + segmentHeight * 0.5 + random.nextCGFloat(in: -5...5)
                )

                let leaf = createTaperedStroke(from: leafStart, to: leafEnd, baseWidth: 1.8)
                addChild(leaf)
                animateInkFade(node: leaf, duration: 0.4, delay: leafDelay)
            }
        }

        // Brush contact particles at base
        run(.sequence([
            .wait(forDuration: 0.1),
            .run { [weak self] in
                self?.createBrushStrokeParticles(at: CGPoint(x: 0, y: -totalHeight / 2))
            }
        ]))
    }
}

// MARK: - MapleNode

/// Maple tree: trunk stroke with layered crown circles and ink bloom.
final class MapleNode: TreeNode {

    override func paintTree() {
        let trunkHeight: CGFloat = 35
        let crownRadius: CGFloat = 22

        // Paint trunk
        let trunk = createTaperedStroke(
            from: CGPoint(x: 0, y: -trunkHeight / 2),
            to: CGPoint(x: random.nextCGFloat(in: -2...2), y: trunkHeight * 0.2),
            baseWidth: 3.5
        )
        addChild(trunk)
        animateInkFade(node: trunk, duration: 0.6)

        // Brush particles at trunk base
        run(.sequence([
            .wait(forDuration: 0.1),
            .run { [weak self] in
                self?.createBrushStrokeParticles(at: CGPoint(x: 0, y: -trunkHeight / 2))
            }
        ]))

        // Crown — 3 overlapping ink circles
        let crownCenter = CGPoint(x: 0, y: trunkHeight * 0.35)
        let crownOffsets: [(CGFloat, CGFloat, CGFloat)] = [
            (-8, 5, crownRadius * 0.9),
            (6, -3, crownRadius),
            (-2, 10, crownRadius * 0.8)
        ]

        for (i, offset) in crownOffsets.enumerated() {
            let delay = 0.5 + Double(i) * 0.2
            let pos = CGPoint(x: crownCenter.x + offset.0, y: crownCenter.y + offset.1)
            let circle = SKShapeNode(circleOfRadius: offset.2)
            circle.fillColor = inkColor.withAlphaComponent(0.2)
            circle.strokeColor = inkColor.withAlphaComponent(0.4)
            circle.lineWidth = 1.0
            circle.position = pos
            addChild(circle)
            animateInkFade(node: circle, duration: 0.5, delay: delay)

            // Bloom at each circle center
            run(.sequence([
                .wait(forDuration: delay + 0.1),
                .run { [weak self] in
                    self?.addInkBloomEffect(at: pos, radius: offset.2 * 0.6)
                }
            ]))
        }

        // Occasional drip
        run(.sequence([
            .wait(forDuration: 1.2),
            .run { [weak self] in
                guard let self = self else { return }
                if self.random.nextDouble() > 0.5 {
                    self.addInkDrip(at: CGPoint(x: self.random.nextCGFloat(in: -10...10), y: crownCenter.y - crownRadius))
                }
            }
        ]))
    }
}

// MARK: - PineNode

/// Pine tree: trunk with 3 triangular branch layers painted sequentially.
final class PineNode: TreeNode {

    override func paintTree() {
        let trunkHeight: CGFloat = 20
        let layerCount = 3
        let baseWidth: CGFloat = 28

        // Paint trunk
        let trunk = createTaperedStroke(
            from: CGPoint(x: 0, y: -trunkHeight),
            to: CGPoint(x: 0, y: 0),
            baseWidth: 3.0
        )
        addChild(trunk)
        animateInkFade(node: trunk, duration: 0.5)

        // Brush particles at base
        run(.sequence([
            .wait(forDuration: 0.1),
            .run { [weak self] in
                self?.createBrushStrokeParticles(at: CGPoint(x: 0, y: -trunkHeight))
            }
        ]))

        // Paint triangular layers bottom to top
        for i in 0..<layerCount {
            let delay = 0.4 + Double(i) * 0.25
            let layerY = CGFloat(i) * 15
            let width = baseWidth - CGFloat(i) * 6
            let height: CGFloat = 18

            let tipY = layerY + height
            let leftBottom = CGPoint(x: -width / 2, y: layerY)
            let rightBottom = CGPoint(x: width / 2, y: layerY)
            let tip = CGPoint(x: random.nextCGFloat(in: -2...2), y: tipY)

            // Left edge stroke
            let leftStroke = createTaperedStroke(from: leftBottom, to: tip, baseWidth: 2.0)
            addChild(leftStroke)
            animateInkFade(node: leftStroke, duration: 0.4, delay: delay)

            // Right edge stroke
            let rightStroke = createTaperedStroke(from: rightBottom, to: tip, baseWidth: 2.0)
            addChild(rightStroke)
            animateInkFade(node: rightStroke, duration: 0.4, delay: delay + 0.1)

            // Bottom edge stroke
            let bottomStroke = createTaperedStroke(from: leftBottom, to: rightBottom, baseWidth: 1.5)
            addChild(bottomStroke)
            animateInkFade(node: bottomStroke, duration: 0.3, delay: delay + 0.05)

            // Fill with subtle wash
            let fillPath = CGMutablePath()
            fillPath.move(to: leftBottom)
            fillPath.addLine(to: rightBottom)
            fillPath.addLine(to: tip)
            fillPath.closeSubpath()

            let fill = SKShapeNode(path: fillPath)
            fill.fillColor = inkColor.withAlphaComponent(0.08)
            fill.strokeColor = .clear
            addChild(fill)
            animateInkFade(node: fill, duration: 0.5, delay: delay + 0.15)
        }
    }
}

// MARK: - SakuraNode

/// Sakura tree: flowing branch strokes with floating pink blossom particles.
final class SakuraNode: TreeNode {

    override func paintTree() {
        let trunkHeight: CGFloat = 30

        // Paint trunk with slight curve
        let trunk = createTaperedStroke(
            from: CGPoint(x: 0, y: -trunkHeight / 2),
            to: CGPoint(x: random.nextCGFloat(in: -3...3), y: trunkHeight * 0.3),
            baseWidth: 3.0
        )
        addChild(trunk)
        animateInkFade(node: trunk, duration: 0.6)

        // Brush particles at base
        run(.sequence([
            .wait(forDuration: 0.1),
            .run { [weak self] in
                self?.createBrushStrokeParticles(at: CGPoint(x: 0, y: -trunkHeight / 2))
            }
        ]))

        // Paint branches with bezier-like strokes
        let branchConfigs: [(start: CGPoint, end: CGPoint, delay: Double)] = [
            (CGPoint(x: 0, y: 5), CGPoint(x: -22, y: 20), 0.5),
            (CGPoint(x: 0, y: 5), CGPoint(x: 20, y: 18), 0.7),
            (CGPoint(x: 0, y: 8), CGPoint(x: -12, y: 30), 0.9),
            (CGPoint(x: 0, y: 8), CGPoint(x: 15, y: 28), 1.1),
            (CGPoint(x: 0, y: 12), CGPoint(x: random.nextCGFloat(in: -5...5), y: 35), 1.3)
        ]

        for config in branchConfigs {
            let branch = createTaperedStroke(
                from: config.start,
                to: config.end,
                baseWidth: 2.0
            )
            addChild(branch)
            animateInkFade(node: branch, duration: 0.4, delay: config.delay)

            // Small bloom at branch tip
            run(.sequence([
                .wait(forDuration: config.delay + 0.3),
                .run { [weak self] in
                    self?.addInkBloomEffect(at: config.end, radius: 6, color: UIColor(Theme.Colors.sakura.opacity(0.4)))
                }
            ]))
        }

        // Floating petal particle system
        run(.sequence([
            .wait(forDuration: 1.5),
            .run { [weak self] in
                self?.addBlossomParticles()
            }
        ]))
    }

    /// Adds a persistent floating cherry blossom particle emitter.
    private func addBlossomParticles() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 1.5
        emitter.particleLifetime = 4.0
        emitter.particleLifetimeRange = 2.0
        emitter.particleSpeed = 8
        emitter.particleSpeedRange = 5
        emitter.emissionAngle = -.pi / 2 // Downward
        emitter.emissionAngleRange = .pi / 3
        emitter.particleAlpha = 0.5
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -0.1
        emitter.particleScale = 0.2
        emitter.particleScaleRange = 0.1
        emitter.particleScaleSpeed = -0.02
        emitter.particleColor = UIColor(Theme.Colors.sakura)
        emitter.particleColorBlendFactor = 1.0
        emitter.particleRotation = 0
        emitter.particleRotationRange = .pi
        emitter.particleRotationSpeed = 0.5
        emitter.position = CGPoint(x: 0, y: 25)
        emitter.particlePositionRange = CGVector(dx: 30, dy: 15)
        emitter.xAcceleration = 3 // Gentle wind drift
        emitter.yAcceleration = -2

        // Small petal texture
        let size = CGSize(width: 8, height: 6)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            UIColor(Theme.Colors.sakura).setFill()
            let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            path.fill()
        }
        emitter.particleTexture = SKTexture(image: image)
        emitter.name = "blossomEmitter"

        addChild(emitter)
    }
}
