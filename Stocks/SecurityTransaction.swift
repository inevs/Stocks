import Foundation

struct SecurityTransaction: Codable, Identifiable {
    enum Kind: String, Codable, CaseIterable {
        case buy, sell
    }
    
    let id: UUID
    let date: Date
    let security: Security
    let amount: Decimal
    let kind: Kind
    let fees: Money
    let tax: Money
    let price: Money
}
