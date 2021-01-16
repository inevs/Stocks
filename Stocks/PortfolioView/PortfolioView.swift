import SwiftUI

struct PortfolioView: View {
    @Binding var depots: [Depot]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @State private var newDepotData = Depot.Data()
    let saveAction: () -> Void

    var body: some View {
        List {
            ForEach(depots) { depot in
                NavigationLink(destination: DepotView(depot: binding(for: depot))) {
                    DepotListRow(depot: depot)
                }
            }
            .onDelete { indices in
                depots.remove(atOffsets: indices)
            }
            Spacer()
            TotalRow(depots: depots)
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
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    private func binding(for depot: Depot) -> Binding<Depot> {
        guard let depotIndex = depots.firstIndex(where: { $0.id == depot.id }) else {
            fatalError("Can't find depot in array")
        }
        return $depots[depotIndex]
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView(depots: .constant(testDepots), saveAction: {})
        }
    }
}
