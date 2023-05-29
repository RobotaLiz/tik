//
//  Task.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct Task : Identifiable, Codable {
    
    @DocumentID var docId : String?
    var id = UUID() //Do we need this? Couldn't we rename docId to id instead? // We need both docId for Firestore and UUID for the task to be Identifiable, and to be usable in a list. /Antonio
    var title : String
    var notes : String?
    var location : String?
    var assignedTo : [User] = []
    var isCompleted : Bool = false
    var dateAdded : Date = Date()
    var setDate: Date
    var completedDates : [Date] = []
    
    
}
