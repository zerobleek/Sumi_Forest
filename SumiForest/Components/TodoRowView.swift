//
//  TodoRowView.swift
//  Sumi Forest
//
//  Individual todo row with swipe actions
//

import SwiftUI

/// Displays a single todo item with completion checkbox and swipe actions
struct TodoRowView: View {
    let item: TodoTask
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Completion checkbox
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(
                            item.isCompleted
                            ? Theme.Colors.success
                            : Theme.Colors.foreground(for: colorScheme).opacity(0.3),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Theme.Colors.success)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(Theme.Animation.spring, value: item.isCompleted)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                item.isCompleted ? "Mark as incomplete" : "Mark as complete"
            )
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                // Title
                Text(item.title)
                    .font(Theme.Typography.body)
                    .foregroundStyle(
                        item.isCompleted
                        ? Theme.Colors.foreground(for: colorScheme).opacity(0.5)
                        : Theme.Colors.foreground(for: colorScheme)
                    )
                    .strikethrough(item.isCompleted)
                
                // Note
                if let note = item.note, !note.isEmpty {
                    Text(note)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.foreground(for: colorScheme).opacity(0.6))
                        .lineLimit(2)
                }
                
                HStack(spacing: Theme.Spacing.sm) {
                    // Due date
                    if let dueAt = item.dueAt {
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text(formatDate(dueAt))
                        }
                        .font(Theme.Typography.small)
                        .foregroundStyle(
                            isOverdue(dueAt) && !item.isCompleted
                            ? Theme.Colors.error
                            : Theme.Colors.foreground(for: colorScheme).opacity(0.5)
                        )
                    }
                    
                    // Priority indicator
                    if item.priority != .low {
                        Circle()
                            .fill(item.priority.color)
                            .frame(width: 8, height: 8)
                            .accessibilityLabel("Priority \(item.priority.label)")
                    }
                }
            }
            
            Spacer()
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                .fill(colorScheme == .dark ? Theme.Colors.inkLight.opacity(0.2) : Color.white)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
            
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(Theme.Colors.accent)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: onToggle) {
                Label(
                    item.isCompleted ? "Incomplete" : "Complete",
                    systemImage: item.isCompleted ? "arrow.uturn.backward" : "checkmark"
                )
            }
            .tint(Theme.Colors.success)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title). \(item.isCompleted ? "Completed" : "Not completed")")
    }
    
    /// Formats a date for display
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
    
    /// Checks if a date is overdue
    private func isOverdue(_ date: Date) -> Bool {
        date < Date()
    }
}

#Preview {
    VStack(spacing: Theme.Spacing.md) {
        TodoRowView(
            item: TodoTask(title: "Morning meditation", note: "10 minutes of calm", priority: .medium),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
        
        TodoRowView(
            item: {
                let item = TodoTask(title: "Completed task", priority: .high)
                item.complete()
                return item
            }(),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
        
        TodoRowView(
            item: TodoTask(
                title: "Overdue task",
                dueAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                priority: .urgent
            ),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Theme.Colors.paper)
}
