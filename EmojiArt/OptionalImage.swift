//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Pascal Hostettler on 04.01.21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
