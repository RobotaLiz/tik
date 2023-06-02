//
//  CreateHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct CreateHouseholdView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var householdName : String = ""
    @State var householdPin : String = ""
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
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
                householdPin = firestoreManagerViewModel.generatePin()
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
                if householdName != "" && householdPin != "" {
                    firestoreManagerViewModel.addHousehold(name: householdName, pin: householdPin)
                    //householdViewModel.currentUser?.isMember = true
                    //authViewModel.makeCurrentUserMember()
                    presentationMode.wrappedValue.dismiss()
                }
              
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

struct CreateHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        CreateHouseholdView()
    }
}
