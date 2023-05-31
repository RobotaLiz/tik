//
//  AddTaskView.swift
//  tik
//
//  Created by Tobias Sörensson on 2023-05-20.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct AddTaskView: View {
    
    @Binding var addTaskIsPresented: Bool
    @State var title = ""
    @State var notes = ""
    @State var location = ""
    @State var setDate = Date()
    
    @ObservedObject var authViewModel : FirestoreManagerVM
    //let addTaskVM = AddTaskVM()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("What to do:", text: $title)
                    .padding()
                TextField("How to do it:", text: $notes)
                    .padding()
                TextField("Where to do it:", text: $location)
                    .padding()
                HStack {
                    Spacer()
                    Text("When to do it:")
                    DatePicker("", selection: $setDate)
                    Spacer()
                }
                .padding()
                Spacer()
                Button("Add", action: {
                    
                    if let currentTikUser = authViewModel.currentTikUser {
                        
                        
                        // save to firestore.
                        let newTask = Task(title: title,
                                           notes: notes,
                                           location: location,
                                           assignedTo: [currentTikUser],
                                           setDate: setDate)
                        
                        authViewModel.saveTaskToFirestore(task: newTask)
                        addTaskIsPresented = false
                    }
                    
                })
                .navigationBarItems(trailing: Button {
                    addTaskIsPresented = false
                } label: {
                    Image(systemName: "xmark")
                })
            }
        }
    }
}

//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView(addTaskIsPresented: .constant(true), authViewModel: AuthViewModel())
//    }
//}
