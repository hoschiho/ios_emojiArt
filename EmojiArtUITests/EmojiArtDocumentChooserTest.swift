//
//  EmojiArtDocumentChooserTest.swift
//  EmojiArtDocumentChooserTest
//
//  Created by Hanna Lisa Franz on 14.01.21.
//

import XCTest

class EmojiArtDocumentChooserTest: XCTestCase {

    func testEditName() throws {
           let app = XCUIApplication()
           app.launch()
           app.buttons["plus"].tap()
           app.buttons["Edit"].tap()
            
            app.tables.cells.element(boundBy: 0).tap()
           
        
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()
                app.keys["Löschen"].tap()


                
                app.keys["C"].tap()
                app.keys["o"].tap()
                app.keys["w"].tap()
                
                app.buttons["Done"].tap()
           
                XCTAssertTrue(app.tables.cells.element(boundBy: 0).label=="Cow")

       }
   }

