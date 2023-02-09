import SwiftUI

struct NotificationsView: View {
    @State private var isPushNotificationsEnabled = false

    var body: some View {
        VStack() {
            
        
            Text("Notifications")
                .font(.custom("DMSans-Bold", size: 20))
                
            
            HStack {
                Text("Push Notifications")
                    .font(.custom("DMSans-Bold", size: 16))
                Spacer()

                Toggle(isOn: $isPushNotificationsEnabled) {
                }
                .tint(Color("AccentColor"))
            }
            HStack {
                Text("Enable to receive important update, promotions, and more")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 87.0)
                    .font(.custom("DMSans-Bold", size: 13))
                    
                Spacer()
            }
            
            Spacer()
                
        }
        .padding()
        

    }
}


struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
    
}
