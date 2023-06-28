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
            
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: paddleWidth * 2.0, y: viewHeight / 2.0)
            
            Circle().frame(width: ballDiam, height: ballDiam, alignment: .center)
                .position(x: viewWidth / 2.0, y: viewHeight / 2.0)
            
            Rectangle().frame(width: paddleWidth, height: paddleHeight, alignment: .center)
                .position(x: viewWidth - paddleWidth * 2.0, y: viewHeight / 2.0)
        }
    }
}
