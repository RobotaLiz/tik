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
                    AllView(calendarVM: calendarVM)
                }
            }
            .sheet(isPresented: $calendarSettingsViewPresented) {
                CalendarSettingsView()
            }
            .onAppear() {

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

struct AllView: View {
    
    let days = ["  ", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @State var test: [[Date]] = []
    @State var toggle = true
    @StateObject var calendarVM : CalendarViewModel
    
    var body: some View {
        VStack {
            if toggle {
                VStack {
                    Text("2023")
                    ScrollViewReader { value in
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(calendarVM.getAllDates(), id: \.self) { date in
                                    dateItem(date: date, calendarVM: calendarVM)
                                        .padding(.horizontal)
                                        .background(.yellow)
                                        .cornerRadius(10)
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
                Text("May")
                VStack {
                    HStack {
                        ForEach(days, id: \.self) {day in
                            Spacer()
                            Text("\(day)")
                            Spacer()
                        }
                    }
                    Divider()
                    ForEach(test, id: \.self) { row in
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
                    Text("\(task.title)")
                }
            }
            .onAppear {
                //createMonth(date: calendarVM.currentMonth)
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
        let daysInMonth = rangeOfDaysMonth(date: calendarVM.currentMonth)//rangeOfDaysMonth(date: date)
        let weekday = getWeekday(date: calendarVM.currentMonth)//getWeekday(date: date)
        
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
        test = monthArray
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
            test = []
            return 0
        }
        
        return calendar.component(.weekday, from: firstDay)
    }
}

enum ItemState {
    case selected, available, notAvailable, lastMonth, nextMonth
}

struct dateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day().month()))
                .onTapGesture {
                    calendarVM.toggleTask(date: date)
                }
        }
    }
}

struct CalendarDateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    @State var itemState : ItemState = .notAvailable
    
    var body: some View {
        let calendar = Calendar.current
        let day = calendar.dateComponents([.day], from: date).day ?? 0
        
        ZStack {
            if day < 10 {
                circle
                Text("\(day)")
            }
            else {
                circle
                Text("\(day)")
            }
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
                itemState = .nextMonth
                calendarVM.currentMonth = nextMonth
            }
            else if calendar.isDate(date, equalTo: lastMonth, toGranularity: .month) {
                itemState = .lastMonth
                calendarVM.currentMonth = lastMonth
            }
            else if calendarVM.dateIsSelected(date: date) {
                itemState = .selected
                calendarVM.toggleTask(date: date)
            }
            else if calendarVM.dateIsInTaskList(date: date) {
                itemState = .available
                calendarVM.toggleTask(date: date)

            }
            else {
                itemState = .notAvailable
            }
        }
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
