//
//  ActivityCard.swift
//  Fitness App
//

import SwiftUI

struct ActivityCard: View {
    @State var activity: Activity

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .font(.footnote)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text(activity.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColour)
                        .font(.title3)
                }
                Spacer()
                Text(activity.amount)
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 4)
            }
            .padding()
        }
        .frame(height: 110)
    }
}

#Preview {
    ActivityCard(activity: Activity(title: "Today's Steps", subtitle: "Goal: 10,000", image: "figure.walk", tintColour: .green, amount: "9,812"))
}
