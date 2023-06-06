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
    @State var calendarArray: [[Date]] = []
    @State var toggle = true
    @StateObject var calendarVM : CalendarViewModel
    
    var body: some View {
        VStack {
            if toggle {
                VStack {
                    Text(calendarVM.currentMonth.formatted(.dateTime.year()))
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
                            /*var index = 0
                             if let date = calendarVM.getClosestDate() {
                             index = calendarVM.getAllDates().firstIndex(of: date) ?? 0
                             }
                             value.scrollTo(index, anchor: .center)*/
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
            Button("v") {
                withAnimation {
                    toggle.toggle()
                }
            }
            List {
                ForEach(calendarVM.tasks) { task in
                    TaskListRowView(task: task)
                }
            }
            .onAppear {
                createMonth()
            }
            
        }
        .onReceive(calendarVM.$currentMonth) { month in
            createMonth()
        }
    }
    
    //TODO: add dates for last and next month (and move functionality out of this funciton
    func createMonth() {
        let calendar = Calendar.current
        let daysInMonth = rangeOfDaysMonth(date: calendarVM.currentMonth)
        let weekday = getWeekday(date: calendarVM.currentMonth)
        
        var weekArray = [Date]()
        var monthArray : [[Date]] = []
        
        //Also don't know if this will crash when weekday < 2
        //Thinks first day of the week is sunday
        //Change to last days in last month
        //switch to subarry
        if let lastMonth = calendar.date(byAdding: DateComponents(month: -1), to: calendarVM.currentMonth) {
            let daysInLastMonth = rangeOfDaysMonth(date: lastMonth)
            if (weekday - 2) > 0 {
                for dateNumber in (1...(weekday - 2)).reversed() {
                    weekArray.append(daysInLastMonth[daysInLastMonth.count - dateNumber])
                }
            }
        }
        
        for day in daysInMonth {
            weekArray.append(day)
            if weekArray.count == 7 {
                monthArray.append(weekArray)
                weekArray = [Date]()
            }
        }
        
        if let nextMonth = calendar.date(byAdding: DateComponents(month: 1), to: calendarVM.currentMonth) {
            let daysInNextMonth = rangeOfDaysMonth(date: nextMonth)
            if (7-weekArray.count) > 0 {
                for dateNumber in 0...(6-weekArray.count) {
                    weekArray.append(daysInNextMonth[dateNumber])
                }
            }
        }
        monthArray.append(weekArray)
        calendarArray = monthArray
    }
    
    //Get all dates for a month
    //TODO: Fix. For may it starts with april 30. Change components.day to 2?
    //works for firstDay but returns the wrong one
    func rangeOfDaysMonth(date: Date) -> [Date] {
        //this seem to work with setting hour to 12 to account for locale and similar not working
        //so works in sweden
        let now = date
        let calendar = Calendar.current
        
        guard let dayRange = calendar.range(of: .day, in: .month, for: now) else { return [] }
        var components = calendar.dateComponents([.day, .month, .year, .era], from: now)
        
        let componentsForWholeMonth = dayRange.compactMap { day -> DateComponents? in
            components.day = day
            components.hour = 12
            return calendar.date(from: components).flatMap {
                calendar.dateComponents([.weekday, .day, .month, .year, .hour], from: $0)
            }
        }
        
        return componentsForWholeMonth.compactMap {calendar.date(from: $0)}
    }
    
    //Get the number of the the weekday a ceratin month start on
    //Starting from sunday
    func getWeekday(date: Date) -> Int {
        let calendar = Calendar.current
        
        //These do not work to set first day to monday
        //calendar.firstWeekday = 2
        //calendar.locale = Locale(identifier: "sv_SE")
        
        
        var components = calendar.dateComponents(
            [
                .year,
                .month,
            ],
            from: date)
        components.day = 1
        
        guard let firstDay = calendar.date(from: components) else {
            calendarArray = []
            return 0
        }
        
        return calendar.component(.weekday, from: firstDay)
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
