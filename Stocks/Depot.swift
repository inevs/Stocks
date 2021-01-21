import Foundation

struct Depot: Identifiable, Codable {
    let id: UUID
    var name: String
    var balance: Money
    
    init(id: UUID = UUID(), name: String, initialBalance balance: Money) {
        self.id = id
        self.name = name
        self.balance = balance
    }
}

extension Depot {
    var currentValue: Money {
        balance
    }
}
