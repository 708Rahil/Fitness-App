//
//  ChartsViewModel.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//

//
//  ChartsViewModel.swift
//  Fitness App
//

import SwiftUI
import Combine

enum ChartTimeRange: String, CaseIterable {
    case weekly = "Week"
    case monthly = "Month"
}

enum ChartMetric: String, CaseIterable {
    case steps = "Steps"
    case calories = "Calories"
}

class ChartsViewModel: ObservableObject {
    @Published var selectedRange: ChartTimeRange = .weekly
    @Published var selectedMetric: ChartMetric = .steps

    @Published var weeklySteps: [DailyStepModel] = []
    @Published var monthlySteps: [MonthlyStepModel] = []
    @Published var weeklyCalories: [DailyStepModel] = []

    @Published var averageSteps: Double = 0
    @Published var totalCalories: Double = 0

    private var cancellables = Set<AnyCancellable>()
    private let healthManager = HealthManager.shared

    init() {
        healthManager.$weeklySteps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.weeklySteps = data
                self?.averageSteps = data.isEmpty ? 0 : data.map(\.stepCount).reduce(0, +) / Double(data.count)
            }
            .store(in: &cancellables)

        healthManager.$monthlySteps
            .receive(on: DispatchQueue.main)
            .assign(to: \.monthlySteps, on: self)
            .store(in: &cancellables)

        healthManager.$weeklyCalories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.weeklyCalories = data
                self?.totalCalories = data.map(\.stepCount).reduce(0, +)
            }
            .store(in: &cancellables)
    }
}
