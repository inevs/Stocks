import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var stateController: StateController
    @State private var addingDepot = false

    var body: some View {
        NavigationView {
            Content(depots: $stateController.portfolio.depots, newDepot: { self.addingDepot = true }, deleteDepots: deleteDepots)
        }
        .sheet(isPresented: $addingDepot) {
            NavigationView {
                NewDepotView()
            }
            .environmentObject(stateController)
        }
    }
    
    func deleteDepots(atIndexSet indexSet: IndexSet) {
        stateController.deleteDepots(atIndexSet: indexSet)
    }
}

extension PortfolioView {
    struct Content: View {
        @Binding var depots: [Depot]
        let newDepot: () -> Void
        let deleteDepots: (IndexSet)->Void
        
        var body: some View {
            List {
                ForEach(depots) { depot in
                    NavigationLink(destination: DepotView(depot: depot)) {
                        HStack {
                            Text(depot.name)
                            Spacer()
                            Text(depot.currentValue.string())
                        }
                    }
                }
                .onMove(perform: move(fromOffsets:toOffset:))
                .onDelete(perform: deleteDepots)
                Spacer()
                TotalRow(depots: depots)
            }
            .navigationTitle(Text("Depots"))
            .navigationBarItems(leading: Button(action: newDepot ) {
                Image(systemName: "plus")
            }, trailing: EditButton())
        }
        
        func move(fromOffsets source: IndexSet, toOffset destination: Int) {
            depots.move(fromOffsets: source, toOffset: destination)
        }

        private func binding(for depot: Depot) -> Binding<Depot> {
            guard let depotIndex = depots.firstIndex(where: { $0.id == depot.id }) else {
                fatalError("Can't find depot in portfolio")
            }
            return $depots[depotIndex]
        }
    }
}

extension PortfolioView.Content {

    struct TotalRow: View {
        let depots: [Depot]
        
        var body: some View {
            HStack {
                Text("Total")
                Spacer()
                Text(totalValue.string())
            }
            .font(.headline)
        }
        
        var totalValue: Money {
            depots.map({$0.currentValue}).reduce(Money.zero, +)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView.Content(depots: .constant(TestData.testDepots), newDepot: {}, deleteDepots: {_ in })
        }
    }
}
