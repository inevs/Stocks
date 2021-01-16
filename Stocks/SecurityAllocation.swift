import Foundation

struct SecurityAllocation: Codable {
    let id: UUID
    let amount: Decimal
    let security: Security
    
    init(id: UUID = UUID(), amount: Decimal, security: Security) {
        self.id = id
        self.amount = amount
        self.security = security
    }
}
