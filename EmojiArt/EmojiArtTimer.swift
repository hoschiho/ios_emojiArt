//
//  EmojiArtTimer.swift
//  EmojiArt
//
//  Created by Pascal Hostettler on 09.01.21.
//

import Foundation
import SwiftUI

struct EmojiArtTimer: View {

    @ObservedObject var document: EmojiArtDocument

    
    var body: some View {
        let counter = document.counter

            Text("\(counter)")

            
        

    }
}


