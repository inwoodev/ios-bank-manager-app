//
//  LocalBankTask.swift
//  BankManagerConsoleApp
//
//  Created by James,Fezz on 2021/05/09.
//

import Foundation

protocol LocalBankTaskable {
    var waitingNumber: UInt { get set }
    var creditRate: CreditRating { get set }
    func work()
}
