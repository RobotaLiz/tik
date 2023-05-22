//
//  SidebarView.swift
//  tik
//
//  Created by Antonio on 2023-05-22.
//

import SwiftUI

struct SidebarView: View {
    @Binding var isSidebarOpen : Bool
    var body: some View {
        VStack {
            Text("Hi sidebar")
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var isSidebarOpen = true
        SidebarView(isSidebarOpen: $isSidebarOpen)
    }
}
