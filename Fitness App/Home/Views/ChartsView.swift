//
//  CharsView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2026-03-09.
//

//
//  ChartsView.swift
//  Fitness App
//

import SwiftUI
import Charts

struct ChartsView: View {
    @StateObject private var viewModel = ChartsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Pickers
                    VStack(spacing: 12) {
                        Picker("Metric", selection: $viewModel.selectedMetric) {
                            ForEach(ChartMetric.allCases, id: \.self) { m in
                                Text(m.rawValue).tag(m)
                            }
                        }
                        .pickerStyle(.segmented)

                        Picker("Range", selection: $viewModel.selectedRange) {
                            ForEach(ChartTimeRange.allCases, id: \.self) { r in
                                Text(r.rawValue).tag(r)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)

                    // MARK: - Summary Card
                    SummaryCard(viewModel: viewModel)
                        .padding(.horizontal)

                    // MARK: - Bar Chart
                    ChartCard(viewModel: viewModel)
                        .padding(.horizontal)

                    // MARK: - Average daily steps last 7 days
                    if viewModel.selectedMetric == .steps {
                        StepGoalCard(average: viewModel.averageSteps)
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.top, 8)
            }
            .navigationTitle("Charts")
        }
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    @ObservedObject var viewModel: ChartsViewModel

    var summaryValue: String {
        switch viewModel.selectedMetric {
        case .steps:
            let avg = viewModel.averageSteps
            return avg > 0 ? "\(Int(avg).formattedString()) avg/day" : "--"
        case .calories:
            return viewModel.totalCalories > 0 ? "\(Int(viewModel.totalCalories).formattedString()) kcal total" : "--"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.selectedMetric.rawValue)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(summaryValue)
                .font(.largeTitle)
                .bold()
            Text(viewModel.selectedRange.rawValue == "Week" ? "Last 7 days" : "Last 30 days")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Chart Card

struct ChartCard: View {
    @ObservedObject var viewModel: ChartsViewModel

    var barColor: Color { viewModel.selectedMetric == .steps ? .blue : .orange }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.selectedMetric == .steps ? "Step Count" : "Active Calories")
                .font(.headline)
                .padding(.horizontal)

            Chart {
                if viewModel.selectedMetric == .steps {
                    if viewModel.selectedRange == .weekly {
                        ForEach(viewModel.weeklySteps) { item in
                            BarMark(
                                x: .value("Day", item.date, unit: .day),
                                y: .value("Steps", item.stepCount)
                            )
                            .foregroundStyle(barColor.gradient)
                            .cornerRadius(6)
                        }
                        RuleMark(y: .value("Goal", 10000))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundStyle(.green.opacity(0.6))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Goal")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                    } else {
                        ForEach(viewModel.monthlySteps) { item in
                            BarMark(
                                x: .value("Day", item.date, unit: .day),
                                y: .value("Steps", item.stepCount)
                            )
                            .foregroundStyle(barColor.gradient)
                        }
                    }
                } else {
                    ForEach(viewModel.weeklyCalories) { item in
                        BarMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Calories", item.stepCount)
                        )
                        .foregroundStyle(barColor.gradient)
                        .cornerRadius(6)
                    }
                    RuleMark(y: .value("Goal", 600))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(.red.opacity(0.6))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("Goal")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                }
            }
            .frame(height: 220)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Step Goal Card

struct StepGoalCard: View {
    let average: Double
    let goal: Double = 10000

    var progress: Double { min(average / goal, 1.0) }
    var progressColor: Color { progress >= 1.0 ? .green : progress >= 0.7 ? .yellow : .red }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Step Goal")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Int(average).formattedString())")
                        .font(.title2)
                        .bold()
                    Text("avg / day · goal \(Int(goal).formattedString())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.title3)
                    .bold()
                    .foregroundColor(progressColor)
            }

            ProgressView(value: progress)
                .tint(progressColor)
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(16)
    }
}
