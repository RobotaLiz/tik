//
//  CreateHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct CreateHouseholdView: View {
    
    //@ObservedObject var householdViewModel : JoinHouseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var householdName : String = ""
    @State var householdPin : String = ""
    
    @ObservedObject var authViewModel : FirestoreManagerVM
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 50)
                TextField("Enter name", text: $householdName)
                    .padding(10)
                    .cornerRadius(10)
                    .border(Color(.black))
                Spacer(minLength: 50)
            }
            .padding(20)
            Button(action: {
                householdPin = authViewModel.generatePin()
            }) {
                Text("Generate PIN")
            }
            .buttonStyle(.borderedProminent)
            ZStack {
                Color(.gray)
                    .cornerRadius(40)
                Text(householdPin)
                    .font(.system(size: 52))

            }
            .frame(width: 300, height: 200)
            Button(action: {
                authViewModel.addHousehold(name: householdName, pin: householdPin)
                //householdViewModel.currentUser?.isMember = true
                //authViewModel.makeCurrentUserMember()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create")
            }
            .buttonStyle(.borderedProminent)
        }
//        .onAppear {
//            authViewModel.householdFirestoreListener()
//        }
    }
}

//struct CreateHouseholdView_Previews: PreviewProvider {
//    static var previews: some View {
//        let vm = JoinHouseViewModel()
//        CreateHouseholdView(authViewModel: authViewModel, householdName: "Test House", householdPin: "666")
//    }
//}
