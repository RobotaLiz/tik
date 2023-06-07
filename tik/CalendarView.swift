//
//  CalendarView.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-21.
//
//  TODO: Split code. Use extensions. Fix accurate times

import SwiftUI

enum DateInterval {
    case day, week, month, custom
}

struct CalendarView: View {
    
    @StateObject var calendarVM = CalendarViewModel()
    @State var calendarSettingsViewPresented = false
    @State var selectedInterval: DateInterval = .day
    
    @EnvironmentObject var firestoreManagerVM : FirestoreManagerVM
    
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
                let now = Date()
                switch selectedInterval {
                case .day:
                    List {
                        ForEach(calendarVM.allTasks) { task in
                            if Calendar.current.isDateInToday(task.setDate) {
                                TaskListRowView(task: task)
                            }
                        }
                    }
                case .week:
                    List {
                        ForEach(calendarVM.allTasks) { task in
                            if Calendar.current.isDate(now, equalTo: task.setDate, toGranularity: .weekOfYear) {
                                TaskListRowView(task: task)
                            }
                        }
                    }
                case .month:
                    List {
                        ForEach(calendarVM.allTasks) { task in
                            if Calendar.current.isDate(now, equalTo: task.setDate, toGranularity: .month) {
                                TaskListRowView(task: task)
                            }
                        }
                    }
                    
                case .custom:
                    CalendarCustomView(calendarVM: calendarVM)
                }
            }
            .sheet(isPresented: $calendarSettingsViewPresented) {
                CalendarSettingsView()
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
            .onReceive(firestoreManagerVM.$tasks) { tasks in
                calendarVM.allTasks = firestoreManagerVM.tasks
                calendarVM.upateTaskList()
            }
        }
    }
}
