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
                let quote = response.quote.mapToSecuritQuote()
                completion(.success(quote))
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

        func mapToSecuritQuote() -> SecurityQuote {
            SecurityQuote(symbol: symbol, currentPrice: Money(from: price), changePercentage: Decimal(from: changePercent), changeAbsolute: Money(from: change))
        }
    }
}