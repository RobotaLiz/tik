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
    @Published var tasks = [Task]()
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    init() {
        
    }
    
    func getTasks(fromDate: Date, toDate: Date) {
        /*guard let id = auth.currentUser?.uid else {
         return []
         }*/
        
        //TODO: Remove after testing
        //let id = "VswPjuNyPGe6vEAnOhPBPhkgxhv2"
        let id = "n1roMmDMZXNnuk7juPAtajkM0hu2"
        
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
        
        tasks = []
        
        if let startingDate,
           let endingDate {
            db.collection("users").document(id).collection("tasks")
            //.whereField("setDate", isGreaterThan: startingDate) 
            //.whereField("setDate", isLessThan: endingDate)
                .getDocuments() { (snapshot, error) in
                    if let error {
                        
                    }
                    else if let snapshot {
                        self.tasks = snapshot.documents.compactMap {
                            try? $0.data(as: Task.self)
                        }
                    }
                    
                }
        }
        
    }
}
