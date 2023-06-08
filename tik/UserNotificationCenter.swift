//
//  UserNotifications.swift
//  tik
//
//  Created by Hakan Johansson on 2023-06-06.
//
//

import Foundation
import UserNotifications

struct UserNotificationCenter {
    private let unCenter = UNUserNotificationCenter.current()
    
    func removeAllNotfications() {
        unCenter.removeAllPendingNotificationRequests()
    }
    
    func removeNotfication(task: Task) {
        unCenter.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
    
    //Sets an alert for a single task
    func setSingleAlert(task: Task, time: Date) {
        unCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                setAlert(task: task, time: time)
            } else {
                unCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        setAlert(task: task, time: time)
                    } else {
                        
                    }
                    
                }
            }
        }
    }
    
    private func setAlert(task: Task, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.subtitle = ""
        content.sound = UNNotificationSound.default
        
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        
        unCenter.add(request)
        
    }
    
    private func setAllAlert(user: User, tasks: [Task], timeToAdd: Int) {
        for task in tasks {
            if let date = Calendar.current.date(byAdding: .minute, value: timeToAdd, to: task.setDate),
               task.assignedTo.contains(where: {$0.email == user.email}) {
                setAlert(task: task, time: date)
            }
        }
    }
    
    func getNotification(task: Task) async -> UNNotificationRequest? {
        return await unCenter.pendingNotificationRequests().filter {$0.identifier == task.id.uuidString}[0]
    }
    
    func isNotificationSet(task: Task) async -> Bool {
        let requests = await unCenter.pendingNotificationRequests()
        return requests.contains {$0.identifier == task.id.uuidString}
    }
    
    //timeToAdd is in minutes. - for before
    //Sets alerts for all tasks in list
    func setNotificationsForSelf(user: User, tasks: [Task], timeToAdd: Int) {
        unCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                setAllAlert(user: user, tasks: tasks, timeToAdd: timeToAdd)
            } else {
                unCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        setAllAlert(user: user, tasks: tasks, timeToAdd: timeToAdd)
                    } else {
                        
                    }
                }
            }
        }
        
    }
}

