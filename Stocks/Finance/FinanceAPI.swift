import Foundation

struct SecurityQuote {
    let symbol: String
    let currentPrice: Money
    let changePercentage: Decimal
    let changeAbsolute: Money
}

struct SearchResult: Identifiable {
    let symbol: String
    let name: String

    var id: String { symbol }
}

protocol FinanceAPIProtocol {
    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>) -> Void)
    func searchSecurities(query: String, completion: @escaping (Result<[SearchResult], NetworkError>) -> Void)
}

struct FinanceAPI: FinanceAPIProtocol {
//    static var shared: FinanceAPIProtocol = AlphaFinanceAPI()
    static var shared: FinanceAPIProtocol = YahooFinanceAPI()

    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>) -> ()) {
        Self.shared.getQuoteForSymbol(symbol: symbol, completion: completion)
    }

    func searchSecurities(query: String, completion: @escaping (Result<[SearchResult], NetworkError>) -> Void) {
    }
}
