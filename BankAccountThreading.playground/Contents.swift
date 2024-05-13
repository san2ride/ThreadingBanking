import UIKit

class BankAccount {
    var balance: Double
    let lock = NSLock()
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func withdraw(_ amount: Double) {
        lock.lock()
        if balance >= amount {
            let processingTime = UInt32.random(in: 0...3)
            print("[Withdraw] processing for \(amount) \(processingTime) seconds")
            sleep(processingTime)
            print("Withdrawing \(amount) from account")
            balance -= amount
            print("Balance is \(balance)")
        }
        lock.unlock()
    }
}
let bankAccount = BankAccount(balance: 500)

let serialQueue = DispatchQueue(label: "SerialQueue")

//MARK: ConcurrentQueue
let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
concurrentQueue.async {
    bankAccount.withdraw(300)
}
concurrentQueue.async {
    bankAccount.withdraw(500)
}

/*
bankAccount.withdraw(300)
print(bankAccount.balance)
*/

