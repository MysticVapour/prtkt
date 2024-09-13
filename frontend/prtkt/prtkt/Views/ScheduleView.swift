import SwiftUI

struct DayScheduleView: View {
    @Binding var scheduleEntries: [Class]
    var dayName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dayName)
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                
                Button(action: {
                    // Add a new class entry for the day
                    scheduleEntries.append(Class(name: "", startTime: Date(), location: ""))
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
            }

            ForEach($scheduleEntries.indices, id: \.self) { index in
                withAnimation {
                    HStack {
                        TextField("Class Name", text: $scheduleEntries[index].name)
                            .padding()
                            .font(.custom("TYPOGRAPH PRO Light", size: 32))
                            .frame(width: 200, height: 50)
                            .background(Color(red: 0.8, green: 0.9, blue: 0.8))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))

                        DatePicker("Enter Time", selection: $scheduleEntries[index].startTime, displayedComponents: .hourAndMinute)
                            .font(.custom("TYPOGRAPH PRO Light", size: 10))
                            .labelsHidden()
                            .frame(width: 100, height: 50)
                            .background(Color(red: 0.8, green: 0.9, blue: 0.8))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                        
                        // Remove button
                        Button(action: {
                            scheduleEntries.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                    }
                }
                
            }.transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                     removal: .move(edge: .bottom).combined(with: .opacity)))
            .animation(.easeInOut(duration: 0.5), value: scheduleEntries.count)

        }
    }
}

struct ScheduleView: View {
    // Use arrays of Class for each day
    @State private var mondayEntries = [Class]()
    @State private var tuesdayEntries = [Class]()
    @State private var wednesdayEntries = [Class]()
    @State private var thursdayEntries = [Class]()
    @State private var fridayEntries = [Class]()

    var body: some View {
        ZStack {
            Circle()
                .scale(100)
                .fill(Color.main.opacity(0.9) )
                .frame(width: 40, height: 10)
                .offset(x: 25, y: -25)
            
            Circle()
                .scale(30)
                .foregroundColor(.white.opacity(0.25))
                .frame(width: 40, height: 20)
                .offset(x: 25, y: -25)
        }
        VStack {
            Text("Enter your schedule")
                .foregroundColor(Color.black)
                .font(.largeTitle)
                .bold()
                .padding()
            
            DayScheduleView(scheduleEntries: $mondayEntries, dayName: "Monday")
            DayScheduleView(scheduleEntries: $tuesdayEntries, dayName: "Tuesday")
            DayScheduleView(scheduleEntries: $wednesdayEntries, dayName: "Wednesday")
            DayScheduleView(scheduleEntries: $thursdayEntries, dayName: "Thursday")
            DayScheduleView(scheduleEntries: $fridayEntries, dayName: "Friday")
        }
        .padding()
    }
}

#Preview {
    ScheduleView()
}
