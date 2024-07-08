//
//  ContentView.swift
//  ActorBankingApp
//
//  Created by Jason Sanchez on 7/7/24.
//

import SwiftUI

@MainActor
class BankAccountViewModel: ObservableObject {
    
    private var bankAccount: BankAccount
    @Published var currentBalance: Double?
    @Published var transactions: [String] = []
    
    init(balance: Double) {
        bankAccount = BankAccount(balance: balance)
    }
    
    func withdraw(_ amount: Double) async {
        await bankAccount.withdraw(amount)
        self.currentBalance = await self.bankAccount.getBalance()
        self.transactions = await self.bankAccount.transactions
    }
}

actor BankAccount {
    private(set) var balance: Double
    private(set) var transactions: [String] = []
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func getBalance() -> Double {
        return balance
    }
    
    func withdraw(_ amount: Double) {
        
        if balance >= amount {
            let processingTime = UInt32.random(in: 0...3)
            print("[Withdraw] processing for \(amount) \(processingTime) seconds")
            transactions.append("[Withdraw] processing for \(amount) \(processingTime) seconds")
            sleep(processingTime)
            print("Withdrawing \(amount) from account")
            transactions.append("Withdrawing \(amount) from account")
            
            balance -= amount
            
            print("Balance is \(balance)")
            transactions.append("Balance is \(balance)")
        }
    }
}

struct ContentView: View {
    @StateObject private var bankAccountVM = BankAccountViewModel(balance: 500)
    let queue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
    
    var body: some View {
        VStack {
            Button("Withdraw") {
                Task.detached {
                    await bankAccountVM.withdraw(500)
                }
                Task.detached {
                    await bankAccountVM.withdraw(300)
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
