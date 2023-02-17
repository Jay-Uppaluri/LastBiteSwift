import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("Splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
