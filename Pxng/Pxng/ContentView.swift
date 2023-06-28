//
//  ContentView.swift
//  Pxng
//
//  Created by Erik N on 28/06/2023.
//

import SwiftUI

struct ContentView: View {
    // Acceleration of Player 1 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p1YAcceleration = 0.0;
    // Velocity of Player 1 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p1YVelocity = 0.0;
    // Offset of Player 1 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p1YOffset = 0.0;
    
    // Acceleration of Player 2 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p2YAcceleration = 0.0;
    // Velocity of Player 2 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p2YVelocity = 0.0;
    // Offset of Player 2 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p2YOffset = 0.0;
    
    var body: some View {
        GeometryReader { geom in
            let viewHeight = geom.size.height;
            let viewWidth = geom.size.width;
            
            let paddleHeight = viewHeight / 2.0;
            let paddleWidth = viewWidth / 40.0;
            
            let ballDiam = viewWidth / 20.0;
            
            let playerTouchAreaWidth = viewWidth / 3.0;
            let playerTouchAreaHeight = viewHeight;
            
            // P1 touch area
            Rectangle()
                .frame(width: playerTouchAreaWidth, height: playerTouchAreaHeight, alignment: .center)
                .position(x: 0.5 * playerTouchAreaWidth, y: viewHeight / 2.0)
                .foregroundStyle(.red)
                .opacity(0.1)
                .gesture(DragGesture()
                    .onChanged({ value in
                        p1YAcceleration = (value.location.y / viewHeight) - 0.5;
                        print("P1 drag Y acceleration \(p1YAcceleration)")
                    })
                    .onEnded({ _ in
                        p1YAcceleration = 0.0;
                        print("P1 drag Y acceleration \(p1YAcceleration)")
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
                        p2YAcceleration = (value.location.y / viewHeight) - 0.5;
                        print("P2 drag Y acceleration \(p2YAcceleration)")
                    })
                    .onEnded({ _ in
                        p2YAcceleration = 0.0;
                        print("P2 drag Y acceleration \(p2YAcceleration)")
                    })
                )
            
            // P1 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: paddleWidth * 2.0, y: viewHeight / 2.0)
            
            // P2 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: viewWidth - paddleWidth * 2.0, y: viewHeight / 2.0)
            
            // Ball
            Circle().frame(width: ballDiam, height: ballDiam, alignment: .center)
                .position(x: viewWidth / 2.0, y: viewHeight / 2.0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
