import Foundation

struct Security: Codable {
    let id: UUID
    let symbol: String
    let name: String
    var price: Money
    
    init(id: UUID = UUID(), symbol: String, name: String, price: Money = Money(amount: 0.0)) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.price = price
    }
}
