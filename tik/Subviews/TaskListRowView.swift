//
//  TaskListRowView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI

struct TaskListRowView: View {
    
    var task : Task
    //var isDone : Bool
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    @State var mockMembers = ["Antonio", "Tobias", "Liza", "Miguel", "Håkan"]
    @State var selectedMembers : [String] = []
    
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
                    ForEach(mockMembers, id: \.self) { member in
                        Button(member) {
                            assignSelectedMemberToTask(memberName: member)
                        }
                    }
                } label: {
                    Label("", systemImage: "person.fill.badge.plus")
                        .font(.system(size: 26))
                }
                
                ForEach(selectedMembers, id: \.self) { selectedMember in
                    Text(selectedMember)
                }
                
                Button(action: {
                    assignMyselfToTask()
                }) {
                    Image(systemName: "figure.wave.circle.fill")
                        .font(.system(size: 26))
                    
                }
                
            }
        }
        .cornerRadius(10)
    }
    
    
    // TODO: Integration with firestore, integration in view model, removing mock data, add task listener, styling??
    func assignMyselfToTask() {
        if selectedMembers.contains("Current User") {
            selectedMembers.removeAll { $0 == "Current User" }
        } else {
            selectedMembers.append("Current User")
        }
    }
    
    func assignSelectedMemberToTask(memberName: String) {
        if selectedMembers.contains(memberName) {
            selectedMembers.removeAll { $0 == memberName }
        } else {
            selectedMembers.append(memberName)
        }
    }

    
    

}

struct TaskListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListRowView(task: Task(title: "Test Task", setDate: Date()))
    }
}
