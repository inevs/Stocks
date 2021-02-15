import SwiftUI

@main
struct StocksApp: App {
    @StateObject var stateController = StateController()
    
    var body: some Scene {
        WindowGroup {
            PortfolioView()
                .environmentObject(stateController)
            .onAppear() {
                stateController.updateQuotes()
            }
        }
    }
}
