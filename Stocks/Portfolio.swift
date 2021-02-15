import Foundation

struct Portfolio: Codable {
    var depots: [Depot]
    
    init(depots: [Depot] = []) {
        self.depots = depots
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
        guard let depotIndex = depots.firstIndex(where: { $0.id == depot.id }) else { return }
        depots[depotIndex].addOrderTransaction(transaction)
    }

    mutating func update(security: Security, withPrice price: Money) {
        for index in 0..<depots.count {
            depots[index].update(security: security, withPrice: price)
        }
    }

    var allSecurities: Set<Security> {
        var securitySet = Set<Security>()
        for depot in depots {
            let securities = depot.securities
            for security in securities {
                securitySet.insert(security)
            }
        }
        return securitySet
    }
}
    
    
    
    
