import Foundation

@MainActor
final class PopularViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var message: String? = nil

    private let tmdb = TMDBAPIClient()

    func gachaAndLoad(_ text: String) async {
        isLoading = true
        defer { isLoading = false }

        let query = MoodDiagnoser.map(text)
        message = query.comment

        do {

            let list: [Movie]
            if query.genres.isEmpty && query.minVote == nil && query.yearFrom == nil && query.yearTo == nil {
                list = try await tmdb.fetchPopular()
            } else {
                list = try await tmdb.fetchDiscover(
                    genres: query.genres,
                    minVote: query.minVote,
                    yearFrom: query.yearFrom,
                    yearTo: query.yearTo
                )
            }

            if let picked = list.randomElement() {
                movies = [picked]
            } else {
                movies = []
                message = "候補が空でした。別の言葉でどうぞ。"
            }
        } catch {
            do {
                let list = try await tmdb.fetchPopular()
                movies = list.randomElement().map { [$0] } ?? []
                message = "取得に失敗したので人気から雑に引きました。"
            } catch {
                movies = []
                message = "取得に失敗しました: \(error)"
            }
        }
    }
}
