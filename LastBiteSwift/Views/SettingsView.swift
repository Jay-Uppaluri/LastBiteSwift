// SETTINGS MAIN SCREEN
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView() {
            VStack(spacing:32){
                
                //Top Header
                VStack(spacing:20){
                    Text("Settings")
                        .font(.custom("DMSans-Bold", size: 20))
                        .foregroundColor(Color("AccentColor"))
                    
                    //Subheader
                    VStack(spacing:20){
                        HStack(){
                            Text("Account Settings")
                                .font(.custom("DMSans-Bold", size: 14))
                            Spacer()
                        }
                    }
                    
                    //Item List
                    VStack(spacing:20){
                        NavigationLink(destination:AccountDetailsView()) {
                            HStack(){
                                Text("Account Details")
                                    .font(.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)
                        }
                        
                        NavigationLink(destination:NotificationsView()) {
                            HStack(){
                                Text("Notifications")
                                    .font(.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Image(systemName: "chevron.right")
                                }
                            .foregroundColor(.black)
                            
                        }
                        
                        HStack(){
                            Text("Payment Methods")
                                .font(.custom("DMSans-Regular", size: 18))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
                VStack(spacing:20){
                    VStack(spacing:20){
                        HStack(){
                            Text("Get Support")
                                .font(.custom("DMSans-Bold", size: 14))
                            Spacer()
                        }
                    }
                    
                    VStack(spacing:20){
                        NavigationLink(destination:HelpCenter()) {
                            HStack(){
                                Text("Help Center")
                                    .font(.custom("DMSans-Regular", size: 18))
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)
                        }
                        
                        HStack(){
                            Text("Terms and Conditions")
                                .font(.custom("DMSans-Regular", size: 18))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        
                        HStack(){
                            Text("Privacy and Data")
                                .font(.custom("DMSans-Regular", size: 18))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
                VStack(spacing:20){
                    VStack(spacing:20){
                        HStack(){
                            Text("Subheader")
                                .font(.custom("DMSans-Bold", size: 14))
                            Spacer()
                        }
                    }
                    
                    VStack(spacing:20){
                        HStack(){
                            Text("Log Out")
                                .font(.custom("DMSans-Regular", size: 18))
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding()
            
        }
        
    }
        
    }


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
