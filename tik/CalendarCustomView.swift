//
//  CalendarCustomView.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-30.
//

import Foundation
import SwiftUI

struct CalendarCustomView: View {
    
    let days = ["  ", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let cvHelper = CalendarViewHelper()
    @State var calendarArray: [[Date]] = []
    @State var toggle = true
    @StateObject var calendarVM : CalendarViewModel
    @EnvironmentObject var firestoreManagerVM : FirestoreManagerVM
    
    @State var toggleStartDate = false
    @State var toggleEndDate = false
    
    var body: some View {
        VStack {
            if toggle {
                VStack {
                    //Text(calendarVM.currentMonth.formatted(.dateTime.year()))
                    HStack {
                        Button() {
                            toggleEndDate = false
                            toggleStartDate.toggle()
                        } label: {
                            Image(systemName: toggleStartDate ?  "chevron.down" : "chevron.forward")
                        }
                        .padding(.leading)
                        ScrollViewReader { value in
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(calendarVM.dateRange, id: \.self) { date in
                                        dateItem(date: date, calendarVM: calendarVM)
                                            .id(date)
                                    }
                                }
                                .padding(.bottom)
                            }
                            .onAppear {
                                //Scroll to closet date in the future
                                if let date = calendarVM.getClosestDate() {
                                    value.scrollTo(date, anchor: .center)
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        Button() {
                            toggleStartDate = false
                            toggleEndDate.toggle()
                        } label: {
                            Image(systemName: toggleEndDate ?  "chevron.down" : "chevron.backward")
                        }
                        .padding(.trailing)
                    }
                    if toggleStartDate {
                        DatePicker("Start date", selection: $calendarVM.startDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                    if toggleEndDate {
                        DatePicker("End date", selection: $calendarVM.endDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                    
                    }
            else {
                Text(calendarVM.currentMonth.formatted(.dateTime.month()))
                VStack {
                    HStack {
                        ForEach(days, id: \.self) {day in
                            Spacer()
                            Text("\(day)")
                            Spacer()
                        }
                    }
                    Divider()
                    ForEach(calendarArray, id: \.self) { row in
                        HStack {
                            Spacer()
                            Text("   ")
                            Spacer()
                            ForEach(row, id: \.self) {element in
                                Spacer()
                                CalendarDateItem(date: element, calendarVM: calendarVM)
                                Spacer()
                            }
                        }
                    }
                }
            }
            Button() {
                withAnimation {
                    toggle.toggle()
                }
            } label: {
                Image(systemName: toggle ? "chevron.down" : "chevron.up")
            }
            Divider()
                .padding(.top)
            List {
                ForEach(calendarVM.tasks) { task in
                    TaskListRowView(task: task)
                }
                Spacer().listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .onAppear {
                calendarArray = cvHelper.createMonth(month: calendarVM.currentMonth)
            }
            
        }
        .onReceive(calendarVM.$currentMonth) { month in
            calendarArray = cvHelper.createMonth(month: month)
        }
        .onReceive(calendarVM.$startDate) { _ in
            calendarVM.updateDateRange()
        }
        .onReceive(calendarVM.$endDate) { _ in
            calendarVM.updateDateRange()
        }
    }
}
