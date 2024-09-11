//
//  timetable.swift
//  prtkt
//
//  Created by Tanya Grover on 9/7/24.
//

import Foundation

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

