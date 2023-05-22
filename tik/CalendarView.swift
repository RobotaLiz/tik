//
//  CalendarView.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-21.
//

import SwiftUI

enum DateInterval {
    case day, week, month, custom
}

struct CalendarView: View {
    
    @StateObject var calendarVM : CalendarViewModel
    @State var calendarSettingsViewPresented = false
    @State var selectedInterval: DateInterval = .day
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Date Interval", selection: $selectedInterval) {
                    Text("Daily").tag(DateInterval.day)
                    Text("Weekly").tag(DateInterval.week)
                    Text("Monthly").tag(DateInterval.month)
                    Text("Custom").tag(DateInterval.custom)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                /*List {
                 ForEach(calendarVM.tasks) { task in
                 TaskListRowView(task: task, isDone: true)
                 }
                 }*/
                let now = Date()
                switch selectedInterval {
                case .day:
                    List {
                        ForEach(calendarVM.tasks) { task in
                            if Calendar.current.isDateInToday(task.setDate) {
                                TaskListRowView(task: task, isDone: task.isCompleted)
                            }
                        }
                    }
                    .onAppear() {
                        calendarVM.tasks.forEach {print(Calendar.current.isDate($0.setDate, inSameDayAs: now))}
                        print(now)
                    }
                case .week:
                    List {
                        ForEach(calendarVM.tasks) { task in
                            let components1 = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: now)
                            let components2 = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: task.setDate)
                            if components1.weekOfYear == components2.weekOfYear {
                                TaskListRowView(task: task, isDone: task.isCompleted)
                            }
                        }
                    }
                    .onAppear() {
                        for task in calendarVM.tasks {
                            let components1 = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: now)
                            let components2 = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: task.setDate)
                            print(components1.weekOfYear)
                            print(components2.weekOfYear)
                            print(components1.weekOfYear == components2.weekOfYear)
                        }
                    }
                case .month:
                    List {
                        ForEach(calendarVM.tasks) { task in
                            let components1 = Calendar.current.dateComponents([.month, .year], from: Date())
                            let components2 = Calendar.current.dateComponents([.month, .year], from: task.setDate)
                            
                            if components1.month == components2.month {
                                TaskListRowView(task: task, isDone: task.isCompleted)
                            }
                        }
                    }
                    
                case .custom:
                    Text("Wip")
                }
            }
            .sheet(isPresented: $calendarSettingsViewPresented) {
                CalendarSettingsView()
            }
            .onAppear() {
                //calendarVM.getTasks(fromDate: Date(), toDate: Date())
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Calendar")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        calendarSettingsViewPresented = true
                    }
                }
            }
        }
    }
}
