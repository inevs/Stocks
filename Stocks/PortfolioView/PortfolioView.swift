import SwiftUI

struct PortfolioView: View {
    @Binding var depots: [Depot]
    @State private var isPresented = false
    @State private var newDepotData = Depot.Data()
    
    var body: some View {
        List {
            ForEach(depots) { depot in
                DepotListRow(depot: depot)
            }
        }
        .navigationTitle(Text("Depots"))
        .navigationBarItems(trailing: Button(action: { isPresented = true }) {
            Image(systemName: "plus")
        })
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $isPresented) {
            NavigationView {
                DepotEditView(depotData: $newDepotData)
                    .navigationBarItems(
                        leading: Button("Dismiss") { isPresented = false },
                        trailing: Button("Save") {
                            let newDepot = Depot(from: newDepotData)
                            depots.append(newDepot)
                            isPresented = false
                        }
                    )
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView(depots: .constant(testDepots))
        }
    }
}
