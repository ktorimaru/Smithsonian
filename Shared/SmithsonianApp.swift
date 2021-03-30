//
//  SmithsonianApp.swift
//  Shared
//
//  Created by Ken Torimaru on 3/22/21.
//

import SwiftUI

@main
struct SmithsonianApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: ModelManager())
        }
    }
}
