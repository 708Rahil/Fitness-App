//
//  HomeView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-11-27.
//
import SwiftUI
import Combine



struct HomeView: View {
    @StateObject var viewmodel = HomeViewModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false){
                VStack{
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    HStack{
                        Spacer()
                        
                        VStack (alignment: .leading){
                            VStack(alignment: .leading, spacing: 8){
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewmodel.calories)")
                                    .bold()
                            }
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("\(viewmodel.exercise)")
                                    .bold()
                            }
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.blue)
                                
                                Text("\(viewmodel.stand)")
                                    .bold()
                            }
                            
                            
                            
                            
                        }
                        Spacer()
                        ZStack{
                            ProgressCircleView(progress: $viewmodel.calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $viewmodel.exercise, goal: 60, color: .green)
                                .padding(.all,20)
                            
                            
                            ProgressCircleView(progress: $viewmodel.stand, goal: 12, color: .blue)
                                .padding(.all, 40)
                            
                            
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack{
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button{
                            print("Show more")
                        } label:{
                            Text("Show more")
                                .padding(.all,10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewmodel.activities.isEmpty{
                        LazyVGrid(columns: Array(repeating: GridItem(spacing:20),count:2))
                        {
                            ForEach(viewmodel.activities, id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack{
                        Text("Recent Workouts")
                            .font(.title2)
                        
                        Spacer()
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            Text("Show more")
                                .padding(.all,10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                        
                        
                        
                        
                    }
                    .padding(.horizontal)
                    
                    LazyVStack{
                        ForEach(viewmodel.workouts,id: \.id){ workout in
                            WorkoutCard(workout: workout)}
                    }
                    
                }
            }
        }
                
                
                
            }
            
        }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
