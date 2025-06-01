//
//  HomeViewModel.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//
// ViewModels/HomeViewModel.swift

// ViewModels/HomeViewModel.swift

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var sections: [HomeSection] = [] // الأقسام الأصلية من الـ API
    @Published var filteredSections: [HomeSection] = [] // الأقسام بعد البحث
    @Published var isLoading = false
    @Published var errorMessage: String?

    // ✅ تحميل البيانات مع إزالة التكرار داخل كل قسم فقط
    func loadHomeSections() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await APIService.shared.fetchHomeSections()

            // ✅ إزالة التكرارات داخل كل قسم بناءً على العنوان
            let filteredResult = result.map { section in
                var seenTitles = Set<String>()
                let uniqueItems = section.items.filter { item in
                    let title = item.title ?? ""
                    if seenTitles.contains(title) {
                        return false
                    } else {
                        seenTitles.insert(title)
                        return true
                    }
                }

                return HomeSection(
                    id: section.id,
                    title: section.title,
                    displayType: section.displayType,
                    contentType: section.contentType,
                    items: uniqueItems
                )
            }

            self.sections = filteredResult
            self.filteredSections = filteredResult
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // ✅ فلترة العناصر داخل الأقسام بناءً على البحث (مع الحفاظ على الأقسام الفريدة)
    func applySearch(_ query: String) {
        if query.isEmpty {
            filteredSections = sections
        } else {
            let loweredQuery = query.lowercased()
            filteredSections = sections.compactMap { section in
                var seenTitles = Set<String>()
                let matchedItems = section.items.filter { item in
                    let title = (item.title ?? "").lowercased()
                    return title.contains(loweredQuery) && seenTitles.insert(title).inserted
                }

                if !matchedItems.isEmpty {
                    return HomeSection(
                        id: section.id,
                        title: section.title,
                        displayType: section.displayType,
                        contentType: section.contentType,
                        items: matchedItems
                    )
                } else {
                    return nil
                }
            }
        }
    }
}
