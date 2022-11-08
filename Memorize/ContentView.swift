//
//  ContentView.swift
//  Memorize
//
//  Created by Abhisha Nirmalathas on 2/11/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: EmojiMemoryGame
    @State var emojiCount = 12
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                gameBody
                gameControls
            }
            .padding(.horizontal)
        }
        deckBody
    }
    
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool{
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card:EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) {card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else{
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding((4))
                //.identity is don't do any animation
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation{
                            game.choose(card)
                        }
                }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)){
                card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle"){
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart"){
            withAnimation{
                dealt = []
                game.restart()
            }
            
        }
    }
    
    var gameControls: some View {
        HStack{
            shuffle
            Spacer()
            restart
        }.padding()
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double  = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader(content: {geometry in
            ZStack {
               Pie(startAngle: Angle(degrees:0-90), endAngle: Angle(degrees:110-90)).opacity(0.5).padding(5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                    .font(Font.system(size:DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame();
        ContentView(game: game)
            .preferredColorScheme(.dark)
        ContentView(game: game)
            .preferredColorScheme(.light)
    }
}
