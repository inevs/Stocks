import Foundation

struct SecurityQuote {
    let symbol: String
    let currentPrice: Money
    let changePercentage: Decimal
    let changeAbsolute: Money
}

protocol FinanceAPIProtocol {
    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuote], NetworkError>)->())
}

struct FinanceAPI: FinanceAPIProtocol {
    static var shared: FinanceAPIProtocol = AlphaFinanceAPI()

    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuote], NetworkError>) -> ()) {
        Self.shared.getQuotesForSymbols(symbols: symbols, completion: completion)
    }

}