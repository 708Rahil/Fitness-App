//
//  HomeView.swift
//  Fitness App
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewmodel = HomeViewModel()
    @AppStorage("userName") var userName: String = "Athlete"

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Greeting
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(greetingText())
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text(userName)
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // MARK: - Rings + Stats
                    ZStack {
                        Color(uiColor: .systemGray6)
                            .cornerRadius(20)

                        HStack(spacing: 0) {
                            // Stats column
                            VStack(alignment: .leading, spacing: 18) {
                                RingStatRow(label: "Calories", value: "\(viewmodel.calories) kcal", color: .red)
                                RingStatRow(label: "Active", value: "\(viewmodel.exercise) min", color: .green)
                                RingStatRow(label: "Stand", value: "\(viewmodel.stand) hrs", color: .blue)
                            }
                            .padding(.leading)

                            Spacer()

                            // Rings
                            ZStack {
                                ProgressCircleView(progress: $viewmodel.calories, goal: 600, color: .red)
                                ProgressCircleView(progress: $viewmodel.exercise, goal: 30, color: .green)
                                    .padding(.all, 22)
                                ProgressCircleView(progress: $viewmodel.stand, goal: 12, color: .blue)
                                    .padding(.all, 44)
                            }
                            .frame(width: 160, height: 160)
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 180)

                    // MARK: - Activity Grid
                    SectionHeader(title: "Fitness Activity", actionLabel: nil, action: nil)

                    if !viewmodel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 12), count: 2)) {
                            ForEach(viewmodel.activities, id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    // MARK: - Recent Workouts
                    SectionHeader(title: "Recent Workouts", actionLabel: "See All") {
                        // navigation handled below
                    }

                    if viewmodel.workouts.isEmpty {
                        Text("No recent workouts found.")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(viewmodel.workouts.prefix(5)) { workout in
                                WorkoutCard(workout: workout)
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
            }
            .navigationBarHidden(true)
        }
    }

    func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }
}

// MARK: - Subviews

struct RingStatRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .bold()
                .foregroundColor(color)
            Text(value)
                .font(.subheadline)
                .bold()
        }
    }
}

struct SectionHeader: View {
    let title: String
    let actionLabel: String?
    let action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            Spacer()
            if let label = actionLabel {
                Button(action: { action?() }) {
                    Text(label)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
