//
//  DailyStepModel.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//
import Foundation

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}
