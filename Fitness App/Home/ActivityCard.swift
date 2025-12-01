//
//  ActivityCard.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-12-01.
//

import SwiftUI

struct Activity{
    let id: Int
    let title:String
    let subtitle:String
    let image:String
    let tintColour: Color
    let amount: String
}

struct ActivityCard: View {
    @State var activity: Activity
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack{
                HStack(alignment: .top){
                    VStack(alignment:.leading,spacing:8){
                        Text(activity.title)
                        Text(activity.subtitle)
                    }
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(.green)
                }
                Text(activity.amount)
                    .font(.title)
                    .bold()
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCard(activity: Activity(id: 0, title: "Todays Steps", subtitle: "Goal 12 000" , image: "figure.walk", tintColour: .green, amount: "9,812"))
}
