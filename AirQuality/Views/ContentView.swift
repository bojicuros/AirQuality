//
//  ContentView.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var airQualityManager = AirQualityManager()
    @State var airQuality: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationManager.location{
                if let airQuality = airQuality{
                    AirQualityView(locationManager: locationManager, airQuality: airQuality, location: location)
                }else{
                    LoadingView()
                        .task {
                            do{
                                airQuality = try await airQualityManager.getCurrentAirQuality(latitude: location.latitude, longitude: location.longitude)
                            }catch{
                                print("Error getting air quality :\(error)")
                            }
                        }
                }
            }else{
                if locationManager.isLoading{
                    LoadingView()
                }else{
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
         }
        .background(Color("SecoundaryColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}
