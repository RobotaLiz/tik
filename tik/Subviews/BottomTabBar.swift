//
//  BottomTabBar.swift
//  tik
//
//  Created by Antonio on 2023-06-01.
//

import SwiftUI

struct BottomTabBar: View {
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    @State var defaultTab : Int = 1
    
    var body: some View {
        
        TabView(selection: $defaultTab) {
            TaskListView()
                .tabItem() {
                    Image(systemName: "list.clipboard")
                    Text("Tasks")
                }
            ShoppingListView(firestoreVm: firestoreManagerViewModel)
                .tabItem() {
                    Image(systemName: "cart")
                    Text("Shopping List")
                }
            CalendarView()
                .tabItem() {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            if let isAdmin = firestoreManagerViewModel.isCurrentUserAdmin {
                if isAdmin {
                    UserManagementView()
                        .tabItem() {
                            Image(systemName: "person")
                            Text("User Management")
                        }
                }
            }
        }
        .accentColor(Color.black)
    }
}

struct BottomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        BottomTabBar().environmentObject(vm)
    }
}
