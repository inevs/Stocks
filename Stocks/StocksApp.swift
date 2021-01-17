import SwiftUI

@main
struct StocksApp: App {
    @ObservedObject var depotData = DepotData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PortfolioView() {
                    depotData.save()
                }
                .environmentObject(depotData)
            }
            .onAppear {
                depotData.load()
            }
        }
    }
}
