//
//  SwiftUIView.swift
//  prtkt
//
//  Created by Tanya Grover on 9/9/24.
//
import SwiftUI

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
    
    init() {
        self.days = Array(timetable.keys)
    }
}

struct DayScheduleView: View {
    @Binding var isVisible: Bool
    @Binding var scheduleEntry: Class
    
    var dayName: String
    
    var body: some View {
        VStack {
            HStack {
                Text(dayName)
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isVisible.toggle()
                }
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isVisible {
                HStack {
                    TextField("Class Name", text: $scheduleEntry.name)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $scheduleEntry.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                }
            }
        }
    }
}

struct SwiftUIView: View {
    
    
    @State private var mondayVisible = false
    @State private var tuesdayVisible = false
    @State private var wednesdayVisible = false
    @State private var thursdayVisible = false
    @State private var fridayVisible = false
    
    @State private var mondayEntry = Class(name: "", startTime: Date(), location: "")
    @State private var tuesdayEntry = Class(name: "", startTime: Date(), location: "")
    @State private var wednesdayEntry = Class(name: "", startTime: Date(), location: "")
    @State private var thursdayEntry = Class(name: "", startTime: Date(), location: "")
    @State private var fridayEntry = Class(name: "", startTime: Date(), location: "")
    
    var body: some View {
        ZStack {
            Circle()
                .scale(100)
                .fill(Color(red: 0.7, green: 0.9, blue: 0.7))
                .frame(width: 40, height: 10)
                .offset(x: 25, y: -25)
            
            Circle()
                .scale(50)
                .foregroundColor(.white.opacity(0.25))
                .frame(width: 40, height: 10)
                .offset(x: 25, y: -25)
        }
        
        VStack {
            Text("Enter your schedule")
                .foregroundColor(Color.black)
                .font(.largeTitle)
                .bold()
                .padding()
            
            DayScheduleView(isVisible: $mondayVisible, scheduleEntry: $mondayEntry, dayName: "Monday")
            DayScheduleView(isVisible: $tuesdayVisible, scheduleEntry: $tuesdayEntry, dayName: "Tuesday")
            DayScheduleView(isVisible: $wednesdayVisible, scheduleEntry: $wednesdayEntry, dayName: "Wednesday")
            DayScheduleView(isVisible: $thursdayVisible, scheduleEntry: $thursdayEntry, dayName: "Thursday")
            DayScheduleView(isVisible: $fridayVisible, scheduleEntry: $fridayEntry, dayName: "Friday")
        }
    }
    
}
        
        
#Preview {
    SwiftUIView()
}

