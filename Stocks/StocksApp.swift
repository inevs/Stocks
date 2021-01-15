import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PortfolioView(depots: testDepots)
            }
        }
    }
}
