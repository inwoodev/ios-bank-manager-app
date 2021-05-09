//
//  BankManagerConsoleApp - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

final class main {
    func openBank() {
        BankInterface().displayMenu()
        switch inputMenuNumber() {
        case 1:
            LocalBank(numberOfBankTellers: 3).serveClient()
        case 2:
            exit(0)
        default:
            print("오류 발생")
            exit(1)
        }
    }

    private func inputMenuNumber() -> Int {
        guard let optionalInput = readLine(), let inputNumber = Int(optionalInput) else {
            return 0
        }
        return inputNumber
    }
}

main().openBank()

