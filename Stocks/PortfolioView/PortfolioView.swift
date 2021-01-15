import SwiftUI

struct PortfolioView: View {
    let depots: [Depot]
    
    var body: some View {
        List {
            ForEach(depots) { depot in
                DepotListRow(depot: depot)
            }
        }
        .navigationTitle(Text("Depots"))
        .listStyle(InsetGroupedListStyle())
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView(depots: testDepots)
        }
    }
}
