//
//  IndexBadge.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI

struct IndexBadge: View, Identifiable {
    let id = UUID()
    var index: String
    
    let temperatureColors: [Color] = [
        Color(.green),
        Color(hue: 0.148, saturation: 0.764, brightness: 0.903),
        Color(.orange),
        Color(.red),
        Color(hue: 9/360, saturation: 0.83, brightness: 0.56)
    ]

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                
                let gradient = AngularGradient(colors: temperatureColors,
                                               center: .center,
                                               startAngle: .degrees(180),
                                               endAngle: .degrees(360))
                Circle()
                    .trim(from: 0.10, to: 0.90)
                    .rotation(.degrees(90))
                    .stroke(gradient,style: StrokeStyle(lineWidth: 4))
                    .frame(width: 50, height: 50)

                Text(index)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(temperatureColors[(Int(index) ?? 1)-1])
                    .offset(x: -1)
            }
        }.offset(y: -50)
    }
}

struct IndexBadge_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            IndexBadge(index: "3")
        }
    }
}
