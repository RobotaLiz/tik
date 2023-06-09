//
//  CalendarViewModel.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-21.
//
// toggleTask - toggles date to show / not show
// updateTaskList - updates task with the dates in taskList
// getAllTasks - download all task from firebase ( change to listener)
// getClosestDate - get the closet date in the last thats bigger than todays date
// getTasks - get tasks between two dates
// getDates - return a set of dates of all tasks

import Foundation
import Firebase

class  CalendarViewModel: ObservableObject {
    @Published var tasks = [Task]()
    @Published var allTasks = [Task]()
    @Published var currentMonth = Date.now
    @Published var dateList = [Date]()
    
    @Published var startDate = Date.now
    @Published var endDate = Date.now
    @Published var dateRange = [Date]()
    
    init() {
        
    }
    
    func updateDateRange() {
        let calendar = Calendar.current
        //Could use range but have to check if endDate is bigger than startDate (startDate ... endDate).contains(task.setDate)
        dateRange = getAllDates().filter {calendar.isDateInToday($0) || calendar.isDate($0, inSameDayAs: endDate) ||
            (startDate < $0 && $0 < endDate)}
    }
    
    func toggleTask(date: Date) {
        if let index = dateList.firstIndex(where: {Calendar.current.isDate(date, equalTo: $0, toGranularity: .day)}) {
            dateList.remove(at: index)
        }
        else {
            dateList.append(date)
        }
        
        upateTaskList()
    }
    
    func dateIsInTaskList(date: Date) -> Bool {
        return allTasks.contains(where: {Calendar.current.isDate(date, equalTo: $0.setDate, toGranularity: .day)})
    }
    
    func dateIsSelected(date: Date) -> Bool {
        if dateList.contains(where: {Calendar.current.isDate(date, equalTo: $0, toGranularity: .day)}) {
            return true
        }
        return false
    }
    
    func upateTaskList() {
        tasks = []
        
        //TODO: Check for more efficient way
        for dates in dateList {
            tasks.append(contentsOf: getTasks(fromDate: dates, toDate: dates))
        }
    }
    
    func getClosestDate() -> Date? {
        var dateToReturn: Date?
        
        //TODO: remove
        var components = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day
            ],
            from: Date())
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        //TODO: use getAlldates
        if let startingDate  = Calendar.current.date(from: components) {
            dateToReturn = allTasks.sorted {$0.setDate < $1.setDate}
                .first {Calendar.current.isDateInToday($0.setDate) || $0.setDate > startingDate}?.setDate
        }
        
        return dateToReturn
    }
    
    //TODO: remove components
    func getTasks(fromDate: Date, toDate: Date) -> [Task] {
        var tasksToReturn = [Task]()
        
        var components = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day
            ],
            from: fromDate)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let startingDate = Calendar.current.date(from: components)
        
        components = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day
            ],
            from: toDate)
        
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let endingDate = Calendar.current.date(from: components)
        
        //TODO: rewrite with isintoday
        if let startingDate,
           let endingDate {
            tasksToReturn = allTasks.filter {$0.setDate > startingDate && $0.setDate < endingDate}
        }
        return tasksToReturn
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        var setOfDates = Set<Date>()
        
        let datesToReturn = allTasks.filter { task in
            let components = calendar.dateComponents([.year, .month, .day], from: task.setDate)
            guard let date = calendar.date(from: components) else {
                return false
            }
            let isUnique = setOfDates.insert(date).inserted
            return isUnique
            
        }
            .compactMap { $0.setDate }
            .sorted {$0 < $1}
        
        return datesToReturn
    }
    
    func addAlertsAllDate(user: User) {
        let unCenter = UserNotificationCenter()
        unCenter.setNotificationsForSelf(user: user, tasks: allTasks, timeToAdd: -15)
    }
    
    func addAlertsSelected(user: User, selected: DateInterval) {
        let unCenter = UserNotificationCenter()
        let timeToAdd = -15
        var tasksToAdd = [Task]()
        
        switch selected {
        case .day:
            tasksToAdd = allTasks.filter {Calendar.current.isDateInToday($0.setDate)}
        case .week:
            tasksToAdd = allTasks.filter {
                Calendar.current.isDate(Date.now, equalTo: $0.setDate, toGranularity: .weekOfYear)}
        case .month:
            tasksToAdd = allTasks.filter {
                Calendar.current.isDate(Date.now, equalTo: $0.setDate, toGranularity: .month)}
        case .custom:
            tasksToAdd = tasks
        }
        unCenter.setNotificationsForSelf(user: user, tasks: tasksToAdd, timeToAdd: timeToAdd)
    }
    
}


