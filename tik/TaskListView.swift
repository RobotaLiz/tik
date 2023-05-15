//
//  TaskListView.swift
//  tik
//
//  Created by Antonio on 2023-05-16.
//

import SwiftUI

struct TaskListView: View {
    
    @State var mockData = [Task(name: "Clean kitchen floor"), Task(name: "Dust living room"), Task(name: "Fix stereo"), Task(name: "Buy ice cream")]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(mockData) { task in
                        TaskListRowView(task: task, isDone: true)
                    }
                    .onDelete() { indexSet in
                        for index in indexSet {
                            mockData.remove(atOffsets: indexSet)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}


