import SwiftUI

@main
struct StocksApp: App {
    @State private var depots = testDepots
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PortfolioView(depots: $depots)
            }
        }
    }
}
