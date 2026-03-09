//
//  HealthManager.swift
//  Fitness App
//

import Foundation
import Combine
import HealthKit
import SwiftUI

// MARK: - Date Helpers

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }

    func formatWorkoutDate() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return "Today" }
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}

// MARK: - Number Helpers

extension Double {
    func formattedString() -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: self)) ?? "0"
    }
}

extension Int {
    func formattedString() -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension TimeInterval {
    func formattedDuration() -> String {
        let mins = Int(self) / 60
        let hrs = mins / 60
        let remaining = mins % 60
        if hrs > 0 { return "\(hrs)h \(remaining)m" }
        return "\(mins) min"
    }
}

// MARK: - HealthManager

final class HealthManager: ObservableObject {

    static let shared = HealthManager()

    let healthStore = HKHealthStore()

    // Today ring values
    @Published var todayCalories: Int = 0
    @Published var todayExerciseMinutes: Int = 0
    @Published var todayStandHours: Int = 0
    @Published var todaySteps: Int = 0
    @Published var todayDistance: Double = 0
    @Published var todayHeartRate: Double = 0

    // Derived UI data
    @Published var activities: [Activity] = []
    @Published var recentWorkouts: [Workout] = []

    // Chart data
    @Published var weeklySteps: [DailyStepModel] = []
    @Published var monthlySteps: [MonthlyStepModel] = []
    @Published var weeklyCalories: [DailyStepModel] = []

    private init() {
        requestAuthorization()
    }

    // MARK: - Authorization

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            guard success else {
                if let error { print("HealthKit auth error: \(error.localizedDescription)") }
                return
            }
            DispatchQueue.main.async { self.fetchAllData() }
        }
    }

    // MARK: - Fetch All

    func fetchAllData() {
        fetchTodayCalories()
        fetchTodayExerciseMinutes()
        fetchTodayStandHours()
        fetchTodaySteps()
        fetchTodayDistance()
        fetchTodayHeartRate()
        fetchRecentWorkouts()
        fetchWeeklySteps()
        fetchMonthlySteps()
        fetchWeeklyCalories()
    }

    // MARK: - Today Stats

    func fetchTodayCalories() {
        fetchSum(identifier: .activeEnergyBurned, unit: .kilocalorie()) { value in
            self.todayCalories = Int(value)
            self.buildActivities()
        }
    }

    func fetchTodayExerciseMinutes() {
        fetchSum(identifier: .appleExerciseTime, unit: .minute()) { value in
            self.todayExerciseMinutes = Int(value)
            self.buildActivities()
        }
    }

    func fetchTodaySteps() {
        fetchSum(identifier: .stepCount, unit: .count()) { value in
            self.todaySteps = Int(value)
            self.buildActivities()
        }
    }

    func fetchTodayDistance() {
        fetchSum(identifier: .distanceWalkingRunning, unit: .meterUnit(with: .kilo)) { value in
            self.todayDistance = value
            self.buildActivities()
        }
    }

    func fetchTodayStandHours() {
        guard let type = HKCategoryType.categoryType(forIdentifier: .appleStandHour) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else { return }
            let count = samples.filter { $0.value == HKCategoryValueAppleStandHour.stood.rawValue }.count
            DispatchQueue.main.async {
                self.todayStandHours = count
                self.buildActivities()
            }
        }
        healthStore.execute(query)
    }

    func fetchTodayHeartRate() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let bpm = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.todayHeartRate = bpm
                self.buildActivities()
            }
        }
        healthStore.execute(query)
    }

    // MARK: - Generic cumulative sum helper

    private func fetchSum(identifier: HKQuantityTypeIdentifier, unit: HKUnit, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let quantity = result?.sumQuantity() else { return }
            DispatchQueue.main.async { completion(quantity.doubleValue(for: unit)) }
        }
        healthStore.execute(query)
    }

    // MARK: - Build Activities Grid (call on main thread)

    func buildActivities() {
        activities = [
            Activity(title: "Today's Steps",   subtitle: "Goal: 10,000",    image: "figure.walk",  tintColour: .green,  amount: todaySteps.formattedString()),
            Activity(title: "Active Calories", subtitle: "Goal: 600 kcal",  image: "flame",        tintColour: .orange, amount: "\(todayCalories) kcal"),
            Activity(title: "Distance",        subtitle: "Goal: 5 km",      image: "map",          tintColour: .blue,   amount: String(format: "%.2f km", todayDistance)),
            Activity(title: "Exercise",        subtitle: "Goal: 30 min",    image: "timer",        tintColour: .yellow, amount: "\(todayExerciseMinutes) min"),
            Activity(title: "Stand Hours",     subtitle: "Goal: 12 hrs",    image: "person.fill",  tintColour: .cyan,   amount: "\(todayStandHours) hrs"),
            Activity(title: "Heart Rate",      subtitle: "Latest reading",  image: "heart.fill",   tintColour: .red,    amount: todayHeartRate > 0 ? "\(Int(todayHeartRate)) bpm" : "--")
        ]
    }

    // MARK: - Recent Workouts

    func fetchRecentWorkouts() {
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: 20, sortDescriptors: [sort]) { _, samples, _ in
            guard let workouts = samples as? [HKWorkout] else { return }
            let mapped: [Workout] = workouts.enumerated().map { index, workout in
                Workout(
                    id: index,
                    title: workout.workoutActivityType.workoutName,
                    image: workout.workoutActivityType.workoutImage,
                    tintColour: workout.workoutActivityType.tintColor,
                    duration: workout.duration.formattedDuration(),
                    date: workout.startDate.formatWorkoutDate(),
                    calories: workout.totalEnergyBurned.map { "\(Int($0.doubleValue(for: .kilocalorie()))) kcal" } ?? "N/A"
                )
            }
            DispatchQueue.main.async { self.recentWorkouts = mapped }
        }
        healthStore.execute(query)
    }

    // MARK: - Chart Data

    func fetchWeeklySteps() {
        fetchDailyStats(identifier: .stepCount, days: 7, unit: .count()) { data in
            self.weeklySteps = data.map { DailyStepModel(date: $0.date, stepCount: $0.value) }
        }
    }

    func fetchMonthlySteps() {
        fetchDailyStats(identifier: .stepCount, days: 30, unit: .count()) { data in
            self.monthlySteps = data.map { MonthlyStepModel(date: $0.date, stepCount: $0.value) }
        }
    }

    func fetchWeeklyCalories() {
        fetchDailyStats(identifier: .activeEnergyBurned, days: 7, unit: .kilocalorie()) { data in
            self.weeklyCalories = data.map { DailyStepModel(date: $0.date, stepCount: $0.value) }
        }
    }

    private func fetchDailyStats(
        identifier: HKQuantityTypeIdentifier,
        days: Int,
        unit: HKUnit,
        completion: @escaping ([(date: Date, value: Double)]) -> Void
    ) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: .startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())
        let anchorDate = calendar.startOfDay(for: Date())

        let query = HKStatisticsCollectionQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { _, results, _ in
            guard let results else { return }
            var data: [(date: Date, value: Double)] = []
            results.enumerateStatistics(from: startDate, to: Date()) { stats, _ in
                data.append((stats.startDate, stats.sumQuantity()?.doubleValue(for: unit) ?? 0))
            }
            DispatchQueue.main.async { completion(data) }
        }
        healthStore.execute(query)
    }
}

