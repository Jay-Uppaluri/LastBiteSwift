// SETTINGS MAIN SCREEN
//

import SwiftUI

struct HelpCenter: View {
    var body: some View {
        VStack(spacing:32){
            
            //Top Header
            VStack(spacing:20){
                HStack(){
                    Image(systemName: "arrow.left")
                    Spacer()
                    Text("Help Center")
                        .font(.custom("DMSans-Bold", size: 20))
                        .foregroundColor(Color("Body"))
                    Spacer()
                    //workaround until i figure out the best way to do this
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                    
                }
                //Subheader
                Spacer().frame(height:30)
                VStack(spacing:4){
                        Text("How can we help you?")
                            .font(.custom("DMSans-Bold", size: 20))
                        Text("Choose a topic below so we can help you as quickly as we can.")
                        .font(.custom("DMSans-Regular", size: 16))
                        .multilineTextAlignment(.center)
                }
                
                Spacer().frame(height:30)
                
                //Item List
                VStack(spacing:20){
                    
                    menuItem(menutext: "How does Last Bite work?")
                    
                    menuItem(menutext: "I have a problem with my order")
                    
                    menuItem(menutext: "Join Last Bite")
                    
                    

                }
            }
            
            Spacer()
            
            }
        .padding()
            
        }
        
        
        
    }


struct HelpCenter_Previews: PreviewProvider {
    static var previews: some View {
        HelpCenter()
    }
}


