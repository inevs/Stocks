import Foundation

struct AlphaFinanceAPI: FinanceAPIProtocol {
    var headerFields: [HttpHeaderField] {
        [
            HttpHeaderField(field: "X-RapidAPI-Key", value: getKeyFor(name: "api-key") ?? ""),
            HttpHeaderField(field: "X-RapidAPI-Host", value: getKeyFor(name: "api-host") ?? "")
        ]
    }

    func getQuoteForSymbol(symbol: String, completion: @escaping (Result<SecurityQuote, NetworkError>) -> ()) {
        let queryParameters = [
            QueryParameter(parameter: "symbol", value: symbol),
            QueryParameter(parameter: "function", value: "GLOBAL_QUOTE"),
            QueryParameter(parameter: "datatype", value: "json")
        ]
        let url = "https://alpha-vantage.p.rapidapi.com/query"
        Webservice.shared.loadResource(url: url, headerFields: headerFields, queryParameter: queryParameters) { (result: Result<AlphaQuoteAPIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let quote = response.quote.mapToSecurityQuote()
                completion(.success(quote))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchSecurities(query: String, completion: @escaping (Result<[SearchResult], NetworkError>) -> Void) {
        let queryParameters = [
            QueryParameter(parameter: "keywords", value: query),
            QueryParameter(parameter: "function", value: "SYMBOL_SEARCH"),
            QueryParameter(parameter: "datatype", value: "json")
        ]
        let url = "https://alpha-vantage.p.rapidapi.com/query"
        Webservice.shared.loadResource(url: url, headerFields: headerFields, queryParameter: queryParameters) { (result: Result<AlphaSearchAPIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let searchResults = response.matches.map { $0.convertToSearchResult() }
                completion(.success(searchResults))
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
                if let alphaDict = dict["alpha"] as? [String:String] {
                    return alphaDict[name]
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

struct AlphaSearchAPIResponse: Decodable {
    let matches: [Matches]

    enum CodingKeys: String, CodingKey {
        case matches = "bestMatches"
    }

    struct Matches: Decodable {
        let symbol: String
        let name: String
        let type: String
        let region: String
        let marketOpen: String
        let marketClose: String
        let timezone: String
        let currency: String
        let matchScore: String

        enum CodingKeys: String, CodingKey {
            case symbol = "1. symbol"
            case name = "2. name"
            case type = "3. type"
            case region = "4. region"
            case marketOpen = "5. marketOpen"
            case marketClose = "6. marketClose"
            case timezone = "7. timezone"
            case currency = "8. currency"
            case matchScore = "9. matchScore"
        }

        func convertToSearchResult() -> SearchResult {
            SearchResult(symbol: symbol, name: name)
        }
    }
}

fileprivate struct AlphaQuoteAPIResponse: Decodable {
    let quote: GlobalQuote

    enum CodingKeys: String, CodingKey {
        case quote = "Global Quote"
    }

    struct GlobalQuote: Decodable {
        let symbol: String
        let open: String
        let high: String
        let low: String
        let price: String
        let volume: String
        let latestTradingDay: String
        let previousClose: String
        let change: String
        let changePercent: String
        enum CodingKeys: String, CodingKey {
            case symbol = "01. symbol"
            case open = "02. open"
            case high = "03. high"
            case low = "04. low"
            case price = "05. price"
            case volume = "06. volume"
            case latestTradingDay = "07. latest trading day"
            case previousClose = "08. previous close"
            case change = "09. change"
            case changePercent = "10. change percent"
        }

        func mapToSecurityQuote() -> SecurityQuote {
            SecurityQuote(symbol: symbol, currentPrice: Money(from: price), changePercentage: Decimal(from: changePercent), changeAbsolute: Money(from: change))
        }
    }
}

