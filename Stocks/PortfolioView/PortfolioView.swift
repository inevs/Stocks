import SwiftUI

enum ActiveSheet: Identifiable {
    case edit, search

    var id: Int {
        hashValue
    }
}

struct PortfolioView: View {
    @Binding var depots: [Depot]
    @Environment(\.scenePhase) private var scenePhase
    @State private var presentedSheet: ActiveSheet?
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
        .navigationBarItems(leading: Button(action: { presentedSheet = .search }) {
            Image(systemName: "magnifyingglass")
        },
            trailing: Button(action: { presentedSheet = .edit }) {
            Image(systemName: "plus")
        })
        .listStyle(InsetGroupedListStyle())
        .fullScreenCover(item: $presentedSheet) { sheet in
            switch sheet {
            case .edit:
                editView
            case .search:
                searchView
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    var editView: some View {
        NavigationView {
            DepotEditView(depotData: $newDepotData)
                .navigationBarItems(
                    leading: Button("Dismiss") { presentedSheet = nil },
                    trailing: Button("Save") {
                        let newDepot = Depot(from: newDepotData)
                        depots.append(newDepot)
                        presentedSheet = nil
                    }
                )
        }
    }
    
    var searchView: some View {
        NavigationView {
            SearchSecurityView()
                .navigationBarTitle(Text("Search Security"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: { presentedSheet = nil }) {Text("Dismiss")})
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
