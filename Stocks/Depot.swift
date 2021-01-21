import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    var cash: Money
    var securityAllocations: [SecurityAllocation]
    
    init(id: UUID = UUID(), name: String, cash: Money, securityAllocations: [SecurityAllocation] = []) {
        self.id = id
        self.name = name
        self.cash = cash
        self.securityAllocations = securityAllocations
    }
    
    mutating func addSecurityAllocation(withData data: SecurityAllocation.Data) {
        guard let securityAllocationIndex = securityAllocations.firstIndex(where: { $0.security.symbol == data.symbol }) else {
            let securityAllocation = SecurityAllocation(from: data)
            securityAllocations.append(securityAllocation)
            return
        }
        securityAllocations[securityAllocationIndex].amount += Decimal(from: data.amount)

    }
}

extension Depot {
    var currentValue: Money {
        cash
    }
}

extension Depot {
    struct Data {
        var name: String = ""
        var cash: String = "0.00"
    }
    
    init(from data: Data) {
        self.id = UUID()
        self.name = data.name
        self.cash = Money(from: data.cash)
        self.securityAllocations = []
    }
    
    var data: Data {
        return Data(name: name, cash: cash.amount.string(precision: 2))
    }
    
    mutating func update(from data: Data) {
        name = data.name
        cash = Money(from: data.cash)
    }
}
