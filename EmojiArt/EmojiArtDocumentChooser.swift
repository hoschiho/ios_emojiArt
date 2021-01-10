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
                        ZStack {
                            EmojiArtPreview(document: document)
                            VStack(alignment: .leading) {
                                Text(self.store.name(for: document))
                                    .padding(.top, 5)
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                        }
                        .padding(7)





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

                            
                        
                    }
                )
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

struct EmojiArtPreview: View {
    @ObservedObject var document: EmojiArtDocument
    
    
    init(document: EmojiArtDocument) {
        self.document = document
    }

    var body: some View {


            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    if self.isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                            }

                        }
                    }

                .border(Color.black)

                .clipped()

                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                    }
                }
            .zIndex(-1)
    }
    
    var isLoading: Bool {
        return document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    

    private func zoomToFit (_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStatePanOffset = .zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

