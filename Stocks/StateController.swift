import Foundation

class StateController: ObservableObject {
    @Published var depots: [Depot]
    
    private let storageController = StorageController()
    
    init(depots: [Depot] = []) {
        // TODO remove
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

    func addSecurityAllocation(withData data: SecurityAllocation.Data, toDepot depot: Depot) {
        guard let depotIndex = depots.firstIndex(where: { $0.name == depot.name }) else { return }        
        depots[depotIndex].addSecurityAllocation(withData: data)
        storageController.save(depots)
    }
    
    func removeSecurityAllocation(withData data: SecurityAllocation.Data, fromDepot depot: Depot) {
        guard let depotIndex = depots.firstIndex(where: { $0.name == depot.name }) else { return }
        
        guard let securityAllocationIndex = depot.securityAllocations.firstIndex(where: { $0.security.symbol == data.symbol }) else {
            return
        }
        
        if (depot.securityAllocations[securityAllocationIndex]).amount > Decimal(from: data.amount) {
            depots[depotIndex].securityAllocations[securityAllocationIndex].amount -= Decimal(from: data.amount)
        } else {
            depots[depotIndex].securityAllocations.remove(at: securityAllocationIndex)
        }
        
        storageController.save(depots)
    }

}
