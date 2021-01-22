//
//  TransactionHistoryView.swift
//  Stocks
//
//  Created by Sven Günther on 22.01.21.
//

import SwiftUI

struct TransactionHistoryView: View {
    let depot: Depot
    
    var transactionsSortedByDate: [CashTransaction] {
        depot.cashTransactions.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        Content(transactions: transactionsSortedByDate)
            .navigationBarTitle(Text(depot.name), displayMode: .inline)
    }
}

extension TransactionHistoryView {
    struct Content: View {
        let transactions: [CashTransaction]

        var body: some View {
            List(transactions) { transaction in
                HStack {
                    Text(transaction.date.transactionFormat)
                    Text(transaction.beneficiary)
                    Spacer()
                    Text(transaction.amount.string())
                }
            }
        }
    }
}

struct TransactionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionHistoryView.Content(transactions: [TestData.cashTransaction])
        }
    }
}
