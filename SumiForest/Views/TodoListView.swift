//
//  TodoListView.swift
//  Sumi Forest
//
//  Main todo list interface
//

import SwiftUI
import SwiftData

/// Main todo list view with CRUD operations and filtering
struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var viewModel = TodoListViewModel()
    
    @Query private var allTodos: [TodoTask]
    
    private var filteredTodos: [TodoTask] {
        let filtered: [TodoTask]
        
        if let predicate = viewModel.selectedFilter.predicate() {
            filtered = allTodos.filter { item in
                evaluatePredicate(predicate, for: item)
            }
        } else {
            filtered = allTodos
        }
        
        return filtered.sorted { lhs, rhs in
            switch viewModel.selectedSort {
            case .created:
                return lhs.createdAt > rhs.createdAt
            case .due:
                let lhsDate = lhs.dueAt ?? Date.distantFuture
                let rhsDate = rhs.dueAt ?? Date.distantFuture
                return lhsDate < rhsDate
            case .priority:
                return lhs.priority > rhs.priority
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Quick Add Field
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Theme.Colors.accent)
                            .font(.title3)
                        
                        TextField("Write one brushstroke...", text: $viewModel.quickAddText)
                            .font(Theme.Typography.body)
                            .foregroundStyle(Theme.Colors.foreground(for: colorScheme))
                            .submitLabel(.done)
                            .onSubmit {
                                viewModel.createFromQuickAdd()
                            }
                    }
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                            .fill(colorScheme == .dark ? Theme.Colors.inkLight.opacity(0.2) : Color.white)
                    )
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.top, Theme.Spacing.sm)
                    
                    // Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(TodoFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.rawValue,
                                    isSelected: viewModel.selectedFilter == filter
                                ) {
                                    withAnimation(Theme.Animation.quick) {
                                        viewModel.selectedFilter = filter
                                    }
                                    Haptics.selection()
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                    .padding(.vertical, Theme.Spacing.sm)
                    
                    // Sort Toggle
                    HStack {
                        Text("Sort by:")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.6))
                        
                        Picker("Sort", selection: $viewModel.selectedSort) {
                            ForEach(TodoSort.allCases, id: \.self) { sort in
                                Text(sort.rawValue).tag(sort)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.sm)
                    
                    // Todo List
                    if filteredTodos.isEmpty {
                        EmptyStateView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: Theme.Spacing.sm) {
                                ForEach(filteredTodos) { item in
                                    TodoRowView(item: item) {
                                        viewModel.toggleCompletion(item)
                                    } onEdit: {
                                        viewModel.editTask(item)
                                    } onDelete: {
                                        viewModel.deleteTodo(item)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.bottom, Theme.Spacing.xl)
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Theme.Colors.accent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingEditor) {
                TodoEditorView(
                    item: viewModel.editingTask,
                    onCreate: { title, note, dueAt, priority, tags in
                        viewModel.createTodo(
                            title: title,
                            note: note,
                            dueAt: dueAt,
                            priority: priority,
                            tags: tags
                        )
                    },
                    onUpdate: { item in
                        viewModel.updateTodo(item)
                    }
                )
            }
            .alert(item: $viewModel.appError) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            viewModel.setContext(modelContext)
        }
    }
    
    /// Helper to evaluate predicates manually for filtering
    private func evaluatePredicate(_ predicate: Predicate<TodoTask>, for item: TodoTask) -> Bool {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? now
        
        switch viewModel.selectedFilter {
        case .all:
            return true
        case .today:
            guard let dueAt = item.dueAt else { return false }
            return !item.isCompleted && dueAt >= startOfDay && dueAt < endOfDay
        case .upcoming:
            guard let dueAt = item.dueAt else { return false }
            return !item.isCompleted && dueAt >= endOfDay
        case .completed:
            return item.isCompleted
        }
    }
}

// MARK: - Supporting Views

/// Empty state view when no todos match filter
struct EmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "leaf")
                .font(.system(size: 64))
                .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.3))
            
            Text("Write one brushstroke at a time")
                .font(Theme.Typography.headline)
                .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Theme.Spacing.xl)
    }
}

/// Filter chip component
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundStyle(
                    isSelected
                    ? Color.white
                    : Theme.Colors.foreground(for: colorScheme)
                )
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                        .fill(
                            isSelected
                            ? Theme.Colors.accent
                            : (colorScheme == .dark ? Theme.Colors.inkLight.opacity(0.2) : Color.white)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview("With Todos") {
    let container = try! ModelContainer(for: TodoTask.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    // Add sample data
    let item1 = TodoTask(title: "Morning meditation", priority: .medium)
    let item2 = TodoTask(title: "Write in journal", priority: .low)
    let item3 = TodoTask(title: "Plan the day", priority: .high)
    
    context.insert(item1)
    context.insert(item2)
    context.insert(item3)
    
    return TodoListView()
        .modelContainer(container)
}

#Preview("Empty") {
    TodoListView()
        .modelContainer(for: TodoTask.self, inMemory: true)
}

#Preview("Dark Mode") {
    TodoListView()
        .modelContainer(for: TodoTask.self, inMemory: true)
        .preferredColorScheme(.dark)
}
