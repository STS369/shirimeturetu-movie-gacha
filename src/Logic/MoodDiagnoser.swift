import Foundation

struct LocalMovieQuery: Equatable {
    let genres: [Int]
    let minVote: Double?
    let yearFrom: Int?
    let yearTo: Int?
    let comment: String
}

enum MoodDiagnoser {

    static func map(_ text: String) -> LocalMovieQuery {
        let t = normalize(text)

        // 何も入力がない
        if t.isEmpty {
            return .init(
                genres: [],
                minVote: nil,
                yearFrom: nil,
                yearTo: nil,
                comment: "空欄なので人気から雑に引きます。"
            )
        }

        // ✅ 新年（あけおめ系）
        if containsAny(t, ["あけましておめでとうございます", "明けましておめでとうございます", "あけおめ", "謹賀新年"]) {
            return .init(
                genres: [35, 10751],  // Comedy + Family
                minVote: 6.0,
                yearFrom: 1990,
                yearTo: nil,
                comment: "あけおめ。景気よく明るめでいきましょう。"
            )
        }

        // 怒り
        if containsAny(t, ["ムカつく", "うざい", "最悪", "ふざけるな", "キレそう"]) {
            return .init(
                genres: [28, 53], // Action + Thriller
                minVote: 6.0,
                yearFrom: 2000,
                yearTo: nil,
                comment: "なるほど、そいつはいかれてますね。燃えるやつ行きます。"
            )
        }

        // 不安
        if containsAny(t, ["怖い", "不安", "こわい", "終わり", "だめ", "無理"]) {
            return .init(
                genres: [27, 9648, 53], // Horror + Mystery + Thriller
                minVote: 6.0,
                yearFrom: 1995,
                yearTo: nil,
                comment: "なるほど。安心はしない映画をどうぞ。"
            )
        }

        // 孤独
        if containsAny(t, ["ひとり", "誰も", "さみしい", "寂しい"]) {
            return .init(
                genres: [18, 10749], // Drama + Romance
                minVote: 6.5,
                yearFrom: 1985,
                yearTo: nil,
                comment: "なるほど。誰かの人生を覗くのがちょうどいい。"
            )
        }

        // 混乱
        if containsAny(t, ["わからない", "ぐちゃぐちゃ", "支離滅裂", "混乱", "意味不明"]) {
            return .init(
                genres: [878, 9648], // Sci-Fi + Mystery
                minVote: 6.5,
                yearFrom: 1970,
                yearTo: nil,
                comment: "なるほど。意味がない方が勝ちです。"
            )
        }

        // 虚無
        if containsAny(t, ["どうでもいい", "疲れた", "しんどい", "空っぽ", "虚無"]) {
            return .init(
                genres: [18, 9648], // Drama + Mystery
                minVote: 7.0,
                yearFrom: 1990,
                yearTo: nil,
                comment: "それなら、何も解決しない映画をどうぞ。"
            )
        }

        // デフォルト
        return .init(
            genres: [],
            minVote: nil,
            yearFrom: nil,
            yearTo: nil,
            comment: "分類できなかったので人気から雑に引きます。"
        )
    }


    private static func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func containsAny(_ text: String, _ keywords: [String]) -> Bool {
        keywords.contains { text.contains($0) }
    }
}
