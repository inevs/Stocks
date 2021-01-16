import SwiftUI

struct TotalRow: View {
    let depots: [Depot]
    
    var body: some View {
        HStack {
            Text("Total")
            Spacer()
            Text(totalValue.string())
        }
        .font(.headline)
    }
    
    var totalValue: Money {
        depots.map({$0.currentValue}).reduce(Money.zero, +)
    }
}

struct TotalRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalRow(depots: testDepots)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/44.0/*@END_MENU_TOKEN@*/))
    }
}
