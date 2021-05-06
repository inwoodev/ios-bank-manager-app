//
//  HeadBank.swift
//  BankManagerConsoleApp
//
//  Created by 윤재웅 on 2021/05/04.
//

import Foundation

final class HeadBank {
    static let shared = HeadBank()
    var bankWindow = OperationQueue()
    let semaphore = DispatchSemaphore(value: 1)
    
    private init() {
        self.bankWindow.maxConcurrentOperationCount = 1
    }
    
    func serveClient(number waitNumber: UInt, rating credit: CreditRating, type taskType: WorkType) {
        let clientInformation = HeadBankTask(number: waitNumber, rating: credit, type: taskType)
        semaphore.wait()
        bankWindow.addOperation(clientInformation)
        semaphore.signal()
        clientInformation.waitUntilFinished()
    }
}
