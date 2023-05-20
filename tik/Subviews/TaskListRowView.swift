//
//  TaskListRowView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI

struct TaskListRowView: View {
    
    var task : Task
    var isDone : Bool
    
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Button(action: {
                //TODO: Toggle - Task completed logic
            }) {
                if isDone {
                    Image(systemName: "checkmark.square")
                } else {
                    Image(systemName: "square")
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct TaskListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListRowView(task: Task(title: "Test Task", setDate: Date()), isDone: true)
    }
}
