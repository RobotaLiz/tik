//
//  TaskListView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI

struct TaskListView: View {
    // Tobbe's dirty fingers are everywhere...
    @State var addTaskIsPresented = false
    
    // Antonio's side bar stuff
    @State var isSidebarOpen = false
    @State var selectedTag: String? = nil
    
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
                List {
                    ForEach(mockData) { task in
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
                AddTaskView(addTaskIsPresented: $addTaskIsPresented)
            }
            .navigationViewStyle(.stack)
            .navigationBarTitle("Tasks")
            .listStyle(.plain)
            .onAppear {
                if !isSidebarOpen {
                    isSidebarOpen = false
                }
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: SidebarView(isSidebarOpen: $isSidebarOpen), tag: "sidebar", selection: selectedTagBinding) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                }
            )
            if isSidebarOpen {
                SidebarView(isSidebarOpen: $isSidebarOpen)

            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}


