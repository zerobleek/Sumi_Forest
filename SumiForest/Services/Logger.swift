//
//  Logger.swift
//  Sumi Forest
//
//  Centralized logging using os.Logger
//

import Foundation
import OSLog

/// Centralized logging service with categorized loggers
enum AppLogger {
    /// Logger for todo operations
    static let todo = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SumiForest", category: "todo")
    
    /// Logger for forest view operations
    static let forest = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SumiForest", category: "forest")
    
    /// Logger for persistence operations
    static let persistence = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SumiForest", category: "persistence")
    
    /// Logger for UI events
    static let ui = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SumiForest", category: "ui")
}
