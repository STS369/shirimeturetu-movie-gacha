import SwiftUI

enum Tab {
    case gacha
    case deck
}

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                LaunchPromptView()
            }
            .tag(Tab.gacha)
            .tabItem { Label("ガチャ", systemImage: "sparkles") }

            NavigationStack {
                HistoryDeckView()
            }
            .tag(Tab.deck)
            .tabItem { Label("履歴・デッキ", systemImage: "rectangle.stack") }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(FavoriteStore())
        .environmentObject(HistoryStore())
        .environmentObject(DeckStore())
}
