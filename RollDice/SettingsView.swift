//
//  SettingsView.swift
//  RollDice
//
//  Created by FABRICIO ALVARENGA on 12/11/22.
//

import SwiftUI

struct SettingsView: View {
    @State private var dices = 1
    @State private var sides = 4
    @State private var showingSavedMessage = false
    
    var resetGame: (Bool) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Stepper("Number of Dices: \(dices)", value: $dices, in: 1...3)
                    .font(.title2)
                Stepper("Number of Faces: \(sides)", value: $sides, in: 4...20, step: 2)
                    .font(.title2)
                
            }
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        UserDefaults.standard.set(dices, forKey: "NumberOfDices")
                        UserDefaults.standard.set(sides, forKey: "NumberOfFaces")
                        
                        showingSavedMessage.toggle()
                        resetGame(true)
                    }
                }
            }
            .onAppear {
                dices = UserDefaults.standard.integer(forKey: "NumberOfDices")
                sides = UserDefaults.standard.integer(forKey: "NumberOfFaces")
                
                if dices <= 0 { dices = 1 }
                if sides <= 0 || !sides.isMultiple(of: 2) { sides = 4 }
            }
            .alert("Changes saved", isPresented: $showingSavedMessage) {
                Button("Ok") { }
            } message: {
                Text("Your changes was saved.")
            }
        }
    }
}

struct SeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView { _ in }
    }
}
