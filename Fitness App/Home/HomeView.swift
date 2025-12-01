//
//  HomeView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-11-27.
//
import SwiftUI


struct HomeView: View {
    @State var calories:Int = 123
    @State var active:Int = 30
    @State var stand:Int = 8
    
    var mockActivities: [Activity] = [
        Activity(id: 0, title: "Todays Steps", subtitle: "Goal 12 000", image: "figure.walk", tintColour: .green, amount: "9,812"),
        Activity(id: 1, title: "Today", subtitle: "Goal 1000", image: "figure.walk", tintColour: .red, amount: "812"),
        Activity(id: 2, title: "Todays Steps", subtitle: "Goal 12 000", image: "figure.walk", tintColour: .blue, amount: "9,812"),
        Activity(id: 3, title: "Todays Steps", subtitle: "Goal 50 000", image: "figure.run", tintColour: .purple, amount: "100 000")
    ]

    
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
                HStack{
                    Spacer()
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 8){
                            Text("Calories")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.red)
                            
                            Text("123 kcal")
                                .bold()
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Active")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.green)
                            
                            Text("52 mins")
                                .bold()
                        }
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Stand")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.blue)
                            
                            Text("8 hour")
                                .bold()
                        }
                        
                        
                        
                        
                    }
                    Spacer()
                    ZStack{
                        ProgressCircleView(progress: $calories, goal: 600, color: .red)
                        
                        ProgressCircleView(progress: $active, goal: 60, color: .green)
                            .padding(.all,20)
                            
                        
                        ProgressCircleView(progress: $stand, goal: 12, color: .blue)
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
                LazyVGrid(columns: Array(repeating: GridItem(spacing:20),count:2))
                {
                    ForEach(mockActivities, id: \.id) { activity in
                        ActivityCard(activity: activity)
                    }

                    
                    
                    
                }
                .padding(.horizontal)
                
                
                
            }
            
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
