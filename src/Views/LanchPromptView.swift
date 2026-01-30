import SwiftUI

struct LaunchPromptView: View {
    @EnvironmentObject private var favoriteStore: FavoriteStore
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var deckStore: DeckStore

    @StateObject private var vm = PopularViewModel()

    @State private var text: String = ""
    @State private var goReaction = false
    @FocusState private var focused: Bool
    @State private var revealProgress: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color.black.opacity(0.92)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 18) {
                    Spacer()

                    VStack(spacing: 10) {
                        AnimatedRevealTitle(text: "今日の支離滅裂", progress: revealProgress)
                            .onAppear {
                                revealProgress = 0
                                withAnimation(.easeOut(duration: 1.2)) {
                                    revealProgress = 1
                                }
                            }

                        Text("愚痴でも、意味のない一言でも、支離滅裂でも。雑に受け止めます。")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    VStack(spacing: 12) {
                        TextField("例：全部どうでもいい", text: $text, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(1...4)
                            .focused($focused)
                            .padding(.horizontal, 24)

                        HStack(spacing: 10) {
                            Button("ガチャを回す") {
                                focused = false
                                Task {
                                    await vm.gachaAndLoad(text)
                                    goReaction = true
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Button("スキップ") {
                                focused = false
                                Task {
                                    await vm.gachaAndLoad("")
                                    goReaction = true
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    if vm.isLoading {
                        ProgressView("考え中…")
                            .tint(.white)
                            .padding(.top, 6)
                    }

                    Spacer()

                    Text("※ 正確さは気にしません。")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.bottom, 14)
                }
                .padding(.vertical, 12)
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goReaction) {
                ReactionView(vm: vm)
                    .environmentObject(favoriteStore)
                    .environmentObject(historyStore)
                    .environmentObject(deckStore)
            }
        }
    }
}

private struct AnimatedRevealTitle: View {
    let text: String
    let progress: CGFloat

    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.18))

            Text(text)
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .mask(
                    Rectangle()
                        .scaleEffect(x: progress, y: 1, anchor: .leading)
                )
                .shadow(color: .white.opacity(0.25), radius: 10)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
    }
}
