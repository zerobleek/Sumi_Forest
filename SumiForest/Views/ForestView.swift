//
//  ForestView.swift
//  Sumi Forest
//
//  Main forest visualization view
//

import SwiftUI
import SwiftData

/// Main forest view displaying completed tasks as watercolor trees
struct ForestView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    @Query(filter: #Predicate<TodoTask> { $0.isCompleted })
    private var completedTodos: [TodoTask]
    
    @State private var viewModel = ForestViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background (SpriteKit scene handles its own rice paper texture,
                // but we need a base color for the NavigationStack area)
                Theme.Colors.background(for: colorScheme)
                    .ignoresSafeArea()

                if completedTodos.isEmpty {
                    ForestEmptyStateView()
                } else {
                    // SpriteKit calligraphy forest
                    SpriteKitForestView(
                        completedTasks: completedTodos,
                        colorScheme: colorScheme
                    ) { task in
                        // Build TreeData for the detail sheet
                        let treeData = TreeData(from: task, position: .zero)
                        viewModel.selectTree(treeData)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationTitle("Forest")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(completedTodos.count) trees")
                            .font(Theme.Typography.caption)
                        Text("\(viewModel.treesGrownToday(completedTodos)) today")
                            .font(Theme.Typography.small)
                            .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingTreeDetail) {
                if let tree = viewModel.selectedTree {
                    TreeDetailView(tree: tree)
                }
            }
        }
    }
}

// MARK: - Supporting Views

/// Empty state for forest when no tasks completed
struct ForestEmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "leaf")
                .font(.system(size: 72))
                .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.3))
            
            VStack(spacing: Theme.Spacing.sm) {
                Text("Your forest awaits")
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                
                Text("Complete tasks to grow trees")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Theme.Spacing.xl)
    }
}

/// Detail sheet showing information about a tree
struct TreeDetailView: View {
    let tree: TreeData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                // Tree visualization
                HStack {
                    Spacer()
                    TreeView(tree: tree, onTap: {})
                        .frame(width: 120, height: 200)
                    Spacer()
                }
                .padding(.vertical, Theme.Spacing.lg)
                
                // Tree info
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(Theme.Colors.priority(tree.todoItem.priority))
                        Text(tree.species.rawValue)
                            .font(Theme.Typography.headline)
                            .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                    }
                    
                    Rectangle()
                        .fill(Theme.Colors.divider(for: colorScheme))
                        .frame(height: Theme.Layout.borderWidth)
                    
                    // Task details
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Task")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                        
                        Text(tree.todoItem.title)
                            .font(Theme.Typography.body)
                            .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                    }
                    
                    if let note = tree.todoItem.note, !note.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Note")
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                            
                            Text(note)
                                .font(Theme.Typography.body)
                                .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                        }
                    }
                    
                    if let completedAt = tree.todoItem.completedAt {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Completed")
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                            
                            Text(formatDate(completedAt))
                                .font(Theme.Typography.body)
                                .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                        }
                    }
                    
                    // Priority info
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Priority")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.secondaryText(for: colorScheme))
                        
                        HStack {
                            Circle()
                                .fill(Theme.Colors.priority(tree.todoItem.priority))
                                .frame(width: 12, height: 12)
                            
                            Text(priorityLabel(tree.todoItem.priority))
                                .font(Theme.Typography.body)
                                .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                        }
                    }
                }
                .padding(Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                        .fill(Theme.Colors.surface(for: colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                                .stroke(Theme.Colors.divider(for: colorScheme), lineWidth: Theme.Layout.borderWidth)
                        )
                )
                
                Spacer()
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.background(for: colorScheme))
            .navigationTitle("Tree Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func priorityLabel(_ priority: Priority) -> String {
        priority.label
    }
}

#Preview("With Trees") {
    let container = try! ModelContainer(
        for: TodoTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    // Add sample completed tasks
    for i in 0..<10 {
        let item = TodoTask(
            title: "Completed task \(i + 1)",
            priority: Priority(rawValue: i % 4) ?? .low
        )
        item.complete()
        context.insert(item)
    }
    
    return ForestView()
        .modelContainer(container)
}

#Preview("Empty") {
    ForestView()
        .modelContainer(for: TodoTask.self, inMemory: true)
}

#Preview("Dark Mode") {
    let container = try! ModelContainer(
        for: TodoTask.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    for i in 0..<5 {
        let item = TodoTask(title: "Task \(i)", priority: Priority(rawValue: i % 4) ?? .low)
        item.complete()
        context.insert(item)
    }
    
    return ForestView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
