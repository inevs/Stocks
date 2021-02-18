import SwiftUI

struct SearchSecurityView: View {
    @Binding var orderData: OrderTransaction.Data
    @State var searchResult: [SearchSecurityResult] = []
    
    var body: some View {
        Content(searchResult: searchResult, searchTextChange: searchTextChange(text:))
    }
    
    func searchTextChange(text: String) {
        searchResult = [
            SearchSecurityResult(symbol: "AAPL", name: "Apple"),
            SearchSecurityResult(symbol: "APC", name: "Apple Xetra"),
        ]
    }
}

extension  SearchSecurityView {
    struct Content: View {
        @State var searchText = ""
        var searchResult: [SearchSecurityResult]
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
                SearchSecurityResult(symbol: "AAPL", name: "Apple"),
                SearchSecurityResult(symbol: "APC", name: "Apple Xetra"),
            ], searchTextChange: {_ in })
        }
    }
}

struct SearchSecurityResult: Identifiable {
    let symbol: String
    let name: String
    var id: String { symbol }
}
