import Foundation

struct SecurityAllocation: Identifiable, Codable {
    let id: UUID
    var amount: Decimal
    var security: Security
    
    init(id: UUID = UUID(), amount: Decimal, security: Security) {
        self.id = id
        self.amount = amount
        self.security = security
    }
}

extension SecurityAllocation {
    struct Data {
        var amount: String = ""
        var symbol: String = ""
        var name: String = ""
    }
    
    init(from data: Data) {
        self.id = UUID()
        self.amount = Decimal(from: data.amount)
        self.security = Security(symbol: data.symbol, name: data.name)
    }
    
    var data: Data {
        return Data(amount: amount.string(), symbol: security.symbol, name: security.name)
    }
    
    mutating func update(from data: Data) {
        amount = Decimal(from: data.amount)
        security = Security(symbol: data.symbol, name: data.name)
    }

}
