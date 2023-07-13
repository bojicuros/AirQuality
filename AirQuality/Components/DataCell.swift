//
//  DataCell.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI

struct DataCell: View {
    @State var iconName = "co"
    var name: String
    var value: Double
    
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .padding(5)
                .background(Color(red: 0.722, green: 0.722, blue: 0.722))
                .cornerRadius(50)

            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.caption)
                
                HStack(spacing: 5){
                    Text(String(format: "%.1f", value))
                        .bold()
                        .font(.system(size: 20))
                    Text("μg/m3")
                        .bold()
                        .font(.system(size: 16))
                }
            }
        }.onAppear(perform: setIconName)
        
    }
    func setIconName(){
        if(name == "Carbon monoxide"){
            iconName = "co"
        }else if(name == "Nitrogen monoxide"){
            iconName = "no"
        }else if(name == "Nitrogen dioxide"){
            iconName = "no2"
        }else if(name == "Ozone"){
            iconName = "o3"
        }else if(name == "Sulphur dioxide"){
            iconName = "so2"
        }else if(name == "Fine particle matter"){
            iconName = "pm25"
        }else if(name == "Coarse particulate matter"){
            iconName = "pm10"
        }else if(name == "Amonia"){
            iconName = "nh3"
        }
    }
}

struct DataCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            DataCell(name: "Carbon monoxide", value: 8.123)
                .background(.white)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray)
    }
}
