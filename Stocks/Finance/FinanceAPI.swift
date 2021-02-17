import Foundation

struct SecurityQuote {
    let symbol: String
    let currentPrice: Money
    let changePercentage: Decimal
    let changeAbsolute: Money
}

protocol FinanceAPIProtocol {
    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>)->())
}

struct FinanceAPI: FinanceAPIProtocol {
    static var shared: FinanceAPIProtocol = AlphaFinanceAPI()

    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>) -> ()) {
        Self.shared.getQuoteForSymbol(symbol: symbol, completion: completion)
    }

}