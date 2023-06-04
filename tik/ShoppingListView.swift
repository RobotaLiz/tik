//
//  ShoppingListView.swift
//  tik
//
//  Created by Liza Hjortling on 2023-05-28.
//

import SwiftUI

struct ShoppingListView: View {
    @State var addingItem = false
    @State var name = ""
    @State var ShoppList = [ShoppingItemModel(name: "sope", household: "3344")]
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(ShoppList) { list in
                        
                        HStack {
                            Text(list.name)
                            Spacer()
                            Button(action: {
                                if let index = ShoppList.firstIndex(of : list) {
                                    ShoppList.remove(at: index)
                                }
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
                    ShoppList.append(item)
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
        
        
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}

