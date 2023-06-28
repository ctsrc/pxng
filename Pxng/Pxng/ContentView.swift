//
//  ContentView.swift
//  Pxng
//
//  Created by Erik N on 28/06/2023.
//

import SwiftUI

class Player: ObservableObject {
    let name: String;
    
    // Paddle Y acceleration, in range [-250, 250].
    @Published var paddleYAcceleration: Float64 = 0.0;
    // Paddle Y velocity, in range [-50, 50].
    @Published var paddleYVelocity: Float64 = 0.0;
    // Paddle Y coordinate offset, in range [-0.5, 0.5].
    @Published var paddleYOffset: Float64 = 0.0;
    
    init(name: String) {
        self.name = name
    }
    
    func setYAcceleration (value: Float64) {
        //print("\(name) prev paddle Y acceleration \(paddleYAcceleration)")
        paddleYAcceleration = value * 500.0
        //print("\(name) curr paddle Y acceleration \(paddleYAcceleration)")
    }
    
    func step (timedelta: Float64) {
        var paddleYVelocityNew = paddleYVelocity + paddleYAcceleration * timedelta;
        if paddleYVelocityNew > 50 {
            paddleYVelocityNew = 50;
        } else if paddleYVelocityNew < -50 {
            paddleYVelocityNew = -50;
        }
        //print("paddleYVelocityNew \(paddleYVelocityNew)")
        
        paddleYVelocity = paddleYVelocityNew;
        
        var paddleYOffsetNew = paddleYOffset + paddleYVelocity * timedelta;
        if paddleYOffsetNew > 0.5 {
            paddleYOffsetNew = 0.5;
        } else if paddleYOffsetNew < -0.5 {
            paddleYOffsetNew = -0.5;
        }
        //print("paddleYOffsetNew \(paddleYOffsetNew)")
        
        paddleYOffset = paddleYOffsetNew;
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
        //print("timedelta: \(timedelta)")
        p1.step(timedelta: timedelta)
        p2.step(timedelta: timedelta)
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
                        //print("P1 drag gesture \(value)")
                        let p1YAcceleration = (value.location.y / viewHeight) - 0.5;
                        game.p1.setYAcceleration(value: p1YAcceleration)
                    })
                    .onEnded({ _ in
                        game.p1.setYAcceleration(value: 0.0)
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
                        //print("P2 drag gesture \(value)")
                        let p2YAcceleration = (value.location.y / viewHeight) - 0.5;
                        game.p2.setYAcceleration(value: p2YAcceleration)
                    })
                    .onEnded({ _ in
                        game.p2.setYAcceleration(value: 0.0)
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
