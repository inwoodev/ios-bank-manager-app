//
//  LocalBankOperation.swift
//  BankManagerConsoleApp
//
//  Created by James,Fezz on 2021/05/09.
//

import Foundation

extension LocalBank {
    class DepositTask: Operation, LocalBankTaskable {
        var waitingNumber: UInt
        var creditRate: CreditRating
        var workType: WorkType
        
        init?(_ number: UInt) {
            guard let credit = CreditRating.allCases.shuffled().first else {
                return nil
            }
            self.waitingNumber = number
            self.creditRate = credit
            self.workType = .deposit
            super.init()
            super.queuePriority = creditRate.priority
        }
        
        override func main() {
            work()
        }
        
        func work() {
            print("\(waitingNumber)번 \(creditRate)고객 \(workType.description) 시작")
            Thread.sleep(forTimeInterval: workType.duration)
            print("\(waitingNumber)번 \(creditRate)고객 \(workType.description) 완료")
        }
    }
    class LoanTask: Operation, LocalBankTaskable {
        var waitingNumber: UInt
        var creditRate: CreditRating
        var workType: WorkType
        var headBank: HeadBank
        
        init?(_ number: UInt, _ headBank: HeadBank) {
            guard let credit = CreditRating.allCases.shuffled().first else {
                return nil
            }
            self.waitingNumber = number
            self.creditRate = credit
            self.workType = .loan
            self.headBank = headBank
            super.init()
            super.queuePriority = creditRate.priority
        }
        
        override func main() {
            work()
        }
        
        func work() {
            let loanProcess = WorkType.LoanProcess.self
            print("\(waitingNumber)번 \(creditRate)고객 \(loanProcess.loanExecution) 시작")
            headBank.serveClient(number: waitingNumber, rating: creditRate)
            print("\(waitingNumber)번 \(creditRate)고객 \(loanProcess.loanExecution) 완료")
        }
    }
}
