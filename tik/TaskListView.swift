//
//  TaskListView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI
import FirebaseAuth

struct TaskListView: View {
    // Tobbe's dirty fingers are everywhere...
    @State var addTaskIsPresented = false
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    let auth = Auth.auth()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var mockData = [Task(title: "Clean kitchen floor", setDate: Date()),
                           Task(title: "Dust living room", setDate: Date()),
                           Task(title: "Fix stereo", setDate: Date()),
                           Task(title: "Buy ice cream", setDate: Date())]
    
    var body: some View {
        
        NavigationView {
            
                // Add your image here
                ZStack (alignment: .center) {
                    
                    
                        Image("Two Phone Mockup Download App Instagram Post(10)")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)

                
                VStack {
                    Spacer()
//                    if let uid = auth.currentUser?.uid {
//
//                        Text("Firestore UID: \(uid)")
//                    } else {
////                        Text("UID: N/A")
//                    }
//
//                    if let currentTikUser = firestoreManagerViewModel.currentTikUser {
//                        HStack {
//                            if let email = currentTikUser.email {
//                                Text("Tik user: \(email)")
//                            }
//                            if let docID = currentTikUser.docId {
//                                Text(("ID: \(docID)"))
//                            }
//                        }
//                    }

                    
//                    if let currentHousehold = firestoreManagerViewModel.currentHousehold {
//                        HStack {
//                            Text("Household: \(currentHousehold.name), Pin: \(currentHousehold.pin)")
//                            if let docID = currentHousehold.docId {
//                                Text("ID: \(docID)")
//                            }
//                        }
//
//                }
                
                    List {
                        ForEach(firestoreManagerViewModel.tasks) { task in
                            TaskListRowView(task: task)
                        }
                        .onDelete() { indexSet in
                            for index in indexSet {
                                firestoreManagerViewModel.deleteTaskFromFirestore(index: index)
                            }
                        }
                        .buttonStyle(.borderless)
                        .padding()
                    }

                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    
                    // Navigation to AddTaskView added.
                    Button(action: {
                        

                        
                        addTaskIsPresented = true
                        print("!")
                    }) {
                        VStack{
                            
                            Text("Add Task")
                                .font(.custom("Roboto-Bold", size: 24))
                                .foregroundColor(.black)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)

                        }
                        .buttonStyle(.borderless)
                        .padding(.bottom, 50.0)
                        
                    }
               
                    // AddTaskView is presented as a sheet.
                    .sheet(isPresented: $addTaskIsPresented) {
                        AddTaskView(addTaskIsPresented: $addTaskIsPresented)
                    }
                    .navigationViewStyle(.stack)
                    .navigationBarTitle("Tasks")
                    .listStyle(.plain)
                    .navigationBarItems(trailing: {
                        Menu {
                            Button(action: {
                                firestoreManagerViewModel.checkOutHousehold()
                                //authViewModel.loggedIn = false
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("Sign out from household", systemImage: "figure.walk.departure")
                            }
                            Button(action: {
                                firestoreManagerViewModel.signOut()
                                //authViewModel.loggedIn = false
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("Log out", systemImage: "person.crop.circle.fill.badge.xmark")
                            }
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .foregroundColor(.black)
                            
                        }
                    }())
                }
            }
        }
        
    }
  
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        TaskListView().environmentObject(vm)
    }
}
