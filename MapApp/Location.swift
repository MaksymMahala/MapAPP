//
//  Location.swift
//  MapApp
//
//  Created by Maksym on 04.08.2023.
//
import MapKit
import Foundation

struct Location: Identifiable, Codable, Equatable{
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longtitude: Double
    
    var region: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longtitude: -0.141)
}
