//
//  TaskListRowView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI

struct TaskListRowView: View {
    
    var task : Task
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    var body: some View {
        VStack {
            HStack {
                Text(task.title)
                Spacer()
                Button(action: {
                    firestoreManagerViewModel.toggleTikBox(task: task)
                }) {
                    if task.isCompleted {
                        Image(systemName: "checkmark.square")
                    } else {
                        Image(systemName: "square")
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            Divider()
            HStack {
                Menu {
                    ForEach(firestoreManagerViewModel.currentHousehold?.members ?? [], id: \.self) { member in
                        if let name = member.name, let taskId = task.docId {
                            Button(name) {
                                firestoreManagerViewModel.toggleUserToTask(taskId: taskId, member: member)
                            }
                        }

                    }
                } label: {
                    Label("", systemImage: "person.fill.badge.plus")
                        .font(.system(size: 26))
                }
                
                ForEach(task.assignedTo, id: \.self) { selectedMember in
                    if let name = selectedMember.name {
                        Text(name)
                    }
                }
                
                Button(action: {
                    if let taskId = task.docId, let currentUser = firestoreManagerViewModel.currentTikUser {
                        firestoreManagerViewModel.toggleUserToTask(taskId: taskId, member: currentUser)
                    }
                }) {
                    Image(systemName: "figure.wave.circle.fill")
                        .font(.system(size: 26))
                    
                }
                
            }
        }
        .cornerRadius(10)
    }

}

struct TaskListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListRowView(task: Task(title: "Test Task", setDate: Date()))
    }
}