// MARK: - HKWorkoutActivityType Extensions

extension HKWorkoutActivityType {
    var workoutName: String {
        switch self {
        case .running:                                              return "Running"
        case .cycling:                                             return "Cycling"
        case .walking:                                             return "Walking"
        case .swimming:                                            return "Swimming"
        case .yoga:                                                return "Yoga"
        case .functionalStrengthTraining,
             .traditionalStrengthTraining:                         return "Strength Training"
        case .highIntensityIntervalTraining:                       return "HIIT"
        case .hiking:                                              return "Hiking"
        case .basketball:                                          return "Basketball"
        case .soccer:                                              return "Soccer"
        case .tennis:                                              return "Tennis"
        case .rowing:                                              return "Rowing"
        case .elliptical:                                          return "Elliptical"
        case .stairClimbing:                                       return "Stair Climbing"
        case .dance:                                               return "Dance"
        case .pilates:                                             return "Pilates"
        default:                                                   return "Workout"
        }
    }

    var workoutImage: String {
        switch self {
        case .running:                                             return "figure.run"
        case .cycling:                                             return "figure.outdoor.cycle"
        case .walking:                                             return "figure.walk"
        case .swimming:                                            return "figure.pool.swim"
        case .yoga:                                                return "figure.yoga"
        case .functionalStrengthTraining,
             .traditionalStrengthTraining:                         return "dumbbell"
        case .highIntensityIntervalTraining:                       return "bolt.fill"
        case .hiking:                                              return "figure.hiking"
        case .basketball:                                          return "basketball"
        case .soccer:                                              return "soccerball"
        case .tennis:                                              return "tennis.racket"
        case .rowing:                                              return "figure.rowing"
        case .elliptical:                                          return "figure.elliptical"
        case .stairClimbing:                                       return "figure.stair.stepper"
        case .dance:                                               return "figure.dance"
        case .pilates:                                             return "figure.pilates"
        default:                                                   return "figure.mixed.cardio"
        }
    }

    var tintColor: Color {
        switch self {
        case .running:                                             return .cyan
        case .cycling:                                             return .orange
        case .walking:                                             return .green
        case .swimming:                                            return .blue
        case .yoga:                                                return .purple
        case .functionalStrengthTraining,
             .traditionalStrengthTraining:                         return .indigo
        case .highIntensityIntervalTraining:                       return .red
        case .hiking:                                              return .brown
        case .basketball:                                          return .orange
        case .soccer:                                              return .green
        case .tennis:                                              return .yellow
        default:                                                   return .teal
        }
    }
}
