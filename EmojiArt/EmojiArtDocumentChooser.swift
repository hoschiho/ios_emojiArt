//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Pascal Hostettler on 08.01.21.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    @State private var editMode: EditMode = .inactive
    @State private var showGridView = false

    
    var body: some View {
    
        if showGridView == true {
            
        NavigationView {
                Grid(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                                    .navigationBarTitle(self.store.name(for:document))
                    ) {
                        //VIEW ANZEIGEN
                        EditableText(self.store.name(for: document), isEditing: self.editMode.isEditing) { name in
                            self.store.setName(name, for: document)
                        }

                    }
                }
                .navigationBarTitle(self.store.name)
                .navigationBarItems(leading: Button(action: {
                    self.store.addDocument()
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }),
                trailing:
                    HStack {
                    
                        Button(action: {
                            self.showGridView = false
                        }, label: {
                            Image(systemName: "list.dash").imageScale(.large)
                        })
                        EditButton()
                    }
                )
                .environment(\.editMode, $editMode)
        }.animation(.default)
            } else {
                NavigationView {
                List {
                    ForEach(store.documents) { document in
                        NavigationLink(destination: EmojiArtDocumentView(document: document)
                                        .navigationBarTitle(self.store.name(for:document))
                        ) {
                            EditableText(self.store.name(for: document), isEditing: self.editMode.isEditing) { name in
                                self.store.setName(name, for: document)
                            }

                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { self.store.documents[$0] }.forEach { document in
                            self.store.removeDocument(document)
                        }
                    }
                }
            
            .navigationBarTitle(self.store.name)
            .navigationBarItems(leading: Button(action: {
                self.store.addDocument()
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            }),
            trailing:
                HStack {
                    Button(action: {
                        self.showGridView = true
                    }, label: {
                        Image(systemName: "rectangle.split.3x3").imageScale(.large)
                    })
                    EditButton()
                }
            )
            .environment(\.editMode, $editMode)
        }
                .animation(.default)

    }

}
}
