//
//  AirQualityView.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI
import CoreLocationUI
import MapKit

struct AirQualityView: View {
    var locationManager: LocationManager
    var airQualityManager = AirQualityManager()
    @State var airQuality: ResponseBody
    @State var location: CLLocationCoordinate2D
    @State private var showSearchAlert = false
    @State private var showLocationAlert = false
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .top){
                Rectangle()
                    .foregroundColor(.clear)
                HStack {
                    Button {
                        if let newLocation = locationManager.location{
                            location = newLocation
                            Task{
                                await updateAirQualityData()
                            }
                        }else{
                            showLocationAlert = true
                        }
                    } label: {
                        Image(systemName:
                                "location")
                        .font(.system(size: 25))
                        .padding(7)
                        .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
                        .background(Color("SecoundaryColor"))
                        .cornerRadius(50)
                    }.alert(isPresented: $showLocationAlert) {
                        Alert(
                            title: Text("Problem getting location"),
                            message: Text("There was problem getting your location. Please check your location settings and try later.")
                        )
                    }
                    
                    TextField("Search", text: $searchText)
                        .frame (height: 10)
                        .padding()
                        .background(Color("SecoundaryColor"))
                        .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
                        .cornerRadius(15)
                    
                    Button {
                        let cityCoordinates = getCoordinates(cityName: searchText)
                        if(cityCoordinates.lat == 0 && cityCoordinates.lon == 0){
                            showSearchAlert = true
                        }else{
                            location = CLLocationCoordinate2D(latitude: cityCoordinates.lat, longitude: cityCoordinates.lon)
                            Task{
                                await updateAirQualityData()
                            }
                        }
                    } label: {
                        Image(systemName:
                                "magnifyingglass")
                        .font(.system(size: 25))
                        .padding(7)
                        .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
                        .background(Color("SecoundaryColor"))


                        .cornerRadius(50)
                    }.alert(isPresented: $showSearchAlert) {
                        Alert(
                            title: Text("No data for " + (searchText.isEmpty ? "this location" : searchText)),
                            message: Text("Data for specified location can’t be " +
                                          "determined at the time.")
                        )
                    }
                    
                }
                .frame(width: 370)
            }
            
            VStack {
                Spacer(minLength: 60)
                
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text(getClosestCity(location: CLLocation(latitude: location.latitude, longitude: location.longitude)))
                            .bold()
                            .font(.title)
                        
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(String(format: "%.f", airQuality.list[0].main.aqi))
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .padding()
                        .offset(x: -10)
                }
                
                Spacer()
                
                AQIndexView(index: String(format: "%.f", airQuality.list[0].main.aqi))

                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack {
                                
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Air Quality now")
                        .bold()
                        .offset(x: 10)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        HStack(spacing:10){
                            VStack(alignment: .leading, spacing: 20){
                                DataCell(name: "Carbon monoxide",  value: airQuality.list[0].components.co)
                                DataCell(name: "Nitrogen monoxide", value: airQuality.list[0].components.no)
                                DataCell(name: "Nitrogen dioxide", value: airQuality.list[0].components.no2)
                                DataCell(name: "Ozone", value: airQuality.list[0].components.o3)
                            }
                            
                            Divider()

                            VStack(alignment: .leading, spacing: 20){
                                DataCell(name: "Sulphur dioxide", value: airQuality.list[0].components.so2)
                                DataCell(name: "Fine particle matter", value: airQuality.list[0].components.pm2_5)
                                DataCell(name: "Coarse particulate matter", value: airQuality.list[0].components.pm10)
                                DataCell(name: "Amonia", value: airQuality.list[0].components.nh3)
                            }
                        }
                        .frame(width: 360)
                        
                        Map(coordinateRegion: $region, annotationItems: [IndexBadge(index: String(format: "%.f", airQuality.list[0].main.aqi))]
                        ){ badge in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                            badge
                          }
                        }.frame(width: 330, height: 200)
                        .cornerRadius(30)
                                
                                    
                    }
                    .frame(height: 200, alignment: .leading)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .padding(.bottom, 20)
                .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
                .background(colorScheme == .dark ? Color.accentColor : .white)
                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color("BackgroundColor"))
        .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
        .onAppear(perform: generateTasks)
    }
    
    func generateTasks() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
    @MainActor
    func updateAirQualityData() async{
        do{
            airQuality = try await airQualityManager.getCurrentAirQuality(latitude: location.latitude, longitude: location.longitude)
        }catch{
            print("Error getting air quality :\(error)")
        }
        
        generateTasks()
    }
}

struct AirQualityView_Previews: PreviewProvider {
    static var previews: some View {
        AirQualityView(locationManager: LocationManager(), airQuality: previewAirQuality, location: CLLocationCoordinate2D(latitude: 0, longitude: 0))
            .preferredColorScheme(.light)
    }
}
