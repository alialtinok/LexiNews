import SwiftUI

struct VocabularyView: View {
    @EnvironmentObject private var store:    VocabularyStore
    @EnvironmentObject private var settings: UserSettingsStore
    @Environment(\.str) private var str
    @State private var tappedWord: String? = nil

    var body: some View {
        NavigationStack {
            Group {
                if store.savedWords.isEmpty {
                    ContentUnavailableView(
                        str.vocabEmpty,
                        systemImage: "books.vertical",
                        description: Text(str.vocabEmptyDesc)
                    )
                } else {
                    List {
                        ForEach(store.savedWords.sorted(), id: \.self) { word in
                            Button(word) { tappedWord = word }.foregroundStyle(.primary)
                        }
                        .onDelete { idx in
                            let sorted = store.savedWords.sorted()
                            idx.forEach { store.remove(sorted[$0]) }
                        }
                    }
                }
            }
            .navigationTitle(str.tabMyWords)
        }
        .sheet(item: $tappedWord) { word in
            WordPopupSheet(word: word)
                .environmentObject(store)
                .environmentObject(settings)
        }
    }
}
