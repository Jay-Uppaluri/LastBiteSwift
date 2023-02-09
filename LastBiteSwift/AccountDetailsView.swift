
import SwiftUI

struct AccountDetailsView: View {
    var body: some View {
        NavigationView() {
            VStack(spacing:10){
                
                //Top Header
                VStack(spacing:31){
                    Text("Account Details")
                        .font(.custom("DMSans-Bold", size: 20))
                        .foregroundColor(Color(.black))
                    
                   
                    
                    //Item List
                    VStack(spacing:31){
                        HStack(){
                            Text("Full Name")
                                .font(.custom("DMSans-Regular", size: 16))
                            Spacer()
                            Text("John Doe")
                                .font(.custom("DMSans-Regular",size : 13))
                            
                            Image(systemName: "chevron.right")
                        }
                        
                        
                        
                        HStack(){
                            Text("Email")
                                .font(.custom("DMSans-Regular", size: 16))
                            Spacer()
                            Text("jdoe@gmail.com")
                                .font(.custom("DMSans-Regular",size : 13))
                            
                            Image(systemName: "chevron.right")
                        }
                        
                        HStack(){
                            Text("Phone Number")
                                .font(.custom("DMSans-Regular", size: 16))
                            Spacer()
                            Text("+11234567890")
                                .font(.custom("DMSans-Regular",size : 13))
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding()
            
        }
        
    }
        
    }


struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView()
    }
}
