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
    // @Published var household: Household
    @Published var tasks = [Task]()
    @Published var allTasks = [Task]()
    @Published var currentMonth = Date.now
    
    var dateList = [Date]() //TODO: sorted set?
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    init() {
        //getAllTasks()
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
        if let index = dateList.firstIndex(where: {Calendar.current.isDate(date, equalTo: $0, toGranularity: .day)}) {
            return true
        }
        return false
    }
    
    func upateTaskList() {
        tasks = []
        
        //TODO: Check for more efficient way
        for dates in dateList {
            tasks.append(contentsOf: getTasks(fromDate: dates, toDate: dates))
            print(tasks)
        }
    }
    
    func getAllTasks() {
        //let id = "n1roMmDMZXNnuk7juPAtajkM0hu2"
        let id = "VswPjuNyPGe6vEAnOhPBPhkgxhv2"
        
        db.collection("users").document(id).collection("tasks")
            .getDocuments() { (snapshot, error) in
                if let error {
                    
                }
                else if let snapshot {
                    self.allTasks = snapshot.documents.compactMap {
                        try? $0.data(as: Task.self)
                    }
                }
                
            }
    }
    
    func getClosestDate() -> Date? {
        var dateToReturn: Date?
        
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
        
        let startingDate = Calendar.current.date(from: components)
        
        if let startingDate {
            dateToReturn = tasks.sorted {$0.setDate < $1.setDate}
                .first {$0.setDate > startingDate}?.setDate ?? nil
        }
        
        return dateToReturn
    }
    
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
        
        if let startingDate,
           let endingDate {
            tasksToReturn = allTasks.filter {$0.setDate > startingDate && $0.setDate < endingDate}
        }
        return tasksToReturn
    }
    
    func getAllDates() -> [Date] {
        var datesToReturn = [Date]()
        
        datesToReturn = allTasks.sorted {$0.setDate > $1.setDate}
            .compactMap{
                let components = Calendar.current.dateComponents([.year, .month, .day], from: $0.setDate)
                return Calendar.current.date(from: components) ?? $0.setDate
            }
        
        return datesToReturn
    }
}
