import SwiftUI

struct DepotView: View {
    let depot: Depot
    
    var body: some View {
        VStack {
            List {
                ChangesView()
                Spacer()
                HStack {
                    Text("50 Apple")
                    Spacer()
                    Text("104.99 EUR")
                }
                HStack {
                    Text("6 Tesla")
                    Spacer()
                    Text("825.17 EUR")
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle(Text(depot.name), displayMode: .inline)
    }
}

struct DepotView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepotView(depot: comdirect)
        }
    }
}

struct ChangesView: View {
    var body: some View {
        HStack {
            HStack {
                VStack {
                    Text("Today")
                    HStack {
                        Text("+237,00 EUR")
                        Text("+10 %")
                    }
                    .font(.caption)
                }
                Divider()
                VStack {
                    Text("This Month")
                    HStack {
                        Text("+437,00 EUR")
                        Text("+11 %")
                    }
                    .font(.caption)
                }
                Divider()
                VStack {
                    Text("This year")
                    HStack {
                        Text("+1237,00 EUR")
                        Text("+13 %")
                    }
                    .font(.caption)
                }
            }
        }
    }
}
