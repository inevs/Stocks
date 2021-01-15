import SwiftUI

struct DepotEditView: View {
    @Binding var depotData: Depot.Data
    
    var body: some View {
        List {
            Section(header: Text("Depot Data")) {
                TextField("Name", text: $depotData.name)
                TextField("Cash", text: $depotData.cash)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct DepotEditView_Previews: PreviewProvider {
    static var previews: some View {
        DepotEditView(depotData: .constant(comdirect.data))
    }
}
