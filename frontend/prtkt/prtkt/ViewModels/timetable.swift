//
//  timetable.swift
//  prtkt
//
//  Created by Tanya Grover on 9/7/24.
//

import Foundation
import MapKit

struct Class {
    var name: String
    var startTime = Date()
    var location: String
}

struct TimeTable {
    var timetable: [String: [Class]] = [
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": [],
        "Saturday": [],
        "Sunday": []
    ]
    var days: [String]
}

struct Rooms: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: [CLLocationCoordinate2D]
    var detected = false
    var centerCoordinate: CLLocationCoordinate2D {
           let latitude = coordinates.map { $0.latitude }.reduce(0, +) / Double(coordinates.count)
           let longitude = coordinates.map { $0.longitude }.reduce(0, +) / Double(coordinates.count)
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
}

struct Exits: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: [CLLocationCoordinate2D]
    var highlighted = false
    
    var centerCoordinate: CLLocationCoordinate2D {
           let latitude = coordinates.map { $0.latitude }.reduce(0, +) / Double(coordinates.count)
           let longitude = coordinates.map { $0.longitude }.reduce(0, +) / Double(coordinates.count)
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
}
