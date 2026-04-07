//
//  SumiForestApp.swift
//  Sumi Forest
//
//  A minimal to-do list with watercolor forest visualization
//

import SwiftUI
import SwiftData

/// Main app entry point with SwiftData model container
@main
struct SumiForestApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                TodoTask.self,
            ])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
