//
//  FitnessTabView.swift
//  Fitness App
//

import SwiftUI

struct FitnessTabView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
                .tag(1)

            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.fill")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.blue)
    }
}

struct FitnessTabView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTabView()
            .environmentObject(HealthManager.shared)
    }
}
