//
//  CityManager.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import Foundation
import CoreLocation

var cities: [CityBody] = load("cities.json")

func getCoordinates(cityName: String) -> CityBody.CoordinatesResponse{
    for city in cities {
        if(cityName == city.name){
            return city.coord
        }
    }
    return CityBody.CoordinatesResponse(lon: 0, lat: 0)
}

func getClosestCity(location: CLLocation) -> String{
    var closestCity = ""
    var smallestDistance: CLLocationDistance?
    
    for city in cities {
        let distance = location.distance(from: CLLocation(latitude: city.coord.lat, longitude: city.coord.lon))
        if smallestDistance == nil || distance < smallestDistance ?? Double.infinity {
            closestCity = city.name
            smallestDistance = distance
        }
    }
    return closestCity
}


struct CityBody: Decodable {
    var id: Int
    var name: String
    var state: String
    var country: String
    var coord: CoordinatesResponse
    
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
}
