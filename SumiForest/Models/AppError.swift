//
//  AppError.swift
//  Sumi Forest
//
//  Centralized error handling for the application
//

import Foundation

/// Application-wide error types with user-friendly messages
enum AppError: LocalizedError, Identifiable, Equatable {
    case persistenceFailed(String)
    case invalidInput(String)
    case resourceMissing(String)
    case operationFailed(String, underlying: Error?)
    
    /// Unique identifier for SwiftUI alerts
    var id: String {
        localizedDescription
    }
    
    /// User-friendly error description
    var errorDescription: String? {
        switch self {
        case .persistenceFailed(let detail):
            return "Failed to save: \(detail)"
        case .invalidInput(let detail):
            return "Invalid input: \(detail)"
        case .resourceMissing(let detail):
            return "Missing resource: \(detail)"
        case .operationFailed(let detail, _):
            return "Operation failed: \(detail)"
        }
    }
    
    /// Detailed recovery suggestion
    var recoverySuggestion: String? {
        switch self {
        case .persistenceFailed:
            return "Please try again. If the problem persists, try restarting the app."
        case .invalidInput:
            return "Please check your input and try again."
        case .resourceMissing:
            return "The app may need to be reinstalled."
        case .operationFailed:
            return "Please try again later."
        }
    }
    
    /// Equatable conformance for AppError
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.id == rhs.id
    }
}

/// Error converter utility
extension AppError {
    /// Converts a generic Error to AppError
    /// - Parameters:
    ///   - error: The error to convert
    ///   - context: Context description
    /// - Returns: An AppError instance
    static func from(_ error: Error, context: String) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        return .operationFailed(context, underlying: error)
    }
}
