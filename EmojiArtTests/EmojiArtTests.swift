//
//  EmojiArtTests.swift
//  EmojiArtTests
//
//  Created by Hanna Lisa Franz on 14.01.21.
//

import XCTest
@testable import EmojiArt


class EmojiArtTests: XCTestCase {

    func testAddEmoji_whenTextIsEmpty_doesNothing() throws {
        let emojiArtDocument = EmojiArtDocument.init()
        emojiArtDocument.addEmoji("", at: CGPoint(x:10, y:10), size: 1)
        
    }

    func testAddEmoji_whenTextSizeGreaterThan1_doesNothing() throws{
            let emojiArtDocument = EmojiArtDocument.init()
            //check if app crashes. it should just do nothing
            emojiArtDocument.addEmoji("🐄", at: CGPoint(x: 10, y: 10), size: 100)
    }
        
    func testAddEmoji_whenInputValid_incrementsEmojiId() throws{
        //TODO
        let emojiArtDocument = EmojiArtDocument.init()
        emojiArtDocument.addEmoji("🐄", at: CGPoint(x: 10, y: 10), size: 1)
        
        let prevId = emojiArtDocument.emojis.first(where: { $0.text=="🐄" })?.id
        emojiArtDocument.addEmoji("🦋", at: CGPoint(x: 10, y: 10), size: 1)
        
        let thisId = emojiArtDocument.emojis.first(where: { $0.text=="🦋" })?.id
        XCTAssertTrue(prevId!+1==thisId!)
    }
}
