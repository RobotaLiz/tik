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
        VStack(alignment: .center)
        
        {
            HStack {
                
                Text(task.title)
                    .padding(.leading, 30.0)
                
                Spacer()
                    
                Button(action: {
                    firestoreManagerViewModel.toggleTikBox(task: task)
                }) {
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .padding(.trailing, 20.0)
                    } else {
                        Image(systemName: "square")
                            .padding(.trailing, 20.0)
                    }
                   
                }
                
//                .buttonStyle(PlainButtonStyle())
                
                
            }
            
            .frame(width: 350.0, height: 20.0)
            
            
//            Divider()
            HStack {
                if let isAdmin = firestoreManagerViewModel.isCurrentUserAdmin {
                    if isAdmin {
                        Menu {
                            ForEach(firestoreManagerViewModel.members, id: \.self) { member in
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
                    }
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
//        .frame(width: 350.0, height: 80.0)
        .cornerRadius(5)
        .accentColor(Color.black)
        .font(.custom("Roboto-Bold", size: 18))

        .background(.yellow)
        .foregroundColor(.black)
        .clipShape(Capsule())
        
        .listRowBackground(Color.clear)

    

    }

}

struct TaskListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListRowView(task: Task(title: "Test Task", setDate: Date())).environmentObject(FirestoreManagerVM())
    }
}
