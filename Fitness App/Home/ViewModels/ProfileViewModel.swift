//
//  ProfileViewmodel.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//

//
//  ProfileViewModel.swift
//  Fitness App
//

import SwiftUI
import HealthKit
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var age: Int = 0
    @Published var biologicalSex: String = ""
    @Published var bloodType: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bmi: Double = 0

    // Goals stored in UserDefaults
    @AppStorage("calGoal") var calGoal: Int = 600
    @AppStorage("stepGoal") var stepGoal: Int = 10000
    @AppStorage("exerciseGoal") var exerciseGoal: Int = 30
    @AppStorage("userName") var storedName: String = "Athlete"

    private let healthStore = HealthManager.shared.healthStore

    init() {
        fetchBiologicalData()
        fetchBodyMeasurements()
        userName = storedName
    }

    func fetchBiologicalData() {
        do {
            let dob = try healthStore.dateOfBirthComponents()
            if let year = dob.year {
                age = Calendar.current.component(.year, from: Date()) - year
            }
        } catch { }

        do {
            let sex = try healthStore.biologicalSex()
            switch sex.biologicalSex {
            case .female: biologicalSex = "Female"
            case .male: biologicalSex = "Male"
            case .other: biologicalSex = "Other"
            default: biologicalSex = "Not Set"
            }
        } catch { }

        do {
            let blood = try healthStore.bloodType()
            switch blood.bloodType {
            case .aPositive: bloodType = "A+"
            case .aNegative: bloodType = "A−"
            case .bPositive: bloodType = "B+"
            case .bNegative: bloodType = "B−"
            case .abPositive: bloodType = "AB+"
            case .abNegative: bloodType = "AB−"
            case .oPositive: bloodType = "O+"
            case .oNegative: bloodType = "O−"
            default: bloodType = "Not Set"
            }
        } catch { }
    }

    func fetchBodyMeasurements() {
        fetchLatestSample(identifier: .height) { [weak self] value in
            let cm = value * 100
            self?.height = String(format: "%.0f cm", cm)
            self?.computeBMI()
        }
        fetchLatestSample(identifier: .bodyMass) { [weak self] value in
            self?.weight = String(format: "%.1f kg", value)
            self?.computeBMI()
        }
    }

    private func fetchLatestSample(identifier: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let unit: HKUnit = identifier == .height ? .meter() : .gramUnit(with: .kilo)
            DispatchQueue.main.async {
                completion(sample.quantity.doubleValue(for: unit))
            }
        }
        healthStore.execute(query)
    }

    private func computeBMI() {
        guard let h = Double(height.components(separatedBy: " ").first ?? ""),
              let w = Double(weight.components(separatedBy: " ").first ?? ""),
              h > 0 else { return }
        let heightM = h / 100
        bmi = w / (heightM * heightM)
    }
}
