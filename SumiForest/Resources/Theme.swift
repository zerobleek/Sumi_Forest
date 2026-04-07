//
//  Theme.swift
//  Sumi Forest
//
//  Central source of truth for colors, fonts, and spacing
//

import SwiftUI

/// Central theme configuration for the Sumi Forest aesthetic
enum Theme {
    
    // MARK: - Colors
    
    /// Color palette inspired by Japanese sumi-e and watercolor
    enum Colors {
        // Base colors
        static let paper = Color(hex: "F8F6F1")
        static let paperDark = Color(hex: "0F1220")
        static let ink = Color(hex: "1C1C1C")
        static let inkLight = Color(hex: "4A4A4A")
        
        // Tree species colors
        static let maple = Color(hex: "B55239")
        static let pine = Color(hex: "2F5D50")
        static let sakura = Color(hex: "D88BA7")
        static let bamboo = Color(hex: "6B8E23")
        
        // Semantic colors
        static let accent = maple
        static let success = pine
        static let warning = Color(hex: "E8A735")
        static let error = Color(hex: "C84B31")
        
        // Priority colors
        static let priorityLow = bamboo
        static let priorityMedium = maple
        static let priorityHigh = Color(hex: "D6615A")
        static let priorityCritical = sakura
        
        /// Returns the background color based on color scheme
        static func background(for scheme: ColorScheme) -> Color {
            scheme == .dark ? paperDark : paper
        }
        
        /// Returns the foreground color based on color scheme
        static func foreground(for scheme: ColorScheme) -> Color {
            scheme == .dark ? paper : ink
        }
        
        /// Returns priority color for given level (Int)
        static func priority(_ level: Int) -> Color {
            switch level {
            case 0: return priorityLow
            case 1: return priorityMedium
            case 2: return priorityHigh
            case 3: return priorityCritical
            default: return priorityLow
            }
        }

        /// Returns priority color for Priority enum
        static func priority(_ priority: Priority) -> Color {
            self.priority(priority.rawValue)
        }
    }
    
    // MARK: - Typography
    
    /// Font styles following sumi-e aesthetic
    enum Typography {
        static let title = Font.system(size: 28, weight: .light, design: .serif)
        static let headline = Font.system(size: 20, weight: .regular, design: .serif)
        static let body = Font.system(size: 16, weight: .regular, design: .serif)
        static let caption = Font.system(size: 14, weight: .light, design: .serif)
        static let small = Font.system(size: 12, weight: .light, design: .serif)
    }
    
    // MARK: - Spacing
    
    /// Consistent spacing scale
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Layout
    
    /// Layout constants
    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let maxWidth: CGFloat = 600
        static let rowHeight: CGFloat = 72
    }
    
    // MARK: - Animation
    
    /// Standard animation configurations
    enum Animation {
        static let spring = SwiftUI.Animation.spring(
            response: 0.6,
            dampingFraction: 0.7,
            blendDuration: 0.3
        )
        static let gentle = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (e.g., "FF5733")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
