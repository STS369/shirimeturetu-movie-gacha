import Foundation

@MainActor
final class DeckStore: ObservableObject {
    @Published private(set) var deckMovieIDs: [Int] = [] {
        didSet { save() }
    }

    private let key = "deck_movie_ids_v1"

    init() { load() }

    func contains(movieID: Int) -> Bool { deckMovieIDs.contains(movieID) }

    func add(movieID: Int) {
        guard !contains(movieID: movieID) else { return }
        deckMovieIDs.append(movieID)
    }

    func remove(movieID: Int) {
        deckMovieIDs.removeAll { $0 == movieID }
    }

    func clear() {
        deckMovieIDs = []
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Int].self, from: data) else { return }
        deckMovieIDs = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(deckMovieIDs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
