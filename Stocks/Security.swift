import Foundation

struct Security: Codable, Identifiable {
    let id: UUID
    let symbol: String
    let name: String
    
    init(symbol: String, name: String) {
        self.id = UUID()
        self.symbol = symbol
        self.name = name
    }
}

extension Security {
    struct SecurityData {
        var symbol: String
        var name: String
    }

}
