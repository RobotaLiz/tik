//
//  Task.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct Task : Identifiable { 
    
    @DocumentID var docId : String?
    var id = UUID()
    var name : String
    var notes : String?
    var location : String?
    var assignedTo : [User] = []
    var isCompleted : Bool = false
    var dateAdded : Date = Date()
    var compledDates : [Date] = []
    
}
