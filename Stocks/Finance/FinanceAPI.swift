import Foundation

struct SecurityQuotes {
    let symbol: String
    let currentPrice: Money
    let changePercentage: Decimal
    let changeAbsolute: Money
}

protocol FinanceAPIProtocol {
    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuotes], NetworkError>)->())
}

struct FinanceAPI: FinanceAPIProtocol {
    static var shared: FinanceAPIProtocol = YahooFinanceAPI()

    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuotes], NetworkError>) -> ()) {
        Self.shared.getQuotesForSymbols(symbols: symbols, completion: completion)
    }

}