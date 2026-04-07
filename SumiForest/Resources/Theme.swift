//
//  Theme.swift
//  Sumi Forest
//
//  Central source of truth for the sumi-e aesthetic
//  Light mode (Yang): warm rice paper ground with ink marks
//  Dark mode (Yin): ink wash ground with cream strokes
//

import SwiftUI

/// Central theme configuration for the Sumi Forest aesthetic
enum Theme {

    // MARK: - Colors

    /// Color palette following yin/yang duality:
    /// Light = paper ground + ink marks, Dark = ink ground + cream marks
    enum Colors {

        // -- Base: Light mode (Yang) --
        static let paper = Color(hex: "FAF6EF")            // Warm rice paper
        static let paperTinted = Color(hex: "F0EBE1")      // Card surface
        static let ink = Color(hex: "1A1612")               // Sumi ink (warm brown-black)
        static let inkLight = Color(hex: "5C534A")          // Diluted ink wash
        static let inkFaint = Color(hex: "B5AEA4")          // Very diluted (borders)

        // -- Base: Dark mode (Yin) --
        static let paperDark = Color(hex: "12110E")         // Ink stone black (warm)
        static let paperTintedDark = Color(hex: "1E1B17")   // Card surface (dark)
        static let inkDark = Color(hex: "EDE6D8")           // Aged cream (foreground)
        static let inkLightDark = Color(hex: "A89E90")      // Muted warm gray
        static let inkFaintDark = Color(hex: "3D3830")      // Subtle warm border

        // -- Tree species: Light mode --
        static let maple = Color(hex: "B55239")
        static let pine = Color(hex: "2F5D50")
        static let sakura = Color(hex: "C77D96")
        static let bamboo = Color(hex: "6B8E23")

        // -- Tree species: Dark mode (lifted for contrast) --
        static let mapleDark = Color(hex: "D4795F")
        static let pineDark = Color(hex: "5A9A87")
        static let sakuraDark = Color(hex: "D8A0B5")
        static let bambooDark = Color(hex: "8FB845")

        // -- Semantic --
        static let accent = maple
        static let success = pine
        static let warning = Color(hex: "E8A735")
        static let error = Color(hex: "C84B31")

        // -- Priority --
        static let priorityLow = bamboo
        static let priorityMedium = maple
        static let priorityHigh = Color(hex: "D6615A")
        static let priorityCritical = sakura

        // MARK: Mode-Aware Accessors

        /// Main background
        static func background(for scheme: ColorScheme) -> Color {
            scheme == .dark ? paperDark : paper
        }

        /// Primary foreground / text
        static func foreground(for scheme: ColorScheme) -> Color {
            scheme == .dark ? inkDark : ink
        }

        /// Secondary text (lighter)
        static func secondaryText(for scheme: ColorScheme) -> Color {
            scheme == .dark ? inkLightDark : inkLight
        }

        /// Card / elevated surface
        static func surface(for scheme: ColorScheme) -> Color {
            scheme == .dark ? paperTintedDark : paperTinted
        }

        /// Borders, dividers, faint lines
        static func divider(for scheme: ColorScheme) -> Color {
            scheme == .dark ? inkFaintDark : inkFaint
        }

        /// Species color adapted for current mode
        static func species(_ species: TreeSpecies, for scheme: ColorScheme) -> Color {
            switch species {
            case .bamboo: scheme == .dark ? bambooDark : bamboo
            case .maple:  scheme == .dark ? mapleDark : maple
            case .pine:   scheme == .dark ? pineDark : pine
            case .sakura: scheme == .dark ? sakuraDark : sakura
            }
        }

        /// Priority color by Int
        static func priority(_ level: Int) -> Color {
            switch level {
            case 0: return priorityLow
            case 1: return priorityMedium
            case 2: return priorityHigh
            case 3: return priorityCritical
            default: return priorityLow
            }
        }

        /// Priority color by enum
        static func priority(_ priority: Priority) -> Color {
            self.priority(priority.rawValue)
        }
    }

    // MARK: - Typography

    /// Hiragino Mincho for headings/body (Japanese calligraphy typeface, built into iOS)
    /// System serif for small utility text (better legibility at small sizes)
    enum Typography {
        static let title = Font.custom("HiraginoMincho-W3", size: 26)
        static let headline = Font.custom("HiraginoMincho-W6", size: 19)
        static let body = Font.custom("HiraginoMincho-W3", size: 16)
        static let caption = Font.system(size: 13, weight: .light, design: .serif)
        static let small = Font.system(size: 11, weight: .light, design: .serif)
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

    /// Layout constants — sharp edges like paper, thin borders like ink lines
    enum Layout {
        static let cornerRadius: CGFloat = 4
        static let cornerRadiusLarge: CGFloat = 8
        static let borderWidth: CGFloat = 0.5
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
        static let modeTransition = SwiftUI.Animation.spring(
            response: 0.8,
            dampingFraction: 0.85
        )
    }

    // MARK: - Texture

    /// Constants for paper grain rendering (used by both SwiftUI and SpriteKit)
    enum Texture {
        static let grainAlphaLight: CGFloat = 0.025
        static let grainAlphaDark: CGFloat = 0.04
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
