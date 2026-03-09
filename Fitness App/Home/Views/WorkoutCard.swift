//
//  WorkoutCard.swift
//  Fitness App
//

import SwiftUI

struct WorkoutCard: View {
    @State var workout: Workout

    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundColor(workout.tintColour)
                .padding(10)
                .background(workout.tintColour.opacity(0.12))
                .cornerRadius(12)

            VStack(spacing: 10) {
                HStack {
                    Text(workout.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.headline)
                    Spacer()
                    Text(workout.duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text(workout.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(workout.calories)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(workout: Workout(id: 0, title: "Running", image: "figure.run", tintColour: .cyan, duration: "30 min", date: "Aug 1", calories: "512 kcal"))
    }
}
