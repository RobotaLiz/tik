
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
                .bold()
                .font(.title3)
            
            
        }.padding(20)
        
        Form {
            TextField("Username:", text: $username)
            
            
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
            
                .focused($focusedField, equals: .usernameField)
                .font(.title2)
            
            SecureField("Password:", text: $password)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
            
            
                .focused($focusedField, equals: .passwordField)
                .font(.title2)
            
        }
        
        Button("Sign In") {
            if username.isEmpty {
                focusedField = .usernameField
            }else if password.isEmpty {
                focusedField = .passwordField
                
            }else{
                // handleLogin(username, password)
            }
            
        }
        
        .padding(9)
        .background(.yellow)
        .foregroundColor(.black)
        .clipShape(Capsule())
        .padding(50)
    }
    
}






struct UserLogInView_Previews: PreviewProvider {
    static var previews: some View {
        UserLogInView()
    }
}

