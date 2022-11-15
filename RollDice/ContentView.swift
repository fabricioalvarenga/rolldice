//
//  ContentView.swift
//  RollDice
//
//  Created by FABRICIO ALVARENGA on 12/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var reset = true
    
    var body: some View {
        TabView {
            PlayView(reset: $reset)
                .tabItem {
                    Label("Play", systemImage: "dice")
                }
            
            SettingsView { reset in self.reset = reset }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
