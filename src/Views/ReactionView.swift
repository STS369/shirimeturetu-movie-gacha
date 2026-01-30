import SwiftUI

struct ReactionView: View {
    @ObservedObject var vm: PopularViewModel
    @EnvironmentObject private var favoriteStore: FavoriteStore
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var deckStore: DeckStore

    @State private var goResult = false
    @State private var message: String = ""

    private let reactionSeconds: Double = 3.0

    private let candidates = [
        "なるほど、それはすごいですね",
        "なるほど、そいつはいかれてますね",
        "なるほど、そんなことよりも勉強してください！！"
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text(message)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            message = candidates.randomElement() ?? candidates[0]
            Task {
                try? await Task.sleep(nanoseconds: UInt64(reactionSeconds * 1_000_000_000))
                goResult = true
            }
        }
        .navigationDestination(isPresented: $goResult) {
            RecommendResultView(vm: vm)
                .environmentObject(favoriteStore)
                .environmentObject(historyStore)
                .environmentObject(deckStore)
        }
    }
}
