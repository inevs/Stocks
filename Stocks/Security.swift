import Foundation

struct Security: Codable, Identifiable, Hashable, Equatable {
    let id: UUID
    let symbol: String
    let name: String
    var latestPrice: Money
    
    init(symbol: String, name: String) {
        self.id = UUID()
        self.symbol = symbol
        self.name = name
        self.latestPrice = Money.zero
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    static func ==(lhs: Security, rhs: Security) -> Bool {
        return rhs.symbol == lhs.symbol
    }
}

extension Security {
    struct SecurityData {
        var symbol: String
        var name: String
    }

}
