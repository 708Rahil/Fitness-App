//
//  WorkoutsView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//

//
//  WorkoutsView.swift
//  Fitness App
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var searchText = ""

    var filteredWorkouts: [Workout] {
        if searchText.isEmpty { return healthManager.recentWorkouts }
        return healthManager.recentWorkouts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if healthManager.recentWorkouts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "figure.run.circle")
                            .font(.system(size: 72))
                            .foregroundColor(.blue.opacity(0.4))
                        Text("No Workouts Found")
                            .font(.title2)
                            .bold()
                        Text("Your recent workouts from Apple Health will appear here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        // Summary bar
                        WorkoutSummaryBar(workouts: healthManager.recentWorkouts)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        LazyVStack(spacing: 10) {
                            ForEach(filteredWorkouts) { workout in
                                WorkoutCard(workout: workout)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Workouts")
            .searchable(text: $searchText, prompt: "Search workouts")
        }
    }
}

struct WorkoutSummaryBar: View {
    let workouts: [Workout]

    var totalCalories: Int {
        workouts.compactMap { Int($0.calories.components(separatedBy: " ").first ?? "") }.reduce(0, +)
    }

    var body: some View {
        HStack {
            SummaryStatPill(value: "\(workouts.count)", label: "Workouts", color: .blue)
            Spacer()
            SummaryStatPill(value: "\(totalCalories) kcal", label: "Total Calories", color: .orange)
            Spacer()
            SummaryStatPill(value: "7 days", label: "Period", color: .green)
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(16)
    }
}

struct SummaryStatPill: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
