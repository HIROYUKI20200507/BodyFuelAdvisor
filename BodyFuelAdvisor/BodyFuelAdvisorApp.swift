//
//  BodyFuelAdvisorApp.swift
//  BodyFuelAdvisor
//
//  Created by 秋本 裕之 on 2023/04/07.
//

import SwiftUI

@main
struct BodyFuelAdvisorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
