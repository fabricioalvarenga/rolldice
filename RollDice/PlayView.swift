//
//  PlayView.swift
//  RollDice
//
//  Created by FABRICIO ALVARENGA on 12/11/22.
//

import SwiftUI

struct PlayView: View {
    @Binding var reset: Bool
    @State private var showingAllResults = false
    @State private var dices = 0
    @State private var sides = 0
    @State private var angle = 0.0
    @State private var rolledNumbers = [Int]()
    @State private var diceResults = [DiceResult]()
    @State private var timer = Timer.publish(every: 1000, on: .main, in: .common).autoconnect()
    
    private let colors: [Color] = [.red, .green, .blue].shuffled()
    private let savePath = FileManager.documentsDirectory.appending(component: "DiceResult.json")
   
    init(reset: Binding<Bool>) {
        self._reset = reset
        
        do {
            let data = try Data(contentsOf: savePath)
            let results = try JSONDecoder().decode([DiceResult].self, from: data)
            _diceResults = State(initialValue: results)
        } catch {
            diceResults = []
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if !diceResults.isEmpty {
                    VStack {
                        Text("Last result")
                            .font(.callout.bold())
                            .padding()
                        
                        HStack {
                            ForEach(0..<diceResults[diceResults.startIndex].dices, id: \.self) { index in
                                ZStack {
                                    Polygon(sides: Double(diceResults[diceResults.startIndex].sides), scale: 1)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(colors[index])
                                        .padding(5)
                                    
                                    Text("\(diceResults[diceResults.startIndex].results[index])")
                                        .foregroundColor(.white)
                                        .font(.headline.bold())
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    ForEach(0..<dices, id: \.self) { index in
                        ZStack {
                            Polygon(sides: Double(sides), scale: 1)
                                .frame(width: 80, height: 80)
                                .foregroundColor(colors[index])
                                .padding(5)
                                .rotation3DEffect(Angle(degrees: angle), axis: (x: 0, y: 1, z: 0))
                            
                            Text("\(rolledNumbers[index])")
                                .foregroundColor(.white)
                                .font(.title.bold())
                                .rotation3DEffect(Angle(degrees: angle), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                
                Button {
                    resetGame()
                    startTimer()
                } label: {
                    Text("Roll")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(.purple)
                        .cornerRadius(10)
                }
                
                if !diceResults.isEmpty {
                    Spacer()
                }
            }
            .onAppear {
                stopTimer()
                
                if reset {
                    loadDicesAndSides()
                    resetGame()
                }
            }
            .onReceive(timer) { time in
                for i in 0..<dices {
                    rolledNumbers[i] = Int.random(in: 0...sides)
                }
                
                angle += 10.0001
                
                if angle > 360 {
                    angle = 0.0001
                    stopTimer()
                    saveResult()
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Results") {
                        showingAllResults.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAllResults) {
                AllResultsView()
            }
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    func loadDicesAndSides() {
        dices = UserDefaults.standard.integer(forKey: "NumberOfDices")
        sides = UserDefaults.standard.integer(forKey: "NumberOfFaces")
        
        if dices <= 0 { dices = 1 }
        if sides <= 0 || !sides.isMultiple(of: 2) { sides = 4 }
    }
    
   func resetGame() {
        rolledNumbers.removeAll()
        rolledNumbers.append(contentsOf: Array<Int>(repeating: 0, count: dices))
        
        reset = false
    }
    
    func saveResult() {
        let diceResult = DiceResult(dices: dices, sides: sides, results: rolledNumbers)
        
        withAnimation {
            diceResults.insert(diceResult, at: diceResults.startIndex)
        }
        
        do {
            let data = try JSONEncoder().encode(diceResults)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save result: \(error.localizedDescription)")
        }
    }
}
