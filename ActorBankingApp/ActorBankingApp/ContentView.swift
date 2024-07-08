//
//  ContentView.swift
//  ActorBankingApp
//
//  Created by Jason Sanchez on 7/7/24.
//

import SwiftUI

class BankAccountViewModel: ObservableObject {
    
    private var bankAccount: BankAccount
    @Published var currentBalance: Double?
    @Published var transactions: [String] = []
    
    init(balance: Double) {
        bankAccount = BankAccount(balance: balance)
    }
    
    func withdraw(_ amount: Double) {
        bankAccount.withdraw(amount)
        DispatchQueue.main.async {
            self.currentBalance = self.bankAccount.getBalance()
            self.transactions = self.bankAccount.transactions
        }
    }
}

class BankAccount {
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
