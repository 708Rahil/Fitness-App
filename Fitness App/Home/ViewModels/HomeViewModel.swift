//
//  HomeViewModel.swift
//  Fitness App
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    @Published var activities: [Activity] = []
    @Published var workouts: [Workout] = []

    private var cancellables = Set<AnyCancellable>()
    private let healthManager = HealthManager.shared

    init() {
        healthManager.$todayCalories
            .receive(on: DispatchQueue.main)
            .assign(to: \.calories, on: self)
            .store(in: &cancellables)

        healthManager.$todayExerciseMinutes
            .receive(on: DispatchQueue.main)
            .assign(to: \.exercise, on: self)
            .store(in: &cancellables)

        healthManager.$todayStandHours
            .receive(on: DispatchQueue.main)
            .assign(to: \.stand, on: self)
            .store(in: &cancellables)

        healthManager.$activities
            .receive(on: DispatchQueue.main)
            .assign(to: \.activities, on: self)
            .store(in: &cancellables)

        healthManager.$recentWorkouts
            .receive(on: DispatchQueue.main)
            .assign(to: \.workouts, on: self)
            .store(in: &cancellables)
    }
}
