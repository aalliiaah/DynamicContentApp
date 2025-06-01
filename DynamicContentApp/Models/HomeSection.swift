//
//  HomeSection.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//
// Models/HomeSection.swift

// Models/HomeSection.swift

// Models/HomeSection.swift

// Models/HomeSection.swift

// Models/HomeSection.swift


// Models/HomeSection.swift

import Foundation

struct HomeSection: Codable, Identifiable {
    let id: String
    let title: String
    let displayType: String
    let contentType: String
    let items: [ContentItem]

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case displayType = "type"
        case contentType = "content_type"
        case items = "content"
    }

    // ✅ initializer يدوي لفك التشفير من JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? UUID().uuidString
        self.title = try container.decode(String.self, forKey: .title)
        self.displayType = try container.decode(String.self, forKey: .displayType)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        self.items = try container.decode([ContentItem].self, forKey: .items)
    }

    // ✅ initializer يدوي لإنشاء نسخة جديدة من الكود
    init(id: String, title: String, displayType: String, contentType: String, items: [ContentItem]) {
        self.id = id
        self.title = title
        self.displayType = displayType
        self.contentType = contentType
        self.items = items
    }
}
