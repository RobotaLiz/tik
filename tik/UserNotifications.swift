//
//  UserNotifications.swift
//  tik
//
//  Created by Hakan Johansson on 2023-06-06.
//

import Foundation
import UserNotifications

struct UserNotifications {
    let unCenter = UNUserNotificationCenter.current()
    
    func removeAllNotfications() {
        unCenter.removeAllPendingNotificationRequests()
    }
    
    func removeNotfication(task: Task) {
        unCenter.removePendingNotificationRequests(withIdentifiers: [task.docId ?? " ", task.id.uuidString])
    }
    
    func addSingleAlert(task: Task) {
        unCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                setAlert(task: task)
            } else {
                unCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        setAlert(task: task)
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func setAlert(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.subtitle = "15 min left"
        content.sound = UNNotificationSound.default
        
        if let date = Calendar.current.date(byAdding: .minute, value: -15, to: task.setDate) {
            
            var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            
            let request = UNNotificationRequest(identifier: task.docId ?? task.id.uuidString, content: content, trigger: trigger)
            
            unCenter.add(request)
        }
    }
    
    func setAllAlert() {
        let tasks = [Task]()
        
        for task in tasks {
            setAlert(task: task)
        }
    }
    
    func setNotificationsForSelf() {
        unCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                setAllAlert()
            } else {
                unCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        setAllAlert()
                    } else {
                        
                    }
                }
            }
        }
        
    }
}
