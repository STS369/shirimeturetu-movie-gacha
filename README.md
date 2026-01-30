# 今日の支離滅裂 Movie Gacha 🎬

入力した「愚痴・意味のない一言・支離滅裂な文章」を  
**ルールベース（if文）で雑に分類**し、  
The Movie Database (TMDB) API を使って映画を1本ガチャ表示する iOS アプリです。

> 正確な診断はしません。  
> 雰囲気だけ当てにいきます。

---

## 📱 アプリの流れ

1. 「今日の支離滅裂」を入力
2. 入力文を **キーワードベースで分類**
3. TMDB `discover` / `popular` API から候補取得
4. 候補の中から **ランダムで1本表示**
5. 映画は履歴に保存
6. 履歴から **コスト制限付きでデッキ構築**（評価値をコストとして使用）

---

## 🧠 使っている技術・学習ポイント

- **SwiftUI**
  - `@State` / `@EnvironmentObject` を使った状態管理
  - `NavigationStack` / `sheet` / `fullScreenCover` による画面遷移
- **非同期処理**
  - `async / await` + `URLSession`
- **設計**
  - View / ViewModel / Logic / Store の責務分離
- **アルゴリズム要素**
  - キーワードマッチによる分類（ルールベース）
  - ランダム選択（ガチャ）
  - 制約付き選択（デッキの合計コスト ≤ 28）
- **ローカル永続化**
  - `UserDefaults` による履歴・お気に入り・デッキ保存

---

## 🗂 フォルダ構成

```text
src/
├─ App/
├─ Views/
├─ ViewModels/
├─ Stores/
├─ Logic/
├─ Network/
├─ Models/
└─ Config/

---

## 📊 発表資料

- PowerPoint:  
  `slides/shiritsuretsu-movie-gacha.pptx`
- PDF版（推奨）:  
  `slides/shiritsuretsu-movie-gacha.pdf`
