

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var authViewModel = FirestoreManagerVM()
    
    
    var body: some View {
        // Trying to rebuild this.
        Group {
            if authViewModel.currentTikUser == nil {
                UserLogInView(authViewModel: authViewModel)
            } else if authViewModel.currentTikUser != nil && authViewModel.currentHousehold != nil {
                TaskListView(authViewModel: authViewModel)
            } else if authViewModel.currentTikUser != nil && authViewModel.currentHousehold == nil {
                HouseholdSelectionView(authViewModel: authViewModel)
            }
                
                
            
        }
    }
        

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
