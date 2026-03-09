//
//  HistoricDataView.swift
//  Fitness App
//

import SwiftUI
import Charts

/// A standalone historic data screen — can be pushed from Charts tab or Home.
struct HistoricDataView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedRange: ChartTimeRange = .weekly

    var stepData: [DailyStepModel] {
        selectedRange == .weekly ? healthManager.weeklySteps : healthManager.weeklySteps
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {

                Picker("Range", selection: $selectedRange) {
                    ForEach(ChartTimeRange.allCases, id: \.self) { r in
                        Text(r.rawValue).tag(r)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Steps chart
                GroupBox("Steps — Last 7 Days") {
                    Chart(healthManager.weeklySteps) { item in
                        LineMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Steps", item.stepCount)
                        )
                        .foregroundStyle(.blue.gradient)
                        .interpolationMethod(.catmullRom)
                        AreaMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Steps", item.stepCount)
                        )
                        .foregroundStyle(.blue.opacity(0.1).gradient)
                        .interpolationMethod(.catmullRom)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.narrow))
                        }
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal)

                // Calories chart
                GroupBox("Calories — Last 7 Days") {
                    Chart(healthManager.weeklyCalories) { item in
                        BarMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Calories", item.stepCount)
                        )
                        .foregroundStyle(.orange.gradient)
                        .cornerRadius(6)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.narrow))
                        }
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal)

                // Monthly Steps
                GroupBox("Steps — Last 30 Days") {
                    Chart(healthManager.monthlySteps) { item in
                        BarMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Steps", item.stepCount)
                        )
                        .foregroundStyle(.purple.gradient)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                            AxisValueLabel(format: .dateTime.day())
                        }
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal)

                Spacer(minLength: 20)
            }
            .padding(.top, 8)
        }
        .navigationTitle("Historic Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}
