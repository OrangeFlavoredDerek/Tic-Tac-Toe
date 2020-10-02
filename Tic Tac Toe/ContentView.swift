//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Derek Chan on 2020/10/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var moves: [String] = Array(repeating: "", count: 9)
    @State var isPlaying: Bool = true
    @State var gameOver: Bool = false
    @State var msg: String = ""
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), alignment: .center, spacing: 15) {
                ForEach(0..<9, id: \.self) { index in
                    ZStack {
                        Color.blue
                        Color.white
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(width: getWidth(), height: getWidth(), alignment: .center)
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    .onTapGesture(count: 1, perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            if moves[index] == "" {
                                moves[index] = isPlaying ? "X" : "O"
                                isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        .onChange(of: moves, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text("Winner"), message: Text(msg), dismissButton: .destructive(Text("Play Again"), action: {
                withAnimation(Animation.easeIn(duration: 0.5)) {
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        })
    }
    
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / 3
    }
    
    func checkWinner() {
        if checkMoves(player: "X") {
            msg = "Player X Win !"
            gameOver.toggle()
        } else if checkMoves(player: "O") {
            msg = "Player O Win !"
            gameOver.toggle()
        } else {
            let status = moves.contains {(value) -> Bool in
                return value == ""
            }
            
            if !status {
                msg = "Tied"
                gameOver.toggle()
            }
        }
    }
    
    func checkMoves(player: String) -> Bool {
//        Horizontal Moves
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player {
                return true
            }
        }
//        Vertical Moves
        for i in 0...2 {
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player {
                return true
            }
        }
        
//        Checking Diagoanl
        if moves[0] == player && moves[4] == player && moves[8] == player {
            return true
        } else if moves[2] == player && moves[4] == player && moves[6] == player {
            return true
        }
        return false
    }
}
