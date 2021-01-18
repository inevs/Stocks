import SwiftUI

enum ActiveSheet: Identifiable {
    case edit

    var id: Int {
        hashValue
    }
}

struct PortfolioView: View {
    @EnvironmentObject var depotData: DepotData
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingSheet = false
    @State private var newDepotData = Depot.Data()
    let saveAction: () -> Void

    var body: some View {
        List {
            ForEach(depotData.depots) { depot in
                NavigationLink(destination: DepotView(depot: depot)) {
                    DepotListRow(depot: depot)
                }
            }
            .onDelete { indices in
                depotData.depots.remove(atOffsets: indices)
            }
            Spacer()
            TotalRow(depots: depotData.depots)
        }
        .navigationTitle(Text("Depots"))
        .navigationBarItems(trailing: Button(action: { isPresentingSheet = true }) {
            Image(systemName: "plus")
        })
        .listStyle(InsetGroupedListStyle())
        .fullScreenCover(isPresented: $isPresentingSheet) {
            editView
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    var editView: some View {
        NavigationView {
            DepotEditView(depotData: $newDepotData)
                .navigationBarItems(
                    leading: Button("Dismiss") { isPresentingSheet = false },
                    trailing: Button("Save") {
                        let newDepot = Depot(from: newDepotData)
                        depotData.depots.append(newDepot)
                        isPresentingSheet = false
                    }
                )
        }
    }
    
    private func binding(for depot: Depot) -> Binding<Depot> {
        guard let depotIndex = depotData.depots.firstIndex(where: { $0.id == depot.id }) else {
            fatalError("Can't find depot in array")
        }
        return $depotData.depots[depotIndex]
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView(saveAction: {})
                .environmentObject(DepotData(depots: testDepots))
        }
    }
}
