//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Abhisha Nirmalathas on 7/11/2022.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject{
    static let emojis = ["🐝", "🦋", "🐛", "🐞", "🐌", "🐜", "🪲", "🦟", "🪱", "🕸", "🍀", "🌴"]
    @Published private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 4){ pairIndex in emojis[pairIndex]}
    
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    
    // MARK: - Intent(s)
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
}
