import Foundation

enum TMDBAPIError: Error {
    case invalidResponse
    case httpStatus(Int)
    case invalidURL
}

final class TMDBAPIClient {

    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(TMDBConfig.readAccessToken)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchPopular(page: Int = 1) async throws -> [Movie] {
        var components = URLComponents(url: TMDBConfig.baseURL.appendingPathComponent("movie/popular"),
                                       resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = components?.url else { throw TMDBAPIError.invalidURL }

        let request = makeRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw TMDBAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else { throw TMDBAPIError.httpStatus(http.statusCode) }

        let decoded = try JSONDecoder().decode(MovieListResponse.self, from: data)
        return decoded.results
    }

    func fetchDiscover(
        genres: [Int],
        minVote: Double?,
        yearFrom: Int?,
        yearTo: Int?,
        page: Int = 1
    ) async throws -> [Movie] {

        var components = URLComponents(url: TMDBConfig.baseURL.appendingPathComponent("discover/movie"),
                                       resolvingAgainstBaseURL: false)

        var items: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]

        if !genres.isEmpty {
            items.append(URLQueryItem(name: "with_genres", value: genres.map(String.init).joined(separator: ",")))
        }
        if let minVote {
            items.append(URLQueryItem(name: "vote_average.gte", value: String(minVote)))
            items.append(URLQueryItem(name: "vote_count.gte", value: "50"))
        }
        if let yearFrom {
            items.append(URLQueryItem(name: "primary_release_date.gte", value: "\(yearFrom)-01-01"))
        }
        if let yearTo {
            items.append(URLQueryItem(name: "primary_release_date.lte", value: "\(yearTo)-12-31"))
        }

        components?.queryItems = items
        guard let url = components?.url else { throw TMDBAPIError.invalidURL }

        let request = makeRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else { throw TMDBAPIError.invalidResponse }
        guard (200...299).contains(http.statusCode) else { throw TMDBAPIError.httpStatus(http.statusCode) }

        let decoded = try JSONDecoder().decode(MovieListResponse.self, from: data)
        return decoded.results
    }
}
