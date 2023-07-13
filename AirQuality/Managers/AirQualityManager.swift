//
//  AirQualityManager.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import Foundation
import CoreLocation

class AirQualityManager{
    
    let apiKey = YOUR_API_KEY
    
    func getCurrentAirQuality(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody{
                
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")else { fatalError("Missing URL")}
            
        let urlRequest = URLRequest(url: url)
        
        let (data,response) =  try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
    
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var list: [ListResponse]
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct ListResponse: Decodable {
        var main: MainResponse
        var components: ComponentsResponse
        var dt: Double
        
        struct MainResponse: Decodable{
            var aqi: Double
        }
        
        struct ComponentsResponse: Decodable{
            var co: Double
            var no: Double
            var no2: Double
            var o3: Double
            var so2: Double
            var pm2_5: Double
            var pm10: Double
            var nh3: Double
        }
    }
}
