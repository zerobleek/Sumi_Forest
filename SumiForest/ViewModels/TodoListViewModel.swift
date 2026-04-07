//
//  TodoListViewModel.swift
//  Sumi Forest
//
//  View model for todo list operations
//

import Foundation
import SwiftUI
import SwiftData

/// Filter options for todo list
enum TodoFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case upcoming = "Upcoming"
    case completed = "Completed"

    /// Predicate for filtering todos
    func predicate() -> Predicate<TodoTask>? {
        switch self {
        case .all:
            return nil
        case .today:
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            return #Predicate<TodoTask> { item in
                item.isCompleted == false
            }
        case .upcoming:
            return #Predicate<TodoTask> { item in
                item.isCompleted == false
            }
        case .completed:
            return #Predicate<TodoTask> { item in
                item.isCompleted == true
            }
        }
    }
}

/// Sort options for todo list
enum TodoSort: String, CaseIterable {
    case created = "Created"
    case due = "Due Date"
    case priority = "Priority"
}

/// View model managing todo list state and operations
@Observable
final class TodoListViewModel {
    // MARK: - Published Properties

    var appError: AppError?
    var selectedFilter: TodoFilter = .all
    var selectedSort: TodoSort = .created
    var quickAddText: String = ""
    var showingEditor: Bool = false
    var editingTask: TodoTask?

    // MARK: - Private Properties

    private var modelContext: ModelContext?

    // MARK: - Initialization

    init() {}

    /// Sets the model context for persistence operations
    func setContext(_ context: ModelContext) {
        self.modelContext = context
        AppLogger.todo.info("TodoListViewModel context set")
    }

    // MARK: - CRUD Operations

    /// Creates a new todo task
    func createTodo(
        title: String,
        note: String? = nil,
        dueAt: Date? = nil,
        priority: Priority = .low,
        tags: [String] = []
    ) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            appError = .invalidInput("Title cannot be empty")
            Haptics.warning()
            return
        }

        guard let context = modelContext else {
            appError = .persistenceFailed("Model context not available")
            return
        }

        let task = TodoTask(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note,
            dueAt: dueAt,
            priority: priority,
            tags: tags
        )

        context.insert(task)

        do {
            try context.save()
            AppLogger.todo.info("Created todo: \(title)")
            Haptics.light()
        } catch {
            appError = .from(error, context: "Failed to create todo")
            AppLogger.todo.error("Failed to create todo: \(error.localizedDescription)")
        }
    }

    /// Updates an existing todo task
    func updateTodo(_ task: TodoTask) {
        guard let context = modelContext else {
            appError = .persistenceFailed("Model context not available")
            return
        }

        do {
            try context.save()
            AppLogger.todo.info("Updated todo: \(task.title)")
            Haptics.light()
        } catch {
            appError = .from(error, context: "Failed to update todo")
            AppLogger.todo.error("Failed to update todo: \(error.localizedDescription)")
        }
    }

    /// Deletes a todo task
    func deleteTodo(_ task: TodoTask) {
        guard let context = modelContext else {
            appError = .persistenceFailed("Model context not available")
            return
        }

        context.delete(task)

        do {
            try context.save()
            AppLogger.todo.info("Deleted todo: \(task.title)")
            Haptics.light()
        } catch {
            appError = .from(error, context: "Failed to delete todo")
            AppLogger.todo.error("Failed to delete todo: \(error.localizedDescription)")
        }
    }

    /// Toggles completion status of a todo task
    func toggleCompletion(_ task: TodoTask) {
        if task.isCompleted {
            task.uncomplete()
        } else {
            task.complete()
            Haptics.success()
        }

        updateTodo(task)
    }

    /// Creates a todo from quick add text field
    func createFromQuickAdd() {
        guard !quickAddText.isEmpty else { return }

        createTodo(title: quickAddText)
        quickAddText = ""
    }

    /// Prepares to edit a task
    func editTask(_ task: TodoTask) {
        editingTask = task
        showingEditor = true
    }

    /// Clears the editing state
    func clearEditor() {
        editingTask = nil
        showingEditor = false
    }

    // MARK: - Sorting

    /// Returns a sort descriptor based on current sort selection
    var sortDescriptors: [SortDescriptor<TodoTask>] {
        switch selectedSort {
        case .created:
            return [SortDescriptor(\TodoTask.createdAt, order: .reverse)]
        case .due:
            return [SortDescriptor(\TodoTask.dueAt, order: .forward)]
        case .priority:
            return [SortDescriptor(\TodoTask.priority, order: .reverse)]
        }
    }
}
