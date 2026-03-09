//
//  ProfileView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//

//
//  ProfileView.swift
//  Fitness App
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditGoals = false
    @State private var showingEditName = false
    @State private var tempName = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Avatar & Name
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 90, height: 90)
                            Text(viewModel.storedName.prefix(1).uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 6) {
                            Text(viewModel.storedName)
                                .font(.title2)
                                .bold()
                            Button {
                                tempName = viewModel.storedName
                                showingEditName = true
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.top, 8)

                    // MARK: - Health Stats from HealthKit
                    GroupBox("Health Info") {
                        VStack(spacing: 0) {
                            ProfileRow(icon: "calendar", label: "Age", value: viewModel.age > 0 ? "\(viewModel.age) yrs" : "--")
                            Divider()
                            ProfileRow(icon: "person.fill", label: "Biological Sex", value: viewModel.biologicalSex)
                            Divider()
                            ProfileRow(icon: "drop.fill", label: "Blood Type", value: viewModel.bloodType)
                            Divider()
                            ProfileRow(icon: "ruler", label: "Height", value: viewModel.height.isEmpty ? "--" : viewModel.height)
                            Divider()
                            ProfileRow(icon: "scalemass", label: "Weight", value: viewModel.weight.isEmpty ? "--" : viewModel.weight)
                            if viewModel.bmi > 0 {
                                Divider()
                                ProfileRow(icon: "chart.bar.fill", label: "BMI", value: String(format: "%.1f", viewModel.bmi), valueColor: bmiColor(viewModel.bmi))
                            }
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Daily Goals
                    GroupBox {
                        VStack(spacing: 0) {
                            ProfileRow(icon: "flame.fill", label: "Calorie Goal", value: "\(viewModel.calGoal) kcal", iconColor: .orange)
                            Divider()
                            ProfileRow(icon: "figure.walk", label: "Step Goal", value: "\(viewModel.stepGoal.formattedString()) steps", iconColor: .green)
                            Divider()
                            ProfileRow(icon: "timer", label: "Exercise Goal", value: "\(viewModel.exerciseGoal) min", iconColor: .yellow)
                        }
                    } label: {
                        HStack {
                            Text("Daily Goals")
                            Spacer()
                            Button("Edit") { showingEditGoals = true }
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - HealthKit notice
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Health data is sourced from Apple Health.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditGoals) {
                EditGoalsView(viewModel: viewModel)
            }
            .alert("Your Name", isPresented: $showingEditName) {
                TextField("Name", text: $tempName)
                Button("Save") { viewModel.storedName = tempName }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    func bmiColor(_ bmi: Double) -> Color {
        switch bmi {
        case ..<18.5: return .blue
        case 18.5..<25: return .green
        case 25..<30: return .orange
        default: return .red
        }
    }
}

// MARK: - Profile Row

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String
    var iconColor: Color = .blue
    var valueColor: Color = .primary

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
                .bold()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Edit Goals Sheet

struct EditGoalsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var calGoal: Double = 600
    @State private var stepGoal: Double = 10000
    @State private var exerciseGoal: Double = 30

    var body: some View {
        NavigationStack {
            Form {
                Section("Calorie Goal") {
                    HStack {
                        Slider(value: $calGoal, in: 200...1500, step: 50)
                        Text("\(Int(calGoal)) kcal")
                            .frame(width: 80, alignment: .trailing)
                            .foregroundColor(.orange)
                    }
                }
                Section("Step Goal") {
                    HStack {
                        Slider(value: $stepGoal, in: 2000...20000, step: 500)
                        Text("\(Int(stepGoal))")
                            .frame(width: 70, alignment: .trailing)
                            .foregroundColor(.green)
                    }
                }
                Section("Exercise Goal (minutes)") {
                    HStack {
                        Slider(value: $exerciseGoal, in: 10...120, step: 5)
                        Text("\(Int(exerciseGoal)) min")
                            .frame(width: 80, alignment: .trailing)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .navigationTitle("Edit Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.calGoal = Int(calGoal)
                        viewModel.stepGoal = Int(stepGoal)
                        viewModel.exerciseGoal = Int(exerciseGoal)
                        dismiss()
                    }
                    .bold()
                }
            }
            .onAppear {
                calGoal = Double(viewModel.calGoal)
                stepGoal = Double(viewModel.stepGoal)
                exerciseGoal = Double(viewModel.exerciseGoal)
            }
        }
    }
}
