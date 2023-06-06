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
    
    var body: some View {
        VStack {
            if toggle {
                VStack {
                    //Text(calendarVM.currentMonth.formatted(.dateTime.year()))
                    ScrollViewReader { value in
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(calendarVM.getAllDates(), id: \.self) { date in
                                    dateItem(date: date, calendarVM: calendarVM)
                                }
                            }
                            
                            .padding(.bottom)
                        }
                        .onAppear {
                            //Scroll to closet date in the future
                            var index = 0
                             if let date = calendarVM.getClosestDate() {
                             index = calendarVM.getAllDates().firstIndex(of: date) ?? 0
                             }
                             value.scrollTo(index, anchor: .center)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
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
                Image(systemName: toggle ? "arrow.down.square" : "arrow.up.square")
        }
            List {
                ForEach(calendarVM.tasks) { task in
                    TaskListRowView(task: task)
                }
            }
            .onAppear {
                //createMonth()
                calendarArray = cvHelper.createMonth(month: calendarVM.currentMonth)
            }
            
        }
        .onReceive(calendarVM.$currentMonth) { month in
            //createMonth()
            calendarArray = cvHelper.createMonth(month: month)
        }
    }
}

struct dateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    @State var selected = false
    
    var body: some View {
        ZStack {
            if selected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.offWhite)
            }
            else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.oWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 4)
                    .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
            }
            Text(date.formatted(.dateTime.day().month()))
                .padding()//.horizontal)
        }
        .onTapGesture {
            calendarVM.toggleTask(date: date)
        }
        .onReceive(calendarVM.$dateList) { month in
            if calendarVM.dateIsSelected(date: date) {
                selected = true
            }
            else {
                selected = false
            }
        }
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let oWhite = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
}
