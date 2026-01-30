import Foundation

struct HistoryItem: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String?
    let voteAverage: Double
    let pickedAt: Date
}

@MainActor
final class HistoryStore: ObservableObject {
    @Published private(set) var items: [HistoryItem] = [] {
        didSet { save() }
    }

    private let key = "history_items_v1"

    init() { load() }

    func add(movie: Movie) {
        let item = HistoryItem(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            overview: movie.overview,
            voteAverage: movie.voteAverage,
            pickedAt: Date()
        )
        items.insert(item, at: 0)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) else { return }
        items = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
