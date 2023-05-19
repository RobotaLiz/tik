
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
            
                .foregroundColor(.black)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .usernameField)
                .font(.title3)
                .textInputAutocapitalization(.never)
            
            SecureField("Password:", text: $password)
                .foregroundColor(.black)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
            
            
            
                .focused($focusedField, equals: .passwordField)
                .font(.title3)
            
        }
        HStack{
            Button("Add account", action: {
                addAccount()
            })
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
        
    }
    func addAccount() {
        Auth.auth().createUser(withEmail:username, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
            
        }
        
        
    }
}

