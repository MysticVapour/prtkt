//
//  timetable.swift
//  prtkt
//
//  Created by Tanya Grover on 9/7/24.
//

import Foundation

struct timetable: Identifiable, Codable{
    var id = UUID()
    let days: [Days]
}

struct Days: Identifiable, Codable {
    var id = UUID()

}
