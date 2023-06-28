//
//  ContentView.swift
//  Pxng
//
//  Created by Erik N on 28/06/2023.
//

import SwiftUI

class Player: ObservableObject {
    let name: String;
    
    // Paddle Y coordinate offset, in range [-0.5, 0.5].
    @Published var paddleYOffset: Float64 = 0.0;
    
    init(name: String) {
        self.name = name
    }
    
    func setPaddleYOffset (value: Float64) {
        paddleYOffset = value
    }
}

class Game: ObservableObject {
    @Published var p1 = Player(name: "P1");
    @Published var p2 = Player(name: "P2");
    @Published var timedelta = 0.5;
    
    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
    }
         
    @objc func step(displaylink: CADisplayLink) {
        timedelta = displaylink.targetTimestamp - displaylink.timestamp;
    }
}

struct ContentView: View {
    @ObservedObject var game = Game();
    
    init () {
        game.createDisplayLink()
    }
    
    var body: some View {
        GeometryReader { geom in
            let viewHeight = geom.size.height;
            let viewWidth = geom.size.width;
            
            let paddleHeight = viewHeight / 2.0;
            let paddleWidth = viewWidth / 40.0;
            
            let ballDiam = viewWidth / 20.0;
            
            let playerTouchAreaWidth = viewWidth / 3.0;
            let playerTouchAreaHeight = viewHeight;
            
            let p1PaddleYPosition = viewHeight / 2.0 + viewHeight * game.p1.paddleYOffset;
            let p2PaddleYPosition = viewHeight / 2.0 + viewHeight * game.p2.paddleYOffset;
            
            // P1 touch area
            Rectangle()
                .frame(width: playerTouchAreaWidth, height: playerTouchAreaHeight, alignment: .center)
                .position(x: 0.5 * playerTouchAreaWidth, y: viewHeight / 2.0)
                .foregroundStyle(.red)
                .opacity(0.1)
                .gesture(DragGesture()
                    .onChanged({ value in
                        let p1YOffset = (value.location.y / viewHeight) - 0.5;
                        game.p1.setPaddleYOffset(value: p1YOffset)
                    })
                )
            
            // P2 touch area
            Rectangle()
                .frame(width: playerTouchAreaWidth, height: playerTouchAreaHeight, alignment: .center)
                .position(x: viewWidth - 0.5 * playerTouchAreaWidth, y: viewHeight / 2.0)
                .foregroundStyle(.blue)
                .opacity(0.1)
                .simultaneousGesture(DragGesture()
                    .onChanged({ value in
                        let p2YOffset = (value.location.y / viewHeight) - 0.5;
                        game.p2.setPaddleYOffset(value: p2YOffset)
                    })
                )
            
            // P1 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: paddleWidth * 2.0, y: p1PaddleYPosition)
                .foregroundStyle(.red)
            
            // P2 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: viewWidth - paddleWidth * 2.0, y: p2PaddleYPosition)
                .foregroundStyle(.blue)
            
            // Ball
            Circle().frame(width: ballDiam, height: ballDiam, alignment: .center)
                .position(x: viewWidth / 2.0, y: viewHeight / 2.0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
