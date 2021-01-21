import Foundation

class StateController: ObservableObject {
    @Published var depots: [Depot]
    
    private let storageController = StorageController()
    
    init(depots: [Depot] = []) {
        if depots.count == 0 {
            self.depots = storageController.fetchDepots()
        } else {
            self.depots = depots
        }
    }
    
    func addDepot(named name: String, withCash cash: String) {
        let depot = Depot(name: name, cash: Money(from: cash))
        depots.append(depot)
        storageController.save(depots)
    }
    
    func deleteDepots(atIndexSet indexSet: IndexSet) {
        indexSet.forEach { index in
            depots.remove(at: index)
        }
        storageController.save(depots)
    }
}
