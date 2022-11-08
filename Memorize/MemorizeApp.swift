//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Abhisha Nirmalathas on 2/11/2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
