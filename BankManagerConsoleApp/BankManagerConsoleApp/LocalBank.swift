//
//  LocalBank.swift
//  BankManagerConsoleApp
//
//  Created by 윤재웅 on 2021/05/04.
//

import Foundation

final class LocalBank: Bankable {
    var bankWindow = OperationQueue()
    var workTime = Double.zero
    var taskList: [LocalBankTask] = []
    var headBank: HeadBank?
    
    func serveClient() {
        bankWindow.maxConcurrentOperationCount = 3
        let totalCustomer = customerNumber()
        for waitNumber in 1...totalCustomer {
            let randomClient = acceeptRandomClient()
            let randomCredit = randomClient.0
            let randomWorkType = randomClient.1
            let localBankTask = LocalBankTask()
            localBankTask.waitingNumber = UInt(waitNumber)
            localBankTask.creditRate = randomCredit
            localBankTask.workType = randomWorkType
            assignPriority(localBankTask)
            taskList.append(localBankTask)
            localBankTask.completionBlock = {
                guard let typeOfTask = localBankTask.workType else { return }
                self.workTime += typeOfTask.duration
            }
        }
        bankWindow.addOperations(taskList, waitUntilFinished: true)
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(totalCustomer)명이며, 총 업무시간은\(String(format: "%.2f", workTime))초 입니다.")
    }
    
    private func customerNumber() -> Int {
        return Int.random(in: 10...30)
    }
    
    private func acceeptRandomClient() -> (CreditRating, WorkType) {
        guard let creditRate = CreditRating.allCases.shuffled().first,
              let typeOfWork = WorkType.allCases.shuffled().first else {
            fatalError()
        }
        
        return (creditRate, typeOfWork)
    }
    
    private func assignPriority(_ task: LocalBankTask) {
        guard let rate = task.creditRate else { return }
        switch rate {
        case .vvip:
            return task.queuePriority = .high
        case .vip:
            return task.queuePriority = .normal
        case .normal:
            return task.queuePriority = .low
        }
    }
}
