//
//  TodoTask.swift
//  Sumi Forest
//
//  Core data model for to-do items
//

import Foundation
import SwiftUI
import SwiftData

/// Priority levels for tasks, mapped to tree species in the forest
enum Priority: Int, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3

    /// Display label
    var label: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Critical"
        }
    }

    /// Theme color for this priority
    var color: Color {
        Theme.Colors.priority(self)
    }

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Represents a single to-do item with metadata for forest visualization
@Model
class TodoTask {
    var id: UUID
    var title: String
    var note: String?
    var createdAt: Date
    var dueAt: Date?
    var priority: Priority
    var isCompleted: Bool
    var completedAt: Date?
    var tags: [String]

    init(
        id: UUID = UUID(),
        title: String,
        note: String? = nil,
        createdAt: Date = Date(),
        dueAt: Date? = nil,
        priority: Priority = .low,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.createdAt = createdAt
        self.dueAt = dueAt
        self.priority = priority
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.tags = tags
    }

    /// Marks the task as complete
    func complete() {
        isCompleted = true
        completedAt = Date()
    }

    /// Marks the task as incomplete
    func uncomplete() {
        isCompleted = false
        completedAt = nil
    }

    /// Returns the tree species based on priority
    var treeSpecies: TreeSpecies {
        switch priority {
        case .low: return .bamboo
        case .medium: return .maple
        case .high: return .pine
        case .urgent: return .sakura
        }
    }

    /// Calculates tree size based on priority, title length, and age
    var treeSize: CGFloat {
        let baseSizeFromPriority: CGFloat = CGFloat(priority.rawValue + 1) * 20
        let sizeFromTitle = min(CGFloat(title.count) * 2, 40)
        let age = completedAt?.timeIntervalSinceNow ?? 0
        let ageFactor = min(abs(age) / 86400, 5) * 5

        return baseSizeFromPriority + sizeFromTitle + ageFactor
    }
}

/// Tree species for forest visualization
enum TreeSpecies: String, CaseIterable {
    case bamboo = "Bamboo"
    case maple = "Maple"
    case pine = "Pine"
    case sakura = "Sakura"

    var imageName: String {
        "tree_\(rawValue.lowercased())"
    }
}
