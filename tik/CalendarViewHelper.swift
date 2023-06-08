//
//  CalendarViewHelper.swift
//  tik
//
//  Created by Hakan Johansson on 2023-06-06.
//

import Foundation
import SwiftUI

struct CalendarViewHelper {
    //TODO: add dates for last and next month (and move functionality out of this funciton
    func createMonth(month: Date) -> [[Date]] {
        let calendar = Calendar.current
        let daysInMonth = rangeOfDaysMonth(date: month)
        let weekday = getWeekday(date: month)
        
        var weekArray = [Date]()
        var monthArray : [[Date]] = []
        
        //Also don't know if this will crash when weekday < 2
        //Thinks first day of the week is sunday
        //Change to last days in last month
        //switch to subarry
        if let lastMonth = calendar.date(byAdding: .month, value: -1, to: month) {
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
        
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: month) {
            let daysInNextMonth = rangeOfDaysMonth(date: nextMonth)
            if (7-weekArray.count) > 0 { //Fix
                for dateNumber in 0...(6-weekArray.count) {
                    weekArray.append(daysInNextMonth[dateNumber])
                }
            }
        }
        monthArray.append(weekArray)
        return monthArray
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
        var components = calendar.dateComponents([.day, .month, .year], from: now)
        
        /*let componentsForWholeMonth = dayRange.compactMap { day -> DateComponents? in
            components.day = day
            components.hour = 12
            return calendar.date(from: components).flatMap {
                calendar.dateComponents([.weekday, .day, .month, .year, .hour], from: $0)
            }
        }*/
        
        let datesForWholeMonth = dayRange.compactMap { day -> Date? in
            components.day = day
            components.hour = 12
            return calendar.date(from: components)
        }.compactMap{$0}
        
        return datesForWholeMonth
        //return componentsForWholeMonth.compactMap {calendar.date(from: $0)}
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
            return 0
        }
        
        return calendar.component(.weekday, from: firstDay)
    }
}

//
// Color extensions
//
extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let oWhite = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
}
