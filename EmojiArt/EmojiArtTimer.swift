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
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: document.counter)
        Text("\(h) Hours, \(m) Minutes, \(s) Seconds")
    }
}


func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
  return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}
