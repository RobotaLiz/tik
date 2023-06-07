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
                Spacer()
                VStack {
                    Image("Two Phone Mockup Download App Instagram Post(14)")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.bottom)
                }
//                Spacer().frame(height: 180)
                HStack {
                    Spacer(minLength: 60)
                    TextField("Enter name", text: $householdName)
                        .padding(10)
                        .cornerRadius(10)
                        .border(Color(.black))
                    Spacer(minLength: 60)
                }
                .padding(20)
                Button(action: {
                    householdPin = firestoreManagerViewModel.generatePin()
                }) {
                    Text("Generate PIN")
                }
                .buttonStyle(CustomButtonStyle())
                ZStack {
                    Color(.black)
                        .cornerRadius(40)
                    Text(householdPin)

                }
                .foregroundColor(.white)
                .frame(width: 200, height: 70)
                Spacer()
                Button(action: {
                    if householdName != "" && householdPin != "" {
                        firestoreManagerViewModel.addHousehold(name: householdName, pin: householdPin)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }) {
                    VStack{
                
                        Text("Add Household")
                            .font(.custom("Roboto-Bold", size: 24))
                            .foregroundColor(.black)
                            .padding(.bottom)
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 70.0)
                }
                
            }
        }
    }
}

struct CreateHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        CreateHouseholdView()
    }
}
