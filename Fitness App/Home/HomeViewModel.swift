//
//  HomeViewModel.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-12-02.
//

import SwiftUI
import Combine
class HomeViewModel: ObservableObject {
    
    var calories:Int = 123
    var active:Int = 30
    var stand:Int = 8
    
    var mockActivities: [Activity] = [
        Activity(id: 0, title: "Todays Steps", subtitle: "Goal 12, 000", image: "figure.walk", tintColour: .green, amount: "9,812"),
        Activity(id: 1, title: "Today", subtitle: "Goal 1000", image: "figure.walk", tintColour: .red, amount: "812"),
        Activity(id: 2, title: "Todays Steps", subtitle: "Goal 12, 000", image: "figure.walk", tintColour: .blue, amount: "9,812"),
        Activity(id: 3, title: "Todays Steps", subtitle: "Goal 50, 000", image: "figure.run", tintColour: .purple, amount: "75, 000")
    ]
    
    var mockWorkouts: [Workout] = [
        Workout(id: 0, title: "Running", image: "figure.run", date: "Aug 1", duration: "30 min", calories: "512 kcal", tintColour: .green),
        Workout(id: 1, title: "Bench Press", image: "figure.strengthtraining.traditional", date: "Aug 3", duration: "45 min", calories: "592 kcal", tintColour: .blue),
        Workout(id: 2, title: "Walk", image: "figure.walk", date: "Aug 5", duration: "30 min", calories: "212 kcal", tintColour: .red),
        Workout(id: 3, title: "Swimming", image: "figure.pool.swim", date: "Aug 9", duration: "30 min", calories: "640 kcal", tintColour: .cyan)]
    
    
}
