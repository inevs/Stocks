import SwiftUI

struct SecurityQueryResult: Identifiable {
    let symbol: String
    let name: String
    
    var id: String { name }
}

typealias SearchCompletionHandler = ([SecurityQueryResult]) -> Void

struct SearchSecurityView: View {
    @State private var search = ""
    @State private var searchResult: [SecurityQueryResult] = []
    let depot: Depot

    var body: some View {
        Content(depot: depot) {query, completion in
            DispatchQueue.main.async {
                completion(securitySearchResult)
            }
        }
    }
}

extension SearchSecurityView {
    struct Content: View {
        let depot: Depot
        @State private var search = ""
        @State private var searchResult: [SecurityQueryResult] = []
        let query: (String, @escaping SearchCompletionHandler) -> Void

        var body: some View {
            List {
                Section(header: Text("Search")) {
                    TextField("Name, Symbol, WKN", text: $search)
                        .onChange(of: search) { value in
                            if (value.count >= 3) {
                                query(value) { result in
                                    searchResult = result
                                }
                            }
                        }
                }
                Section {
                    ForEach(searchResult) { result in
                        NavigationLink(
                            destination: SecurityView(securityDetails: SecurityDetails(symbol: result.symbol, name: result.name), depot: depot)) {
                            VStack(alignment: .leading) {
                                Text(result.name)
                                    .font(.headline)
                                Text(result.symbol)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SearchSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchSecurityView.Content(depot: comdirect, query: {_,_ in })
                .navigationBarTitle(Text("Search Security"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {}) {Text("Dismiss")})
        }
    }
}
