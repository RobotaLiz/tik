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
    @ObservedObject var authViewModel : FirestoreManagerVM
    // Antonio's side bar stuff - Work in progress
    @State var isSidebarOpen = false
    @State var selectedTag: String? = nil
    
    let auth = Auth.auth()
    
    @Environment(\.presentationMode) var presentationMode
    
    var selectedTagBinding: Binding<String?> {
        Binding<String?>(
            get: { selectedTag },
            set: { tag in
                selectedTag = tag
                isSidebarOpen = tag != nil
            }
        )
    }
    
    @State var mockData = [Task(title: "Clean kitchen floor", setDate: Date()),
                           Task(title: "Dust living room", setDate: Date()),
                           Task(title: "Fix stereo", setDate: Date()),
                           Task(title: "Buy ice cream", setDate: Date())]
    
    var body: some View {
        NavigationView {
            VStack {
                if let uid = auth.currentUser?.uid {
                    
                    Text("Firestore UID: \(uid)")
                } else {
                    Text("UID: N/A")
                }
                
                if let currentTikUser = authViewModel.currentTikUser {
                    HStack {
                        if let email = currentTikUser.email {
                            Text("Tik user: \(email)")
                        }
                        if let docID = currentTikUser.docId {
                            Text(("ID: \(docID)"))
                        }
                    }
                }
                
                if let currentHousehold = authViewModel.currentHousehold {
                    HStack {
                        Text("Household: \(currentHousehold.name), Pin: \(currentHousehold.pin)")
                        if let docID = currentHousehold.docId {
                            Text("ID: \(docID)")
                        }
                    }
                }
                List {
                    ForEach(authViewModel.tasks) { task in
                        TaskListRowView(task: task, isDone: true)
                    }
                    .onDelete() { indexSet in
                        for _ in indexSet {
                            mockData.remove(atOffsets: indexSet)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
                
                // Navigation to AddTaskView added.
                Button(action: {
                    
                    
                    addTaskIsPresented = true
                    print("!")
                }) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .padding([.trailing], 20)
            }
            // AddTaskView is presented as a sheet.
            .sheet(isPresented: $addTaskIsPresented) {
                AddTaskView(addTaskIsPresented: $addTaskIsPresented, authViewModel: authViewModel)
            }
            .navigationViewStyle(.stack)
            .navigationBarTitle("Tasks")
            .listStyle(.plain)
            .onAppear {
                if !isSidebarOpen {
                    isSidebarOpen = false
                }
            }
            .navigationBarItems(leading: {
                Menu {
                    Button(action: {
                        authViewModel.checkOutHousehold()
                        //authViewModel.loggedIn = false
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("Sign out from household", systemImage: "figure.walk.departure")
                    }
                    Button(action: {
                        authViewModel.signOut()
                        //authViewModel.loggedIn = false
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("Log out", systemImage: "person.crop.circle.fill.badge.xmark")
                    }
                } label: {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                }
            }())
            
            // Side bar work in progress
            /*.navigationBarItems(trailing:
                                    NavigationLink(destination: SidebarView(isSidebarOpen: $isSidebarOpen, authViewModel: authViewModel), tag: "sidebar", selection: selectedTagBinding) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                }
            )*/
            if isSidebarOpen {
                SidebarView(isSidebarOpen: $isSidebarOpen, authViewModel: authViewModel)

            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = FirestoreManagerVM()
        TaskListView(authViewModel: authViewModel)
    }
}


