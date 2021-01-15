import SwiftUI

struct DepotListRow: View {
    var depot: Depot
    
    var body: some View {
        HStack {
            Text(depot.name)
            Spacer()
            Text(depot.currentValue.string())
        }
    }
}

struct DepotListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DepotListRow(depot: testDepots[0])
                .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/44.0/*@END_MENU_TOKEN@*/))
        }
    }
}
