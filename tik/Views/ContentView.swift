

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var householdViewModel = JoinHouseViewModel()
    
    var body: some View {
        // Trying to rebuild this.
        Group {
            if authViewModel.currentTikUser != nil {
                TaskListView(authViewModel: authViewModel)
            } else {
                UserLogInView(authViewModel: authViewModel)
            }
        }
    }
        
//        Group {
//            if authViewModel.loggedIn {
//                if householdViewModel.currentUser?.isMember == true {
//                    //Text("Current user is member!")                       - Debugging /Antonio
//                    TaskListView(authViewModel: authViewModel)
//                        .onAppear {
//                            authViewModel.didSignOut = {
//                                authViewModel.loggedIn = false
//                            }
//                        }
//                } else if householdViewModel.currentUser?.isMember == false {
//                    HouseholdSelectionView(householdViewModel: householdViewModel)
//                } /*else {
//                    Text("Loading...")
//                }*/
//            } else {
//                UserLogInView(authViewModel: authViewModel)
//            }
//        }
//        .onAppear {
//            //authViewModel.checkLoggedInStatus()
//            householdViewModel.userListener()
//        }
//    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
