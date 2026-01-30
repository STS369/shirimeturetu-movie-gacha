import SwiftUI

@main
struct Day3HomeworkApp: App {
    @StateObject private var favoriteStore = FavoriteStore()
    @StateObject private var historyStore = HistoryStore()
    @StateObject private var deckStore = DeckStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favoriteStore)
                .environmentObject(historyStore)
                .environmentObject(deckStore)
        }
    }
}
