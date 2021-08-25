//
//  LocalBank.swift
//  BankManagerConsoleApp
//
//  Created by James,Fezz on 2021/05/04.
//

import Foundation

final class LocalBank {
    private var bankWindow: OperationQueue
    private var workTime = Double.zero
    private var depositTaskList: [DepositTask] = []
    private var loanTaskList: [LoanTask] = []
    private var headBank: HeadBank
    private var totalClient: Int
    
    init(numberOfBankTellers bankTeller: Int, numberOfTotalClient totalClient: Int) {
        self.bankWindow = OperationQueue()
        bankWindow.maxConcurrentOperationCount = bankTeller
        self.totalClient = totalClient
        headBank = HeadBank()
    }
    
    func serveClient(completion: (String) -> ()) {
        for waitNumber in 1...totalClient {
            let waitLineNumber = UInt(waitNumber)
            let bankingType = randomizeTaskType()
            assignTask(bankingType, waitLineNumber)
        }
        bankWindow.addOperations(depositTaskList + loanTaskList, waitUntilFinished: true)
        completion(String(format: "%.2f", workTime))
    }
    
    private func randomizeTaskType() -> WorkType {
        guard let banking = WorkType.allCases.randomElement() else {
            return .deposit
        }
        return banking
    }
    
    private func assignTask(_ banking: WorkType, _ waitNumber: UInt) {
        switch banking {
        case .deposit:
            guard let task = DepositTask(waitNumber) else {
                return
            }
            depositTaskList.append(task)
            task.completionBlock = {
                self.workTime += task.workType.duration
            }
        case .loan:
            guard let task = LoanTask(waitNumber, headBank) else {
                return
            }
            loanTaskList.append(task)
            task.completionBlock = {
                self.workTime += task.workType.duration
            }
        }
    }
}
