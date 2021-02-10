import Foundation

struct Security: Codable, Identifiable, Hashable {
    let id: UUID
    let symbol: String
    let name: String
    
    init(symbol: String, name: String) {
        self.id = UUID()
        self.symbol = symbol
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
}

extension Security {
    struct SecurityData {
        var symbol: String
        var name: String
    }

}
