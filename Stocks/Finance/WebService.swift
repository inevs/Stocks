import Foundation

struct HttpHeaderField {
    let field: String
    let value: String
}

struct QueryParameter {
    let parameter: String
    let value: String
}

enum NetworkError: Error {
    case badURL, badRequest, unknown
}

struct Webservice {
    static var shared = Webservice()

    func loadResource<A: Decodable>(url: String, headerFields: [HttpHeaderField], queryParameter: [QueryParameter], completion: @escaping (Result<A, NetworkError>)->()) {
        let queryParams = buildQueryParametersFor(parameters: queryParameter)
        guard let url = URL(string: "\(url)\(queryParams)") else { return }

        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        for headerField in headerFields {
            request.addValue(headerField.value, forHTTPHeaderField: headerField.field)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    log(data)
                    let apiResponse = try JSONDecoder().decode(A.self, from: data)
                    print(apiResponse)
                    DispatchQueue.main.async {
                        completion(.success(apiResponse))
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(.failure(.badRequest))
                    }
                }
            } else if let error = error {
                print (error)
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }

    func buildQueryParametersFor(parameters: [QueryParameter]) -> String {
        if parameters.count == 0 { return "" }

        let parameterValueStrings = parameters.map { "\($0.parameter)=\($0.value)" }
        let parameterValues = parameterValueStrings.joined(separator: "&")
        return "?\(parameterValues)"
    }

    func getKeyFor(name: String) -> String? {
        if let url = Bundle.main.url(forResource: "api-keys", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                return dict[name] as? String
            } catch {
                print(error)
            }
        }
        return nil
    }

    func log(_ data: Data) {
        let s = String(decoding: data, as: UTF8.self)
        print(s)
    }

}
