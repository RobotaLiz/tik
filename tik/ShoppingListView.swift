//
//  ShoppingListView.swift
//  tik
//
//  Created by Liza Hjortling on 2023-05-28.
//

import SwiftUI
import Firebase


struct ShoppingListView: View {
    @StateObject var firestoreVm : FirestoreManagerVM
   
    
    @State var addingItem = false
    @State var name = ""

    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(firestoreVm.shoppingItems) { list in
                        
                        HStack {
                            Text(list.name)
                            Spacer()
                            Button(action: {
                                firestoreVm.deletShoppItem(shoppingItem: list)
                            })
                            {
                                
                                
                                
                                Image(systemName: "minus.circle")
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                }
                Button(action: {
                    addingItem = true
                    print("open ssessamiii")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30) // Adjust as needed
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
                .padding([.trailing], 20)

            }
            
            .sheet(isPresented: $addingItem)
            
            {
                
                
                Label("Add item to list", systemImage:"cart")
                    .font(.largeTitle)
                    .bold()
                    .font(.largeTitle)
                    .padding(.top)
                Spacer()
                
                TextField("Name:", text: $name)
                    .font(.title)
                    .padding()
                
                
                Button("Add   ", action: {
                    let item = ShoppingItemModel(name: name, household: "")
                    firestoreVm.saveShoppingItem(shoppingItem: item)
                    addingItem = false
                    name = ""
                    
                    
                })
                
                .foregroundColor(.black)
                .background(.yellow)
                
                .cornerRadius(20)
                .font(.title2)
                .padding(150)
                .bold()
                
            }
            
            
            .navigationBarTitle("Shopping List")
        }
//        }.onAppear {firestoreVm.addShoppingItemsSnapshotListener()}
        
        
    }
}

//struct ShoppingListView_Previews: PreviewProvider {
 //   static var previews: some View {
  //      ShoppingListView()
    //}
//}

