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
                //calendarVM.getTasks(fromDate: Date(), toDate: Date())
                //calendarVM.getAllTasks()
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
                                calendarDateItem(date: element, calendarVM: calendarVM)
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
                    createMonth(date: Date())
            }
        }
    }
    
    func createMonth(date: Date) {
        let daysInMonth = rangeOfDaysMonth(date: date)
        let weekday = getWeekday(date: date)
        
        var monthArray : [[Date]] = []
        //Change to last days in last month
        //Also don't know if this will crash when weekday < 2
        //Thinks first day of the week is sunday
        var weekArray = [Date](repeating: Date.now, count: weekday-2)
        var counter = weekArray.count < 1 ? 1 : weekArray.count
        
        //Maybe guard
        for day in daysInMonth {
            weekArray.append(day)
            if counter % 7 == 0 {
                monthArray.append(weekArray)
                weekArray = [Date]()
                counter = 1
            }
            else {
                counter += 1
            }
        }
        //weekArray.append(contentsOf: 1...(7-weekArray.count))
        weekArray.append(contentsOf: [Date](repeating: Date.now, count: 7-weekArray.count))
        monthArray.append(weekArray)
        test = monthArray
    }
    
    //Get all dates for a month
    func rangeOfDaysMonth(date: Date) -> [Date] {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents(
            [
                .year,
                .month,
            ],
            from: date)
        components.day = 1
        
        guard let firstDay = calendar.date(from: components) else {
            test = []
            return []
        }
        
        let range = calendar.range(of: .day, in: .month, for: firstDay)
        var days = [Date]()
        if let range {
            days = range.compactMap { day -> Date? in
                components.day = day
                return calendar.date(from: components)
            }
        }
        /*if let range {
            for d in range {
                components.day = d
                days.append(calendar.date(from: components))
            }
        }*/
        
        return days//.compactMap {$0}
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

enum itemSate {
    case selected, available, notAvailable
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

struct calendarDateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    
    var body: some View {
        let day = Calendar.current.dateComponents([.day], from: date).day ?? 0
        
        ZStack {
            if day < 10 {
                Circle().fill(.clear)
                Text("\(day)")
            }
            else {
                Circle().fill(.yellow)
                Text("\(day)")
            }
        }
            .onTapGesture {
                calendarVM.toggleTask(date: date)
            }
    }
}
