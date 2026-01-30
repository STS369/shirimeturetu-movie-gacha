import SwiftUI

struct BigMovieCardView: View {
    let movie: Movie
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.white.opacity(0.06)
                        ProgressView().tint(.white)
                    }
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    ZStack {
                        Color.white.opacity(0.06)
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 12)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(movie.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Spacer()

                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                    }
                }

                Text("評価 \(String(format: "%.1f", movie.voteAverage)) / 10")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))

                if let overview = movie.overview, !overview.isEmpty {
                    Text(overview)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var posterURL: URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: imageBaseURL + path)
    }
}
