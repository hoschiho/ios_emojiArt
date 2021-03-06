//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Pascal Hostettler on 02.01.21.
//

import SwiftUI
import Combine


class EmojiArtDocument: ObservableObject, Hashable, Identifiable
{
    var defaultsKey: String = ""
    
    @Published var bgColor: Color
    @Published var counter = 0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let palette: String = "🤏🦏💥🍥🦼"


    @Published private var emojiArt: EmojiArt
        
    private var autosaveCancellable: AnyCancellable?
    
    private var autosaveCancellableForColor: AnyCancellable?

    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
        
        bgColor = Color(UserDefaults.standard.colorForKey(key: "\(self.defaultsKey)color") ?? UIColor(Color(.white)))

        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: self.defaultsKey)
        }
        fetchBackgroundImageData()
        
        self.counter = UserDefaults.standard.integer(forKey: "\(self.defaultsKey)counter")
        
        autosaveCancellableForColor = $bgColor.sink { bgColor in
            UserDefaults.standard.setColor(color: UIColor(bgColor), forKey: "\(self.defaultsKey)color")
        }


    }
    
    var timerCancellable: Cancellable?

    
    func startTimer() {
            timerCancellable = timer.sink(
                receiveValue: { result in
                    UserDefaults.standard.set(self.counter, forKey: "\(self.defaultsKey)counter")
                }
            )
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        
        func stopTimer() {
            timerCancellable?.cancel()
            self.timer.upstream.connect().cancel()
        }
    
    
    
    
    @Published private(set) var backgroundImage: UIImage?

    
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis}
    
    
    // MARK - Intent(s)
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
        emojiArt.backgroundURL = newValue?.imageURL
        fetchBackgroundImageData()
        }
    }
    

    
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel()
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
