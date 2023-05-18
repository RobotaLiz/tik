//
//  HouseholdSelectionView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct HouseholdSelectionView: View {
    
    @StateObject var selectHouseViewModel : JoinHouseViewModel
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
                // Nav to create household view
            }) {
                Text("Create")
            }
            .padding(30)
            .buttonStyle(.borderedProminent)
            Button(action: {
                // Nav to join household view
            }) {
                Text("Join")
            }
            .buttonStyle(.borderedProminent)

        }
        .sheet(isPresented: $createHouseholdViewPresented) {
            CreateHouseholdView(viewModel: JoinHouseViewModel(household: Household(name: "name", pinNum: "456")), householdName: "name", householdPin: "pin")
        }
        .sheet(isPresented: $joinHouseholdViewPresented) {
            JoinHouseholdView(viewModel: JoinHouseViewModel(household: Household(name: "name", pinNum: "456")), inputPin: "666")
        }
    }
}

struct HouseholdSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let household = Household(name: "Test Name", pinNum: "666")
        let vm = JoinHouseViewModel(household: household)
        HouseholdSelectionView(selectHouseViewModel: vm)
    }
}
