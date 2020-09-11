import SwiftUI

/// Application Entry Point (setup the initial views and environment)
struct ContentView: View {
    var body: some View {
        SessionView().environmentObject(SessionService.default)
    }
}
