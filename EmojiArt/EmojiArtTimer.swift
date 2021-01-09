//
//  EmojiArtTimer.swift
//  EmojiArt
//
//  Created by Pascal Hostettler on 09.01.21.
//

import Foundation
import SwiftUI

struct EmojiArtTimer: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @ObservedObject var document: EmojiArtDocument
    @State private var counter: Int = 0
    
    @State private var isCounting: Bool = true
    


    
    
    var body: some View {
            Text("\(counter)")
                .onReceive(timer) { time in
                    if isCounting{
                        counter += 1
                    }
                    else {
                        self.timer.upstream.connect().cancel()

                    }
                }
            
        

    }
}


