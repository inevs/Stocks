import SwiftUI

struct SearchSecurityView: View {
    @Binding var orderData: OrderTransaction.Data
    @State var searchResult: [SearchResult] = []
    let financeAPI = FinanceAPI.shared
    
    var body: some View {
        Content(searchResult: searchResult, searchTextChange: searchTextChange(text:))
    }
    
    func searchTextChange(text: String) {
        financeAPI.searchSecurities(query: text) { result in
            switch result {
            case .success(let matches):
                searchResult = matches
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension  SearchSecurityView {
    struct Content: View {
        @State var searchText = ""
        var searchResult: [SearchResult]
        var searchTextChange: (String) -> Void

        var body: some View {
            List {
                TextField("Symbol", text: $searchText)
                    .onChange(of: searchText, perform: searchTextChange)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                ForEach(searchResult) { result in
                    HStack {
                        Text(result.name)
                        Spacer()
                        Text(result.symbol)
                    }
                }
            }
        }
    }
}

struct SearchSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchSecurityView.Content(searchResult: [
                SearchResult(symbol: "AAPL", name: "Apple"),
                SearchResult(symbol: "APC", name: "Apple Xetra"),
            ], searchTextChange: {_ in })
        }
    }
}

struct SearchSecurityResult: Identifiable {
    let symbol: String
    let name: String
    var id: String { symbol }
}
