//
//  SearchView.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 05/12/1446 AH.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var debounceTask: Task<Void, Never>? = nil

    var body: some View {
        NavigationView {
            VStack {
                // ✅ حقل البحث
                TextField("Search...", text: $searchText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .font(.custom("Inter", size: 16))
                    .onChange(of: searchText) { newValue in
                        debounceSearch(with: newValue)
                    }

                if viewModel.isLoading {
                    ProgressView("جاري البحث...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("❌ Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.filteredSections.isEmpty {
                    Spacer()
                    Text("لا توجد نتائج")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(viewModel.filteredSections.flatMap { $0.items }) { item in
                                NavigationLink(destination: ContentDetailView(item: item)) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                                            switch phase {
                                            case .empty:
                                                Color.gray.opacity(0.2)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            case .failure:
                                                Color.red.opacity(0.1)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .clipped()

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(item.title ?? "No Title")
                                                .font(.custom("Inter", size: 16))
                                                .fontWeight(.medium)
                                                .lineLimit(2)

                                            if let desc = item.description {
                                                Text(desc)
                                                    .font(.custom("Inter", size: 13))
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                            }
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadHomeSections() // 👈 تحميل البيانات أولًا
            }
        }
    }

    // ✅ دالة تأخير البحث 200ms بعد توقف الكتابة
    private func debounceSearch(with text: String) {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
            await MainActor.run {
                viewModel.applySearch(text)
            }
        }
    }
}
