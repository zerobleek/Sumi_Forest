//
//  ForestViewModel.swift
//  Sumi Forest
//
//  View model for forest visualization
//

import Foundation
import SwiftUI

/// Represents a tree in the forest with position and visual properties
struct TreeData: Identifiable {
    let id: UUID
    let species: TreeSpecies
    let position: CGPoint
    let size: CGFloat
    let rotation: Double
    let opacity: Double
    let todoItem: TodoTask
    
    init(from item: TodoTask, position: CGPoint) {
        self.id = item.id
        self.species = item.treeSpecies
        self.todoItem = item
        
        // Calculate size based on priority and title length
        let baseSizeMultiplier: CGFloat = switch item.priority {
        case .low: 0.7
        case .medium: 1.0
        case .high: 1.3
        case .urgent: 1.6
        }
        
        let titleFactor = min(CGFloat(item.title.count) / 50.0, 0.5)
        self.size = (0.8 + titleFactor) * baseSizeMultiplier
        
        self.position = position
        self.rotation = Double.random(in: -15...15)
        
        // Fade older trees slightly
        let daysSinceCompletion = item.completedAt?.timeIntervalSinceNow ?? 0
        let ageFactor = max(0.5, 1.0 + (daysSinceCompletion / (86400 * 30))) // Fade over 30 days
        self.opacity = ageFactor
    }
}

/// View model managing forest state and tree layout
@Observable
final class ForestViewModel {
    // MARK: - Published Properties
    
    var appError: AppError?
    var selectedTree: TreeData?
    var showingTreeDetail = false
    var trees: [TreeData] = []
    
    // MARK: - Private Properties
    
    private var layoutEngine: ForestLayoutEngine
    
    // MARK: - Initialization
    
    init() {
        self.layoutEngine = ForestLayoutEngine()
    }
    
    // MARK: - Public Methods
    
    /// Updates forest with completed todos
    /// - Parameters:
    ///   - completedTodos: Array of completed todo items
    ///   - bounds: Available bounds for tree placement
    func updateForest(completedTodos: [TodoTask], bounds: CGSize) {
        AppLogger.forest.info("Updating forest with \(completedTodos.count) trees")
        
        // Generate positions using layout engine
        let positions = layoutEngine.generatePositions(
            count: completedTodos.count,
            bounds: bounds
        )
        
        // Create tree data from completed todos
        trees = zip(completedTodos, positions).map { item, position in
            TreeData(from: item, position: position)
        }
        
        AppLogger.forest.info("Generated \(trees.count) trees")
    }
    
    /// Selects a tree for detail view
    /// - Parameter tree: The tree to select
    func selectTree(_ tree: TreeData) {
        selectedTree = tree
        showingTreeDetail = true
        Haptics.selection()
    }
    
    /// Clears tree selection
    func clearSelection() {
        selectedTree = nil
        showingTreeDetail = false
    }
    
    /// Returns count of trees grown today
    /// - Parameter todos: All completed todos
    /// - Returns: Count of trees completed today
    func treesGrownToday(_ todos: [TodoTask]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return todos.filter { item in
            guard let completedAt = item.completedAt else { return false }
            return calendar.isDate(completedAt, inSameDayAs: today)
        }.count
    }
}

/// Engine for generating tree positions using Poisson-disk sampling
final class ForestLayoutEngine {
    private let minDistance: CGFloat = 60.0
    private let maxAttempts = 30
    
    /// Generates positions for trees using blue noise distribution
    /// - Parameters:
    ///   - count: Number of positions to generate
    ///   - bounds: Available bounds
    /// - Returns: Array of positions
    func generatePositions(count: Int, bounds: CGSize) -> [CGPoint] {
        guard count > 0 else { return [] }
        
        var points: [CGPoint] = []
        var activeList: [CGPoint] = []
        
        // Add first point
        let firstPoint = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: 0...bounds.height)
        )
        points.append(firstPoint)
        activeList.append(firstPoint)
        
        // Generate remaining points
        while !activeList.isEmpty && points.count < count {
            let randomIndex = Int.random(in: 0..<activeList.count)
            let point = activeList[randomIndex]
            var found = false
            
            for _ in 0..<maxAttempts {
                let angle = Double.random(in: 0...(2 * .pi))
                let radius = CGFloat.random(in: minDistance...(2 * minDistance))
                
                let newPoint = CGPoint(
                    x: point.x + cos(angle) * radius,
                    y: point.y + sin(angle) * radius
                )
                
                if isValid(newPoint, in: bounds, existingPoints: points) {
                    points.append(newPoint)
                    activeList.append(newPoint)
                    found = true
                    break
                }
            }
            
            if !found {
                activeList.remove(at: randomIndex)
            }
        }
        
        // If we didn't generate enough points, fill with random positions
        while points.count < count {
            let randomPoint = CGPoint(
                x: CGFloat.random(in: 0...bounds.width),
                y: CGFloat.random(in: 0...bounds.height)
            )
            points.append(randomPoint)
        }
        
        return points
    }
    
    /// Checks if a point is valid (within bounds and not too close to others)
    private func isValid(_ point: CGPoint, in bounds: CGSize, existingPoints: [CGPoint]) -> Bool {
        guard point.x >= 0 && point.x <= bounds.width &&
              point.y >= 0 && point.y <= bounds.height else {
            return false
        }
        
        for existingPoint in existingPoints {
            let distance = hypot(point.x - existingPoint.x, point.y - existingPoint.y)
            if distance < minDistance {
                return false
            }
        }
        
        return true
    }
}
