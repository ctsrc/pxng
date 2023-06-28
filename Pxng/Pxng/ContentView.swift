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
    // Timestamp of last update of Player 1 paddle Y acceleration
    @State var p1YAccelUpdateTimestamp: Optional<Date> = nil;
    // Velocity of Player 1 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p1YVelocity = 0.0;
    // Offset of Player 1 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p1YOffset = 0.0;
    
    // Acceleration of Player 2 paddle Y coordinate, in range [-0.5, 0.5].
    @State var p2YAcceleration = 0.0;
    // Timestamp of last update of Player 2 paddle Y acceleration
    @State var p2YAccelUpdateTimestamp: Optional<Date> = nil;
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
                        if let p1YAccelUpdateTimestampPrev = p1YAccelUpdateTimestamp {
                            print("P1 drag gesture \(value)")
                            print("P1 drag gesture time \(value.time)")
                            let timedelta = value.time.timeIntervalSinceReferenceDate - p1YAccelUpdateTimestampPrev.timeIntervalSinceReferenceDate;
                            print("timedelta \(timedelta)")
                            p1YAcceleration = (value.location.y / viewHeight) - 0.5;
                            print("P1 drag Y acceleration \(p1YAcceleration)")
                            p1YVelocity += p1YAcceleration * timedelta;
                            print("P1 Y velocity \(p1YVelocity)")
                        }
                        p1YAccelUpdateTimestamp = value.time;
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
                        if let p2YAccelUpdateTimestampPrev = p2YAccelUpdateTimestamp {
                            print("P2 drag gesture \(value)")
                            print("P2 drag gesture time \(value.time)")
                            let timedelta = value.time.timeIntervalSinceReferenceDate - p2YAccelUpdateTimestampPrev.timeIntervalSinceReferenceDate;
                            print("timedelta \(timedelta)")
                            p2YAcceleration = (value.location.y / viewHeight) - 0.5;
                            print("P2 drag Y acceleration \(p2YAcceleration)")
                            p2YVelocity += p2YAcceleration * timedelta;
                            print("P2 Y velocity \(p2YVelocity)")
                        }
                        p2YAccelUpdateTimestamp = value.time;
                    })
                    .onEnded({ _ in
                        p2YAcceleration = 0.0;
                        print("P2 drag Y acceleration \(p2YAcceleration)")
                    })
                )
            
            // P1 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: paddleWidth * 2.0, y: viewHeight / 2.0)
                .foregroundStyle(.red)
            
            // P2 paddle
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: viewWidth - paddleWidth * 2.0, y: viewHeight / 2.0)
                .foregroundStyle(.blue)
            
            // Ball
            Circle().frame(width: ballDiam, height: ballDiam, alignment: .center)
                .position(x: viewWidth / 2.0, y: viewHeight / 2.0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
