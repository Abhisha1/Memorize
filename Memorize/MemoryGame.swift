//
//  MemoryGame.swift
//  Memorize
//
//  Created by Abhisha Nirmalathas on 7/11/2022.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards:Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly
        }
        set {
            cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    mutating func choose(_ card:Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else{
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int)-> CardContent){
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards{
            let cardContent = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex*2, content: cardContent))
            cards.append(Card(id: pairIndex*2+1, content: cardContent))
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
    
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1{
            return first
        } else {
            return nil
        }
    }
}
