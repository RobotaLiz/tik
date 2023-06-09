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
            ZStack {
                // Add your image here
                Image("Two Phone Mockup Download App Instagram Post(10)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Picker("Date Interval", selection: $selectedInterval) {
                        Text("Daily").tag(DateInterval.day)
                        Text("Weekly").tag(DateInterval.week)
                        Text("Monthly").tag(DateInterval.month)
                        Text("Custom").tag(DateInterval.custom)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    let now = Date()
                    switch selectedInterval {
                    case .day:
                        let itemsToDisplay = calendarVM.allTasks.filter {Calendar.current.isDateInToday($0.setDate)}
                        List {
                            ForEach(itemsToDisplay) { task in
                                TaskListRowView(task: task)
                            }
                            .onDelete() { indexSet in
                                for index in indexSet {
                                    if let indexToRemove = calendarVM.allTasks.firstIndex(where: { $0.id == itemsToDisplay[index].id}) {
                                        firestoreManagerVM.deleteTaskFromFirestore(index: indexToRemove)
                                    }
                                }
                            }
                            Spacer().listRowBackground(Color.clear)
                        }
                        .scrollContentBackground(.hidden)
                    case .week:
                        let itemsToDisplay = calendarVM.allTasks.filter {Calendar.current.isDate(now, equalTo: $0.setDate, toGranularity: .weekOfYear)}
                        List {
                            ForEach(itemsToDisplay) { task in
                                TaskListRowView(task: task)
                            }
                            .onDelete() { indexSet in
                                for index in indexSet {
                                    if let indexToRemove = calendarVM.allTasks.firstIndex(where: { $0.id == itemsToDisplay[index].id}) {
                                        firestoreManagerVM.deleteTaskFromFirestore(index: indexToRemove)
                                    }
                                }
                            }
                            Spacer().listRowBackground(Color.clear)
                        }
                        .scrollContentBackground(.hidden)
                    case .month:
                        let itemsToDisplay = calendarVM.allTasks.filter {Calendar.current.isDate(now, equalTo: $0.setDate, toGranularity: .month)}
                        List {
                            ForEach(itemsToDisplay) { task in
                                TaskListRowView(task: task)
                            }
                            .onDelete() { indexSet in
                                for index in indexSet {
                                    if let indexToRemove = calendarVM.allTasks.firstIndex(where: { $0.id == itemsToDisplay[index].id}) {
                                        firestoreManagerVM.deleteTaskFromFirestore(index: indexToRemove)
                                    }
                                }
                            }
                            Spacer().listRowBackground(Color.clear)
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
}
