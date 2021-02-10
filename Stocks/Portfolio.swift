import Foundation

struct Portfolio: Codable {
    var depots: [Depot]
    var securities: [Security]
    
    init(depots: [Depot] = []) {
        self.depots = depots
        self.securities = []
    }
    
    mutating func addDepot(named name: String, withCash cash: String) {
        let depot = Depot(name: name, initialBalance: Money(from: cash))
        depots.append(depot)
    }
    
    mutating func deleteDepots(atIndexSet indexSet: IndexSet) {
        indexSet.forEach { index in
            depots.remove(at: index)
        }
    }
    
    mutating func addCashTransaction(_ transaction: CashTransaction, toDepot depot: Depot) {
        guard let depotIndex = depots.firstIndex(where: { $0.id == depot.id }) else { return }
        depots[depotIndex].addCashTransaction(transaction)
    }

    mutating func addOrderTransaction(_ transaction: OrderTransaction, toDepot depot: Depot) {
        let securityIndex = securities.first(where: { $0.id == transaction.security.id })
        if securityIndex == nil {
            securities.append(transaction.security)
        }
        guard let depotIndex = depots.firstIndex(where: { $0.id == depot.id }) else { return }
        depots[depotIndex].addOrderTransaction(transaction)
    }

}
    
    
    
    
