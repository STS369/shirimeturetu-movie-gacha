import SwiftUI

struct RecommendResultView: View {
    @ObservedObject var vm: PopularViewModel
    @EnvironmentObject private var favoriteStore: FavoriteStore
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var deckStore: DeckStore

    @State private var showInput = false
    @State private var showHistoryDeck = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let movie = vm.movies.first {
                BigMovieCardView(
                    movie: movie,
                    isFavorite: favoriteStore.isFavorite(movie),
                    onToggleFavorite: { favoriteStore.toggle(movie) }
                )
                .padding(EdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18))
            } else {
                ContentUnavailableView("ガチャ結果がありません", systemImage: "film")
                    .foregroundStyle(.white)
            }
        }
        .navigationTitle("ガチャ結果")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showInput = true
                } label: {
                    Label("支離滅裂へ戻る", systemImage: "arrow.counterclockwise")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showHistoryDeck = true
                } label: {
                    Label("履歴・デッキ", systemImage: "rectangle.stack")
                }
            }
        }
        .onAppear {
            if let movie = vm.movies.first {
                historyStore.add(movie: movie)
            }
        }
        .fullScreenCover(isPresented: $showInput) {
            LaunchPromptView()
                .environmentObject(favoriteStore)
                .environmentObject(historyStore)
                .environmentObject(deckStore)
        }
        .sheet(isPresented: $showHistoryDeck) {
            HistoryDeckView()
                .environmentObject(historyStore)
                .environmentObject(deckStore)
        }
    }
}
