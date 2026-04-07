//
//  TreeView.swift
//  Sumi Forest
//
//  Watercolor tree rendering component
//

import SwiftUI

/// Displays a single watercolor tree with growth animation
struct TreeView: View {
    let tree: TreeData
    let onTap: () -> Void
    
    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Use different tree shapes based on species
                treeShape(for: tree.species)
                    .fill(speciesGradient(for: tree.species))
                    .frame(width: 50 * tree.size, height: 80 * tree.size)
                    .rotationEffect(.degrees(tree.rotation))
                    .scaleEffect(scale)
                    .opacity(opacity * tree.opacity)
            }
        }
        .buttonStyle(.plain)
        .position(tree.position)
        .accessibilityLabel("\(tree.species.rawValue) tree from task: \(tree.todoItem.title)")
        .onAppear {
            withAnimation(Theme.Animation.spring.delay(Double.random(in: 0...0.3))) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    /// Returns the shape for a given tree species
    private func treeShape(for species: TreeSpecies) -> AnyShape {
        switch species {
        case .bamboo: AnyShape(BambooShape())
        case .maple: AnyShape(MapleShape())
        case .pine: AnyShape(PineShape())
        case .sakura: AnyShape(SakuraShape())
        }
    }
    
    /// Returns gradient colors for species
    private func speciesGradient(for species: TreeSpecies) -> LinearGradient {
        let colors: [Color] = switch species {
        case .bamboo:
            [Theme.Colors.bamboo, Theme.Colors.bamboo.opacity(0.6)]
        case .maple:
            [Theme.Colors.maple, Theme.Colors.maple.opacity(0.7)]
        case .pine:
            [Theme.Colors.pine, Theme.Colors.pine.opacity(0.7)]
        case .sakura:
            [Theme.Colors.sakura, Theme.Colors.sakura.opacity(0.6)]
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Tree Shapes

/// Bamboo tree shape - tall and narrow
struct BambooShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Trunk
        path.move(to: CGPoint(x: width * 0.45, y: height))
        path.addLine(to: CGPoint(x: width * 0.45, y: height * 0.2))
        path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.2))
        path.addLine(to: CGPoint(x: width * 0.55, y: height))
        path.closeSubpath()
        
        // Leaves - simple triangular sections
        for i in 0..<3 {
            let y = height * (0.2 + CGFloat(i) * 0.15)
            path.move(to: CGPoint(x: width * 0.5, y: y))
            path.addLine(to: CGPoint(x: width * 0.2, y: y + height * 0.1))
            path.addLine(to: CGPoint(x: width * 0.8, y: y + height * 0.1))
            path.closeSubpath()
        }
        
        return path
    }
}

/// Maple tree shape - rounded crown
struct MapleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Trunk
        path.move(to: CGPoint(x: width * 0.45, y: height))
        path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.55, y: height))
        path.closeSubpath()
        
        // Crown - organic rounded shape
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control1: CGPoint(x: width * 0.8, y: height * 0.1),
            control2: CGPoint(x: width * 0.9, y: height * 0.2)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.5),
            control1: CGPoint(x: width * 0.9, y: height * 0.4),
            control2: CGPoint(x: width * 0.7, y: height * 0.45)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.3),
            control1: CGPoint(x: width * 0.3, y: height * 0.45),
            control2: CGPoint(x: width * 0.1, y: height * 0.4)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control1: CGPoint(x: width * 0.1, y: height * 0.2),
            control2: CGPoint(x: width * 0.2, y: height * 0.1)
        )
        path.closeSubpath()
        
        return path
    }
}

/// Pine tree shape - triangular evergreen
struct PineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Trunk
        path.move(to: CGPoint(x: width * 0.45, y: height))
        path.addLine(to: CGPoint(x: width * 0.45, y: height * 0.6))
        path.addLine(to: CGPoint(x: width * 0.55, y: height * 0.6))
        path.addLine(to: CGPoint(x: width * 0.55, y: height))
        path.closeSubpath()
        
        // Crown - layered triangles
        let layers = 3
        for i in 0..<layers {
            let layerHeight = height * 0.6 / CGFloat(layers)
            let y = height * 0.6 - layerHeight * CGFloat(i + 1)
            let widthFactor = 0.3 + CGFloat(i) * 0.15
            
            path.move(to: CGPoint(x: width * 0.5, y: y))
            path.addLine(to: CGPoint(x: width * (0.5 - widthFactor), y: y + layerHeight))
            path.addLine(to: CGPoint(x: width * (0.5 + widthFactor), y: y + layerHeight))
            path.closeSubpath()
        }
        
        return path
    }
}

/// Sakura tree shape - delicate with blossoms
struct SakuraShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Trunk
        path.move(to: CGPoint(x: width * 0.45, y: height))
        path.addLine(to: CGPoint(x: width * 0.42, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.58, y: height * 0.4))
        path.addLine(to: CGPoint(x: width * 0.55, y: height))
        path.closeSubpath()
        
        // Crown - soft, cloud-like shape
        path.move(to: CGPoint(x: width * 0.5, y: 0))
        
        // Create blossom-like crown with multiple curves
        let petalCount = 5
        for i in 0..<petalCount {
            let angle = (CGFloat(i) / CGFloat(petalCount)) * 2 * .pi
            let nextAngle = (CGFloat(i + 1) / CGFloat(petalCount)) * 2 * .pi
            
            let radius: CGFloat = width * 0.4
            let controlRadius: CGFloat = width * 0.5
            
            let x1 = width * 0.5 + cos(angle) * radius
            let y1 = height * 0.2 + sin(angle) * radius * 0.6
            let x2 = width * 0.5 + cos(nextAngle) * radius
            let y2 = height * 0.2 + sin(nextAngle) * radius * 0.6
            
            let midAngle = (angle + nextAngle) / 2
            let cx = width * 0.5 + cos(midAngle) * controlRadius
            let cy = height * 0.2 + sin(midAngle) * controlRadius * 0.6
            
            if i == 0 {
                path.move(to: CGPoint(x: x1, y: y1))
            }
            
            path.addQuadCurve(
                to: CGPoint(x: x2, y: y2),
                control: CGPoint(x: cx, y: cy)
            )
        }
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ZStack {
        Theme.Colors.paper
            .ignoresSafeArea()
        
        VStack(spacing: 40) {
            HStack(spacing: 40) {
                TreeView(
                    tree: TreeData(
                        from: TodoTask(title: "Task", priority: .low),
                        position: .zero
                    ),
                    onTap: {}
                )
                
                TreeView(
                    tree: TreeData(
                        from: TodoTask(title: "Task", priority: .medium),
                        position: .zero
                    ),
                    onTap: {}
                )
            }
            
            HStack(spacing: 40) {
                TreeView(
                    tree: TreeData(
                        from: TodoTask(title: "Task", priority: .high),
                        position: .zero
                    ),
                    onTap: {}
                )
                
                TreeView(
                    tree: TreeData(
                        from: TodoTask(title: "Task", priority: .urgent),
                        position: .zero
                    ),
                    onTap: {}
                )
            }
        }
    }
}
