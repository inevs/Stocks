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

extension Depot {
    struct Data {
        var name: String = ""
        var cash: String = "0.00"
    }
    
    init(from data: Data) {
        self.id = UUID()
        self.name = data.name
        self.balance = Money(from: data.cash)
    }
    
    var data: Data {
        return Data(name: name, cash: balance.amount.string(precision: 2))
    }
    
    mutating func update(from data: Data) {
        name = data.name
        balance = Money(from: data.cash)
    }
}
