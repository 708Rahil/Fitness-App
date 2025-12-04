//
//  Fitness_AppApp.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-11-27.
//

import SwiftUI

@main
struct Fitness_AppApp: App {
    init() {
        print("App init")
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    print("HomeView appeared")
                }
        }
    }
}
