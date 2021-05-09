//
//  LocalBank.swift
//  BankManagerConsoleApp
//
//  Created by 윤재웅 on 2021/05/04.
//

import Foundation

final class LocalBank {
    var bankWindow = OperationQueue()
    var workTime = Double.zero
    var taskList: [LocalBankTask] = []
    var headBank: HeadBank?
    
    func serveClient(numberOfBankTellers bankTeller: Int) {
        bankWindow.maxConcurrentOperationCount = bankTeller
        let totalCustomer = receiveClient()
        for waitNumber in 1...totalCustomer {
            let waitLineNumber = UInt(waitNumber)
            guard let localBankTask = LocalBankTask(waitLineNumber) else {
                return
            }
            assignPriority(localBankTask)
            taskList.append(localBankTask)
            localBankTask.completionBlock = {
                self.workTime += localBankTask.workType.duration
            }
        }
        bankWindow.addOperations(taskList, waitUntilFinished: true)
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(totalCustomer)명이며, 총 업무시간은\(String(format: "%.2f", workTime))초 입니다.")
    }
    
    private func receiveClient() -> Int {
        return Int.random(in: 10...30)
    }
}

extension LocalBank {
    class LocalBankTask: Operation {
        let waitingNumber: UInt
        let creditRate: CreditRating
        let workType: WorkType
        init?(_ number: UInt) {
            guard let credit = CreditRating.allCases.shuffled().first,
                  let work = WorkType.allCases.shuffled().first else {
                return nil
            }
            
            self.waitingNumber = number
            self.creditRate = credit
            self.workType = work
            super.init()
            super.queuePriority = creditRate.priority
        }

        override func main() {
            work(number: waitingNumber, rating: creditRate, type: workType)
        }
        
        private func work(number waitNumber: UInt, rating credit: CreditRating, type taskType: WorkType) {
            switch taskType {
            case .deposit:
                print("\(waitNumber)번 \(credit)고객 \(taskType.description) 시작")
                Thread.sleep(forTimeInterval: taskType.duration)
                print("\(waitNumber)번 \(credit)고객 \(taskType.description) 완료")
            case .loan:
                let loanProcess = WorkType.LoanProcess.self
                print("\(waitNumber)번 \(credit)고객 \(loanProcess.loanExecution) 시작")
                HeadBank.shared.serveClient(number: waitNumber, rating: credit, type: taskType)
                print("\(waitNumber)번 \(credit)고객 \(loanProcess.loanExecution) 완료")
            }
        }
    }
}
