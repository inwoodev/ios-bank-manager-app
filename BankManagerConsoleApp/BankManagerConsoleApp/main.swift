//
//  BankManagerConsoleApp - main.swift
//  Created by James,Fezz. 
// 

import Foundation

final class main {
    func openBank() {
        BankInterface().displayMenu()
        switch inputMenuNumber() {
        case 1:
            let totalClient = Int.random(in: 10...30)
            LocalBank(numberOfBankTellers: 3, numberOfTotalClient: totalClient).serveClient() { workTime in
                print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(totalClient)명이며, 총 업무시간은 \(workTime)초 입니다.")
            }
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

