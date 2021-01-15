import Foundation

struct Depot {
    let name: String
    var cash: Money
    
    init(name: String, cash: Money) {
        self.name = name
        self.cash = cash
    }
}

extension Depot: Identifiable {
    var id: String { name }
}

extension Depot {
    var currentValue: Money {
        cash
    }
}
