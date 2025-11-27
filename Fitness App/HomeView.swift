//
//  HomeView.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-11-27.
//
import SwiftUI


struct HomeView: View {
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
                        ZStack{
                            Circle()
                                .stroke(.red.opacity(0.3),lineWidth: 20)
                            Circle()
                                .trim(from:0,to:0.3)
                                .stroke(style: StrokeStyle(lineWidth:20))
                                .rotation(.degrees(-90))
                            
                            
                        }
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
