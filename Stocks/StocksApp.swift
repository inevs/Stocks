import SwiftUI

@main
struct StocksApp: App {
    @ObservedObject var data = DepotData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PortfolioView(depots: $data.depots) {
                    data.save()
                }
            }
            .onAppear {
                data.load()
            }
        }
    }
}
