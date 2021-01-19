import SwiftUI

enum ActiveSheet: Identifiable {
    case edit

    var id: Int {
        hashValue
    }
}

struct PortfolioView: View {
    @EnvironmentObject var stateController: StateController
    @State private var addingDepot = false

    var body: some View {
        NavigationView {
            Content(depots: $stateController.depots, newDepot: { self.addingDepot = true }, deleteDepots: deleteDepots)
        }
        .sheet(isPresented: $addingDepot) {
            NavigationView {
                NewDepotView()
            }
            .environmentObject(self.stateController)
            
        }
    }
    
    func deleteDepots(atIndexSet indexSet: IndexSet) {
        self.stateController.deleteDepots(atIndexSet: indexSet)
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
                        DepotListRow(depot: depot)
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
    }
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PortfolioView.Content(depots: .constant(testDepots), newDepot: {}, deleteDepots: {_ in })
        }
    }
}
