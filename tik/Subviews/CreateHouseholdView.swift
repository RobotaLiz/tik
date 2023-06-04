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
        ZStack {
            // Add your image here
            Image("Two Phone Mockup Download App Instagram Post(10)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
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
                .buttonStyle(CustomButtonStyle())
                ZStack {
                    Color(.gray)
                        .cornerRadius(40)
                    Text(householdPin)
                        
                    
                }
                .frame(width: 200, height: 70)
                Button(action: {
                    if householdName != "" && householdPin != "" {
                        firestoreManagerViewModel.addHousehold(name: householdName, pin: householdPin)
                        //householdViewModel.currentUser?.isMember = true
                        //authViewModel.makeCurrentUserMember()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }) {
                    Text("Add Household")
                        .font(.custom("Roboto-Bold", size: 24))
                        .foregroundColor(.black)
                        
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                }
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
}
