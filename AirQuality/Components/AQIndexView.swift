//
//  AQIndexView.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI

struct AQIndexView: View {
    
    var index: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack (spacing: 10){
                    if(index == "1"){
                    Image(systemName: "aqi.low")
                        .font(.system(size: 40))
                    Text("Very good")
                    }else if(index == "2"){
                        Image(systemName: "aqi.low")
                            .font(.system(size: 40))
                        Text("Good")
                    }else if(index == "3"){
                        Image(systemName: "aqi.medium")
                            .font(.system(size: 40))
                        Text("Fair")
                    }else if(index == "4"){
                        Image(systemName: "aqi.high")
                            .font(.system(size: 40))
                        Text("Poor")
                    }else if(index == "5"){
                        Image(systemName: "aqi.high")
                            .font(.system(size: 40))
                        Text("Very poor")
                    }
                }
                Spacer()
            }

            
            Image("city" + index)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350)
                .offset(x: 20)
            
            VStack(alignment: .leading){
                Text("Notice:")
                if(index == "1"){
                    Text("Ideal air quality for outdoor activities")
                }else if(index == "2"){
                    Text("Enjoy your usual outdoor activities.")
                }else if(index == "3"){
                    Text("Reduce strenuous activities outdoors.")
                }else if(index == "4"){
                    Text("Avoid strenuous outdoor activities.")
                }else if(index == "5"){
                    Text("Avoid strenuous activities outdoors. Children and the elderly should also avoid any outdoor activity.")
                }
            }.offset(y: 15)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct AQIndexView_Previews: PreviewProvider {
    static var previews: some View {
        AQIndexView(index: "3")
            .offset(x: 15, y:200)
    }
}
