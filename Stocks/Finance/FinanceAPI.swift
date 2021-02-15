import Foundation

struct SecurityQuotes {
    let symbol: String
    let currentPrice: Money
    let changePercentage: Decimal
    let changeAbsolute: Money
}

protocol FinanceAPIProtocol {
    func getQuotesForSymbol(symbol: String, completion: @escaping (Result<SecurityQuotes, NetworkError>)->())
    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuotes], NetworkError>)->())
}

struct FinanceAPI: FinanceAPIProtocol {
    static var shared: FinanceAPIProtocol = YahooFinanceAPI()

    func getQuotesForSymbol(symbol: String, completion: @escaping (Result<SecurityQuotes, NetworkError>) -> ()) {
        Self.shared.getQuotesForSymbol(symbol: symbol, completion: completion)
    }

    func getQuotesForSymbols(symbols: [String], completion: @escaping (Result<[SecurityQuotes], NetworkError>) -> ()) {
        Self.shared.getQuotesForSymbols(symbols: symbols, completion: completion)
    }

}