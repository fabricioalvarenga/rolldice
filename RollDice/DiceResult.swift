//
//  DiceResult.swift
//  RollDice
//
//  Created by FABRICIO ALVARENGA on 15/11/22.
//

import Foundation

struct DiceResult: Identifiable, Codable {
    var id = UUID()
    let dices: Int
    let sides: Int
    let results: [Int]
}
