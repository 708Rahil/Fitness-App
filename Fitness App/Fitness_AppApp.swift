//
//  Fitness_AppApp.swift
//  Fitness App
//

import SwiftUI

@main
struct Fitness_AppApp: App {
    @StateObject var healthManager = HealthManager.shared

    var body: some Scene {
        WindowGroup {
            FitnessTabView()
                .environmentObject(healthManager)
        }
    }
}
