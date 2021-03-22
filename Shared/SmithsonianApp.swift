//
//  SmithsonianApp.swift
//  Shared
//
//  Created by Ken Torimaru on 3/22/21.
//

import SwiftUI

@main
struct SmithsonianApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
