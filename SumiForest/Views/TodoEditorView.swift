//
//  TodoEditorView.swift
//  Sumi Forest
//
//  Editor sheet for creating and updating todo items
//

import SwiftUI

/// Editor view for creating and modifying todo items
struct TodoEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let item: TodoTask?
    let onCreate: (String, String?, Date?, Priority, [String]) -> Void
    let onUpdate: (TodoTask) -> Void
    
    @State private var title: String
    @State private var note: String
    @State private var dueDate: Date
    @State private var hasDueDate: Bool
    @State private var priority: Priority
    @State private var showValidationError = false
    
    init(
        item: TodoTask?,
        onCreate: @escaping (String, String?, Date?, Int, [String]) -> Void,
        onUpdate: @escaping (TodoTask) -> Void
    ) {
        self.item = item
        self.onCreate = onCreate
        self.onUpdate = onUpdate
        
        // Initialize state from item or defaults
        _title = State(initialValue: item?.title ?? "")
        _note = State(initialValue: item?.note ?? "")
        _dueDate = State(initialValue: item?.dueAt ?? Date())
        _hasDueDate = State(initialValue: item?.dueAt != nil)
        _priority = State(initialValue: item?.priority ?? .low)
    }
    
    private var isEditing: Bool {
        item != nil
    }
    
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Title Section
                Section {
                    TextField("Task title", text: $title, axis: .vertical)
                        .font(Theme.Typography.body)
                        .lineLimit(3)
                } header: {
                    Text("Title")
                        .font(Theme.Typography.caption)
                }
                
                // Note Section
                Section {
                    TextField("Add a note...", text: $note, axis: .vertical)
                        .font(Theme.Typography.body)
                        .lineLimit(5...10)
                } header: {
                    Text("Note")
                        .font(Theme.Typography.caption)
                }
                
                // Due Date Section
                Section {
                    Toggle("Set due date", isOn: $hasDueDate)
                        .font(Theme.Typography.body)
                    
                    if hasDueDate {
                        DatePicker(
                            "Due date",
                            selection: $dueDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .font(Theme.Typography.body)
                    }
                } header: {
                    Text("Due Date")
                        .font(Theme.Typography.caption)
                }
                
                // Priority Section
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { p in
                            HStack {
                                Circle()
                                    .fill(p.color)
                                    .frame(width: 12, height: 12)
                                Text(p.label)
                            }
                            .tag(p)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(Theme.Typography.body)
                } header: {
                    Text("Priority")
                        .font(Theme.Typography.caption)
                } footer: {
                    Text("Priority affects tree species in the forest")
                        .font(Theme.Typography.small)
                        .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.6))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.Colors.background(for: colorScheme))
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Create") {
                        saveTask()
                    }
                    .disabled(!isValid)
                    .foregroundStyle(isValid ? Theme.Colors.accent : Color.gray)
                }
            }
            .alert("Invalid Input", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter a task title")
            }
        }
    }
    
    /// Saves the task (creates or updates)
    private func saveTask() {
        guard isValid else {
            showValidationError = true
            Haptics.warning()
            return
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalNote = trimmedNote.isEmpty ? nil : trimmedNote
        let finalDueDate = hasDueDate ? dueDate : nil
        
        if let existingItem = item {
            // Update existing item
            existingItem.title = trimmedTitle
            existingItem.note = finalNote
            existingItem.dueAt = finalDueDate
            existingItem.priority = priority
            onUpdate(existingItem)
        } else {
            // Create new item
            onCreate(trimmedTitle, finalNote, finalDueDate, priority, [])
        }
        
        dismiss()
    }
}

#Preview("New Task") {
    TodoEditorView(
        item: nil,
        onCreate: { _, _, _, _, _ in },
        onUpdate: { _ in }
    )
}

#Preview("Edit Task") {
    TodoEditorView(
        item: TodoTask(
            title: "Morning meditation",
            note: "10 minutes of calm breathing",
            dueAt: Date(),
            priority: .medium
        ),
        onCreate: { _, _, _, _, _ in },
        onUpdate: { _ in }
    )
}

#Preview("Dark Mode") {
    TodoEditorView(
        item: nil,
        onCreate: { _, _, _, _, _ in },
        onUpdate: { _ in }
    )
    .preferredColorScheme(.dark)
}
