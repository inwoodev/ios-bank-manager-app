//
//  HeadBank.swift
//  BankManagerConsoleApp
//
//  Created by James,Fezz on 2021/05/04.
//

import Foundation

final class HeadBank {
    var waitingNumber: UInt?
    var creditRate: CreditRating?

    var bankWindow = OperationQueue()
    let semaphore = DispatchSemaphore(value: 1)
    
    init() {
        self.bankWindow.maxConcurrentOperationCount = 1
    }
    
    func serveClient(number waitNumber: UInt, rating credit: CreditRating) {
        let clientInformation = HeadBankTask(number: waitNumber, rating: credit)
//        semaphore.wait()
        bankWindow.addOperation(clientInformation)
//        semaphore.signal()
        clientInformation.waitUntilFinished()
    }
}

extension HeadBank {
    class HeadBankTask: Operation {
        var waitingNumber: UInt
        var creditRate: CreditRating
        
        init(number waitingNumber: UInt, rating creditRate: CreditRating) {
            self.waitingNumber = waitingNumber
            self.creditRate = creditRate
        }
        
        override func main() {
            let loanProcess = WorkType.LoanProcess.self
            print("📈 \(waitingNumber)번 \(creditRate)고객 \(loanProcess.loanEvaluation) 시작")
            Thread.sleep(forTimeInterval: WorkType.loan.duration)
            print("📉 \(waitingNumber)번 \(creditRate)고객 \(loanProcess.loanEvaluation) 완료")
        }
    }
}
