//
//  HomeViewModel.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-12-02.
//

import SwiftUI
import Combine
class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared

    
    @Published var calories:Int = 0
    @Published var exercise:Int = 0
    @Published var stand:Int = 0
    
    @Published var activities = [Activity]()
    
    
    var mockActivities: [Activity] = [
        Activity(title: "Todays Steps", subtitle: "Goal 12, 000", image: "figure.walk", tintColour: .green, amount: "9,812"),
        Activity(title: "Today", subtitle: "Goal 1000", image: "figure.walk", tintColour: .red, amount: "812"),
        Activity(title: "Todays Steps", subtitle: "Goal 12, 000", image: "figure.walk", tintColour: .blue, amount: "9,812"),
        Activity(title: "Todays Steps", subtitle: "Goal 50, 000", image: "figure.run", tintColour: .purple, amount: "75, 000")
    ]
    
    var mockWorkouts: [Workout] = [
        Workout(id: 0, title: "Running", image: "figure.run", date: "Aug 1", duration: "30 min", calories: "512 kcal", tintColour: .green),
        Workout(id: 1, title: "Bench Press", image: "figure.strengthtraining.traditional", date: "Aug 3", duration: "45 min", calories: "592 kcal", tintColour: .blue),
        Workout(id: 2, title: "Walk", image: "figure.walk", date: "Aug 5", duration: "30 min", calories: "212 kcal", tintColour: .red),
        Workout(id: 3, title: "Swimming", image: "figure.pool.swim", date: "Aug 9", duration: "30 min", calories: "640 kcal", tintColour: .cyan)]
    
    init() {
        Task{
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivities()
                
                
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    
    func fetchTodayCalories(){
        healthManager.fetchTodayCaloriesBurned{
            result in switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                    let activity = Activity(title: "Calories Burned", subtitle: "Today", image: "flame", tintColour: .red, amount: calories.formattedNumberString())
                    self.activities.append(activity)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
        
    }
    
    func fetchTodayExerciseTime(){
        healthManager.fetchTodayExerciseTime{
            result in switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
    }
    
    func fetchTodayStandHours(){
        healthManager.fetchTodayStandHours {
            result in switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
        
    }
    
    //MARK: Fitness Activity
    func fetchTodaysSteps(){
        healthManager.fetchTodaySteps{ result in
            switch result{
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            
            case .failure(let failure):
                print(failure.localizedDescription)

            }
        }
        
    }
    
    func fetchCurrentWeekActivities(){
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result{
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            
            case .failure(let failure):
                print(failure.localizedDescription)

            }
            
        }
    }
    
    
    
}
