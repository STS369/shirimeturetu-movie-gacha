import Foundation

@MainActor
final class FavoriteStore: ObservableObject {
    @Published private(set) var favorites: [Int] = [] {
        didSet { save() }
    }

    private let key = "favorite_ids_v1"

    init() { load() }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(movie.id)
    }

    func toggle(_ movie: Movie) {
        if isFavorite(movie) {
            favorites.removeAll { $0 == movie.id }
        } else {
            favorites.append(movie.id)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let ids = try? JSONDecoder().decode([Int].self, from: data) else { return }
        favorites = ids
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
