import Foundation

struct YahooFinanceAPI: FinanceAPIProtocol {
    var regionParameters: [QueryParameter] {
        [
            QueryParameter(parameter: "region", value: "DE"),
            QueryParameter(parameter: "lang", value: "de")
        ]
    }

    var headerFields: [HttpHeaderField] {
        [
            HttpHeaderField(field: "X-RapidAPI-Key", value: getKeyFor(name: "api-key") ?? ""),
            HttpHeaderField(field: "X-RapidAPI-Host", value: getKeyFor(name: "api-host") ?? "")
        ]
    }

    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>) -> ()) {
        let queryParameters = [
            QueryParameter(parameter: "symbols", value: symbol)
        ]
        let allQueryParameters = queryParameters + regionParameters

        let url = "https://yahoo-finance-low-latency.p.rapidapi.com/v6/finance/quote"
        Webservice.shared.loadResource(url: url, headerFields: headerFields, queryParameter: allQueryParameters) { (result: Result<YahooQuoteAPIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let quotes = response.quoteResponse.result
                let securityQuotes = quotes.map { SecurityQuote(symbol: $0.symbol, currentPrice: Money(amount: $0.regularMarketPrice), changePercentage: $0.regularMarketChangePercent, changeAbsolute: Money(amount: $0.regularMarketChange)) }
                if let securityQuote = securityQuotes.first {
                    completion(.success(securityQuote))
                } else {
                    completion(.failure(.unknown))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchSecurities(query: String, completion: @escaping (Result<[SearchResult], NetworkError>) -> Void) {
        let queryParameters = [
            QueryParameter(parameter: "query", value: query)
        ]
        let allQueryParameters = queryParameters + regionParameters

        let url = "https://yahoo-finance-low-latency.p.rapidapi.com/v6/finance/autocomplete"
        Webservice.shared.loadResource(url: url, headerFields: headerFields, queryParameter: allQueryParameters) { (result: Result<YahooSearchAPIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let results = response.resultSet.results.map {
                    $0.convertToSearchResult()
                }
                completion(.success(results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getKeyFor(name: String) -> String? {
        if let url = Bundle.main.url(forResource: "api-keys", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                if let yahooDict = dict["yahoo"] as? [String:String] {
                    return yahooDict[name]
                } else {
                    return nil
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
}

fileprivate struct YahooQuoteAPIResponse: Decodable {
    let quoteResponse: YahooQuoteResponse
}

struct YahooQuoteResponse: Decodable {
    let result: [YahooQuote]
    let error: String?
}

struct YahooQuote: Decodable {
    let symbol: String
    let regularMarketPrice: Decimal
    let financialCurrency: String
    let regularMarketChange: Decimal
    let regularMarketChangePercent: Decimal
}

fileprivate struct YahooSearchAPIResponse: Decodable {
    let resultSet: ResultSet

    enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }

    struct ResultSet: Decodable {
        let query: String
        let results: [Result]

        enum CodingKeys: String, CodingKey {
            case query = "Query"
            case results = "Result"
        }

        struct Result: Decodable {
            let exch: String
            let exchDisp: String
            let name: String
            let symbol: String
            let type: String
            let typeDisp: String

            func convertToSearchResult() -> SearchResult {
                SearchResult(symbol: symbol, name: name)
            }
        }
    }
}

