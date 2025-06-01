//
//  SearchViewModel.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 05/12/1446 AH.
//
import Foundation

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [ContentItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var debounceTask: Task<Void, Never>? = nil

    func updateQuery(_ newQuery: String) {
        self.query = newQuery

        debounceTask?.cancel()

        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 200 * 1_000_000) // 200ms delay
            await MainActor.run {
                Task { await self.performSearch() }
            }
        }
    }

    private func performSearch() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            await MainActor.run {
                self.results = []
            }
            return
        }

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        let encodedQuery = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://mock.apidog.com/m1/735111-711675-default/search?q=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            await MainActor.run {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([ContentItem].self, from: data)

            await MainActor.run {
                self.results = decoded
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "❌ Failed to fetch search results."
                print("Search error:", error)
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
}
