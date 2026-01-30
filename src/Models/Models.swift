import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
