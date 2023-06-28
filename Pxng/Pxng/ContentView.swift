//
//  ContentView.swift
//  Pxng
//
//  Created by Erik N on 28/06/2023.
//

import SwiftUI

struct ContentView: View {
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
                        print("P1 drag \(value)")
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
                        print("P2 drag \(value)")
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
    }
}
