import SwiftUI

struct HistoryDeckView: View {
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var deckStore: DeckStore

    private let budget: Double = 28.0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                List {
                    Section("履歴（デッキに追加）") {
                        if historyStore.items.isEmpty {
                            Text("履歴が空です（ガチャを回すと溜まります）")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(historyStore.items) { item in
                                historyRow(item)
                            }
                        }
                    }

                    Section("デッキ（削除）") {
                        if deckItems.isEmpty {
                            Text("デッキが空です（履歴から追加してください）")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(deckItems) { item in
                                deckRow(item)
                            }

                            HStack {
                                Text("合計コスト")
                                Spacer()
                                Text(String(format: "%.1f / %.1f", deckTotalCost, budget))
                                    .font(.footnote.bold())
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("履歴・デッキ")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("デッキ全消し") { deckStore.clear() }
                }
            }
        }
    }

    private var deckItems: [HistoryItem] {
        let set = Set(deckStore.deckMovieIDs)
        return historyStore.items.filter { set.contains($0.id) }
    }

    private var deckTotalCost: Double {
        deckItems.reduce(0.0) { $0 + $1.voteAverage }
    }

    private var remaining: Double {
        budget - deckTotalCost
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("コスト = TMDB vote_average（0〜10） / 上限 \(String(format: "%.1f", budget))")
                .font(.footnote)
                .foregroundStyle(.secondary)

            if deckItems.isEmpty {
                Text("現在のデッキ：なし")
                    .font(.footnote)
            } else {
                Text("現在のデッキ：\(deckItems.count)本（合計 \(String(format: "%.1f", deckTotalCost)) / 残り \(String(format: "%.1f", remaining))）")
                    .font(.footnote.bold())
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 6)
    }

    private func historyRow(_ item: HistoryItem) -> some View {
        let already = deckStore.contains(movieID: item.id)
        let canAdd = !already && (deckTotalCost + item.voteAverage <= budget)

        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).lineLimit(2)
                Text("cost: \(String(format: "%.1f", item.voteAverage))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                tryAdd(item)
            } label: {
                Text(already ? "追加済" : "追加")
                    .font(.caption.bold())
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canAdd)
        }
        .padding(.vertical, 4)
    }

    private func deckRow(_ item: HistoryItem) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).lineLimit(2)
                Text("cost: \(String(format: "%.1f", item.voteAverage))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                deckStore.remove(movieID: item.id)
            } label: {
                Text("削除").font(.caption.bold())
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }

    private func tryAdd(_ item: HistoryItem) {
        guard !deckStore.contains(movieID: item.id) else { return }
        guard deckTotalCost + item.voteAverage <= budget else { return }
        deckStore.add(movieID: item.id)
    }
}
