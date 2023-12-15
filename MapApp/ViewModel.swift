//
//  ViewModel.swift
//  MapApp
//
//  Created by Maksym on 05.08.2023.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var unlock = false
        let savepath = FileManager.documentDirectory.appendingPathComponent("SavedPlaced")
        
        init(){
            do{
                let data = try Data(contentsOf: savepath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            }catch{
                locations = []
            }
            
        }

        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savepath, options: [.atomic, .completeFileProtection])
            }catch{
                print("Unable to save data")
            }
        }
        func update(location: Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()
        }
        func addlocation(){
            let newlocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longtitude: mapRegion.center.longitude)
            locations.append(newlocation)
            save()
        }
        func aunthenfication(){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "We need your face to unlock your places"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, Autherror in
                    if success{
                        Task{
                            await MainActor.run{
                                self.unlock = true
                            }
                        }
                    }else{
                        // more reason
                    }
                }
            }else{
                print("Error")
            }
        }
    }
}
