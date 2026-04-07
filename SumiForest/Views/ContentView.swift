//
//  ContentView.swift
//  Sumi Forest
//
//  Main app view with tab interface
//

import SwiftUI

/// Main content view with tabbed interface for todo list and forest
struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
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
        .background(Theme.Colors.background(for: colorScheme))
    }
}

#Preview("Light Mode") {
    ContentView()
        .modelContainer(for: TodoTask.self, inMemory: true)
}

#Preview("Dark Mode") {
    ContentView()
        .modelContainer(for: TodoTask.self, inMemory: true)
        .preferredColorScheme(.dark)
}
