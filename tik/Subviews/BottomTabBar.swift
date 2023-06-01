//
//  BottomTabBar.swift
//  tik
//
//  Created by Antonio on 2023-06-01.
//

import SwiftUI

struct BottomTabBar: View {
    @ObservedObject var authViewModel : FirestoreManagerVM

    var body: some View {
        TabView {
            ShoppingListView()
                .tabItem() {
                    Image(systemName: "cart")
                    Text("Shopping List")
                }
            TaskListView(authViewModel: authViewModel)
                .tabItem() {
                    Image(systemName: "list.clipboard")
                    Text("Tasks")
                }
        }
    }
}

struct BottomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        BottomTabBar(authViewModel: vm)
    }
}
