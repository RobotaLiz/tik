
// lägga till en knapp i form av text där du ska kunna adda en ny användare.
// ändra signin knappen färg till samma som iconens.
// när du skapa en användare ska samma layout användas där du kan skriva i ditt namn du vill ha
// och sedan lösenordet du väljer.

import SwiftUI
import Firebase
import FirebaseAuth

struct UserLogInView: View {
    enum Field: Hashable {
        case usernameField
        case passwordField
    }
    @State private var username =  ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        
        VStack{
            Image("tik")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 2)
                }
                .shadow(radius: 7)
                .padding()
            Label("My Tik Account", systemImage: "home")
                .padding(-50)
                .bold()
                .font(.title3)
            
                .padding(70)
        }
        Form {
            TextField("Username:", text: $username)
            
            
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
            
                .focused($focusedField, equals: .usernameField)
                .font(.title3)
            
            SecureField("Password:", text: $password)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
            
            
            
                .focused($focusedField, equals: .passwordField)
                .font(.title3)
            
        }
        HStack{
            Button("Add account", action: {})
            Image(systemName: "person.fill.badge.plus")
                .foregroundColor(.gray)
                
        }
        Button("Sign In") {
            signIn()
            
        }
        
        .padding(9)
        .background(.yellow)
        .foregroundColor(.black)
        .clipShape(Capsule())
        .padding(50)
    }
    func signIn () {
        
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
        
        
        
        
        
        
        struct UserLogInView_Previews: PreviewProvider {
            static var previews: some View {
                UserLogInView()
            }
        }
        
    }
}
