//
//  HouseholdSelectionView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct HouseholdSelectionView: View {
    
    @ObservedObject var householdViewModel : JoinHouseViewModel
    @State var createHouseholdViewPresented = false
    @State var joinHouseholdViewPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("In order to use this app, you need to be a member of a household.")
                    .padding(40)
                Spacer()
            }
            Button(action: {
                createHouseholdViewPresented.toggle()
            }) {
                Text("Create")
            }
            .padding(30)
            .buttonStyle(.borderedProminent)
            Button(action: {
                joinHouseholdViewPresented.toggle()
            }) {
                Text("Join")
            }
            .buttonStyle(.borderedProminent)

        }
        .sheet(isPresented: $createHouseholdViewPresented) {
            CreateHouseholdView(householdViewModel: JoinHouseViewModel(), householdName: "name", householdPin: "pin")
        }
        .sheet(isPresented: $joinHouseholdViewPresented) {
            JoinHouseholdView(householdViewModel: JoinHouseViewModel(), inputPin: "666")
        }
    }
}

struct HouseholdSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let jhvm = JoinHouseViewModel()
        HouseholdSelectionView(householdViewModel: jhvm)
    }
}
