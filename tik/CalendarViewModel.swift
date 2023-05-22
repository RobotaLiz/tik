//
//  CalendarViewModel.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-21.
//

import Foundation
import Firebase

class  CalendarViewModel: ObservableObject {
    // @Published var household: Household
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    init() {
        
    }
    
    func getTasks(date: Date) -> [Task] {
        guard let id = auth.currentUser?.uid else {
            return []
        }
        
        var components = Calendar.current.dateComponents(
            [
                .year,
                .month,
                .day
            ],
            from: date)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        var startingDate = Calendar.current.date(from: components)
        
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        var endingDate = Calendar.current.date(from: components)
        
        var tasks = [Task]()
        
        if let startingDate,
           let endingDate {
            db.collection("users").document(id).collection("tasks")
                .whereField("setDate", isGreaterThan: startingDate)
                .whereField("setDate", isLessThan: endingDate)
                .getDocuments() { (querySnapshot, error) in
                    if let error {
                        
                    }
                    else {
                        //or use for documents in QuerySnapshots.documts
                        tasks = (querySnapshot?.documents.compactMap { $0 } ?? []) as? [Task] ?? []
                    }
                }
            
        }
    }
}
