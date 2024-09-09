//
//  Timetable UI.swift
//  prtkt
//
//  Created by Tanya Grover on 9/7/24.
//

import SwiftUI

struct Timetable_UI: View {
    @State private var monTime = Date()
    @State private var monClass = ""
    @State private var tueTime = Date()
    @State private var tueClass = ""
    @State private var WedTime = Date()
    @State private var wedClass = ""
    @State private var thursTime = Date()
    @State private var thursClass = ""
    @State private var friTime = Date()
    @State private var friClass = ""
    @State private var isMondayVisible = false
    @State private var isTuesdayVisible = false
    @State private var isWednesdayVisible = false
    @State private var isThursdayVisible = false
    @State private var isFridayVisible = false
    
    var body: some View {
        ZStack {
            Circle()
                .scale(70)
                .fill(Color(red: 0.7, green: 0.9, blue: 0.7))
                .frame(width: 40, height: 10)
                .offset(x: 25, y: -25) // Adjust to align with the corner
            
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
            
            //Monday
            HStack {
                Text("Monday")
                    .multilineTextAlignment(.leading)
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isMondayVisible.toggle() }
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isMondayVisible {
                HStack{
                    TextField("CMSC216", text: $monClass)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $monTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                }
            }
            
            //Tuesday
            HStack {
                Text("Tuesday")
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isTuesdayVisible.toggle()
                }
                
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isTuesdayVisible {
                HStack{
                    TextField("CMSC250", text: $tueClass)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $tueTime, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    
                }
            }
            
            //Wednesday
            HStack {
                Text("Wednesday")
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isWednesdayVisible.toggle() }
                
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isWednesdayVisible {
                HStack{
                    TextField("MATH246", text: $wedClass)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $WedTime, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                }
            }
            
            //Thursday
            HStack {
                Text("Thursday")
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isThursdayVisible.toggle()
                }
                
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isThursdayVisible {
                HStack{
                    TextField("MATH301", text: $thursClass)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $thursTime, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                }
            }
            
            //Friday
            HStack {
                Text("Friday")
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                Button("+") {
                    isFridayVisible.toggle() }
                .frame(width: 25, height: 25)
                .shadow(radius: 5)
                .foregroundColor(Color.white)
                .background(Color.black)
            }
            if isFridayVisible {
                HStack{
                    TextField("PHYS173", text: $friClass)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                    DatePicker("Enter Time", selection: $friTime, displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .frame(width: 100, height: 50)
                        .background(Color(red: 0.8, green: 0.9, blue: 0.8 ))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                }
            }
            
            
        }
        
    }
}

#Preview {
    Timetable_UI()
    }

