//
//  ContentView.swift
//  ActorBankingApp
//
//  Created by Jason Sanchez on 7/7/24.
//

import SwiftUI



struct ContentView: View {
    @StateObject private var bankAccountVM = BankAccountViewModel(balance: 500)
    let queue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    
    var body: some View {
        VStack {
            Button("Withdraw") {
                queue.async {
                    bankAccountVM.withdraw(200)
                }
                
                queue.async {
                    bankAccountVM.withdraw(500)
                }
            }
            Text("\(bankAccountVM.currentBalance ?? 0.0)")
            
            List(bankAccountVM.transactions, id: \.self) { transaction in
                Text(transaction)
            }
        }
    }
}

#Preview {
    ContentView()
}
