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
            ZStack (alignment: .center) {
                
                
                Image("Two Phone Mockup Download App Instagram Post(10)")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                       
                    
                    List{
                        Spacer()
                            .listRowBackground(Color.clear)
                        ForEach(firestoreVm.shoppingItems) { list in
                            
                            HStack {
                                Spacer()
                                Text(list.name)
                                .foregroundColor(.black)
                                Spacer()
                                    .padding(.top, 30.0)
                                    
                                Button(action: {
                                    firestoreVm.deletShoppItem(shoppingItem: list)
                                })
                                {
                                    
                                    
                                    
                                    Image(systemName: "minus.circle")
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        .listRowBackground(Color.yellow)
                        
                    }
                    .scrollContentBackground(.hidden)
                    
                    
                    
                    Button(action: {
                        addingItem = true
                        print("open ssessamiii")
                    }) {
                        VStack{
                            
                            Text("Add Item")
                                .font(.custom("Roboto-Bold", size: 24))
                                .foregroundColor(.black)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)

                        }
                        .buttonStyle(.borderless)
                        .padding(.bottom, 50.0)
                        
                    }
                    
                }
                
                .sheet(isPresented: $addingItem) {
                    ZStack {
                        // Background Image
                        Image("Two Phone Mockup Download App Instagram Post(10) copy")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        
                        // Content View
                        VStack {
                            Label("Add item to list", systemImage: "cart")
                                .font(.largeTitle)
                                .bold()
                                .font(.largeTitle)
                                .padding(.top)
                                .foregroundColor(.white)
                            Spacer()
                            
                            TextField("Name:", text: $name)
                                .frame(width: 250.0)
                                .foregroundColor(.black)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .foregroundColor(.white)
                                
                                .background()
                                
                                
                            
                    
                            
                            
                            Button("Add", action: {
                                let item = ShoppingItemModel(name: name, household: "")
                                firestoreVm.saveShoppingItem(shoppingItem: item)
                                addingItem = false
                                name = ""
                            })
                            .buttonStyle(CustomButtonStyle())
                            .padding(150)
                        }
                    }
                }

                
                
                .navigationBarTitle("Shopping List")
            }
            //        }.onAppear {firestoreVm.addShoppingItemsSnapshotListener()}
            
            
        }
    }
    
    struct ShoppingListView_Previews: PreviewProvider {
        static var previews: some View {
            let vm = FirestoreManagerVM()
            ShoppingListView(firestoreVm: vm)
        }
    }
    
    
}

