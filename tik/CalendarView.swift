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
                    .scrollContentBackground(.hidden)
                case .week:
                    List {
                        ForEach(calendarVM.allTasks) { task in
                            if Calendar.current.isDate(now, equalTo: task.setDate, toGranularity: .weekOfYear) {
                                TaskListRowView(task: task)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                case .month:
                    List {
                        ForEach(calendarVM.allTasks) { task in
                            if Calendar.current.isDate(now, equalTo: task.setDate, toGranularity: .month) {
                                TaskListRowView(task: task)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                case .custom:
                    CalendarCustomView(calendarVM: calendarVM)
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Add selected") {
                            if let user = firestoreManagerVM.currentTikUser {
                                calendarVM.addAlertsSelected(user: user, selected: selectedInterval)
                            }
                        }
                        Button("Add all") {
                            if let user = firestoreManagerVM.currentTikUser {
                                calendarVM.addAlertsAllDate(user: user)
                            }
                        }
                    }
                label: {
                    Label("", systemImage: "alarm.waves.left.and.right")
                        .font(.system(size: 14))
                }
                    //}
                }
            }
            .onReceive(firestoreManagerVM.$tasks) { _ in
                calendarVM.allTasks = firestoreManagerVM.tasks
                calendarVM.upateTaskList()
            }
        }
    }
}
