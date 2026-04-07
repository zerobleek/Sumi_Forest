//
//  ContentView.swift
//  Sumi Forest
//
//  Main app view with tab interface and yin/yang mode transition
//

import SwiftUI

/// Main content view with tabbed interface for todo list and forest
struct ContentView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodoListView()
                .tabItem {
                    Label("Today", systemImage: "list.bullet")
                }
                .tag(0)

            ForestView()
                .tabItem {
                    Label("Forest", systemImage: "leaf.fill")
                }
                .tag(1)
        }
        .tint(Theme.Colors.accent)
        .preferredColorScheme(themeManager.currentScheme)
        .inkRevealTransition(themeManager)
        .overlay(alignment: .topTrailing) {
            yinYangToggle
        }
    }

    // MARK: - Yin/Yang Toggle

    private var yinYangToggle: some View {
        Button {
            // Use button center as the transition origin
            themeManager.toggle(from: CGPoint(x: UIScreen.main.bounds.width - 36, y: 60))
        } label: {
            Image(systemName: themeManager.toggleSymbol)
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(Theme.Colors.foreground(for: themeManager.currentScheme))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Theme.Colors.surface(for: themeManager.currentScheme))
                        .overlay(
                            Circle()
                                .stroke(Theme.Colors.divider(for: themeManager.currentScheme), lineWidth: Theme.Layout.borderWidth)
                        )
                )
        }
        .padding(.trailing, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.xs)
    }
}

#Preview("Light Mode") {
    ContentView()
        .environment(ThemeManager())
        .modelContainer(for: TodoTask.self, inMemory: true)
}

#Preview("Dark Mode") {
    let tm = ThemeManager()
    tm.currentScheme = .dark
    return ContentView()
        .environment(tm)
        .modelContainer(for: TodoTask.self, inMemory: true)
}
