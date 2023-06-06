//
//  CalendarDateItem.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-30.
//

import Foundation
import SwiftUI

enum ItemState {
    case selected, available, notAvailable, lastMonth, nextMonth
}

struct CalendarDateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    @State var itemState : ItemState = .notAvailable
    
    var body: some View {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.day], from: date).day ?? 0
        
        ZStack {
                circle
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: -5, y: -5)
                    .shadow(color: Color.white.opacity(0.7), radius: 5, x: 10, y: 10)
                Text("\(day)")
        }
        .onTapGesture {
            pressed()
        }
        .onAppear {
            setState()
        }
        .onReceive(calendarVM.$currentMonth) { month in
            setState()
        }
    }
    
    func setState() {
        let calendar = Calendar.current
        
        if let nextMonth = calendar.date(byAdding: DateComponents(month: 1), to: calendarVM.currentMonth),
           let lastMonth = calendar.date(byAdding: DateComponents(month: -1), to: calendarVM.currentMonth) {
            if calendar.isDate(date, equalTo: nextMonth, toGranularity: .month) {
                itemState = .nextMonth
            }
            else if calendar.isDate(date, equalTo: lastMonth, toGranularity: .month) {
                itemState = .lastMonth
            }
            else if calendarVM.dateIsSelected(date: date) {
                itemState = .selected
            }
            else if calendarVM.dateIsInTaskList(date: date) {
                itemState = .available
            }
            else {
                itemState = .notAvailable
            }
        }
    }
    
    func pressed() {
        let calendar = Calendar.current
        
        if let nextMonth = calendar.date(byAdding: DateComponents(month: 1), to: calendarVM.currentMonth),
           let lastMonth = calendar.date(byAdding: DateComponents(month: -1), to: calendarVM.currentMonth) {
            print(calendar.isDate(date, equalTo: nextMonth, toGranularity: .month))
            print(date)
            print(calendarVM.currentMonth)
            if calendar.isDate(date, equalTo: nextMonth, toGranularity: .month) {
                calendarVM.currentMonth = nextMonth
            }
            else if calendar.isDate(date, equalTo: lastMonth, toGranularity: .month) {
                calendarVM.currentMonth = lastMonth
            }
            else if calendarVM.dateIsSelected(date: date) {
                calendarVM.toggleTask(date: date)
            }
            else if calendarVM.dateIsInTaskList(date: date) {
                calendarVM.toggleTask(date: date)
                
            }
        }
        setState()
    }
    
    var circle: some View {
        switch itemState {
        case .available:
            return Circle().fill(.yellow)
        case .notAvailable:
            return Circle().fill(.pink)
        case .selected:
            return Circle().fill(.blue)
        case .lastMonth:
            return Circle().fill(.gray)
        case .nextMonth:
            return Circle().fill(.gray)
        }
    }
}


