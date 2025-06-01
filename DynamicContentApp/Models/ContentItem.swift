//
//  ContentItem.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//


import Foundation

struct ContentItem: Codable, Identifiable {
    let id: String? // ← لا تخليه Optional!
    let title: String?
    let imageUrl: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case title = "name"
        case imageUrl = "avatar_url"
        case description
    }

    enum DynamicKeys: String, CodingKey {
        case podcast_id, audiobook_id, episode_id, article_id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        print("📸 صورة هذا العنصر: \(self.imageUrl ?? "لا يوجد رابط")") // ✅ هنا
        self.description = try container.decodeIfPresent(String.self, forKey: .description)

        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)

        // ✅ جلب ID حقيقي من API
        if let podcastID = try? dynamicContainer.decode(String.self, forKey: .podcast_id) {
            self.id = "podcast_\(podcastID)"
        } else if let audiobookID = try? dynamicContainer.decode(String.self, forKey: .audiobook_id) {
            self.id = "audiobook_\(audiobookID)"
        } else if let episodeID = try? dynamicContainer.decode(String.self, forKey: .episode_id) {
            self.id = "episode_\(episodeID)"
        } else if let articleID = try? dynamicContainer.decode(String.self, forKey: .article_id) {
            self.id = "article_\(articleID)"
        } else {
            // ✅ fallback ثابت لكل عنوان (ما يتكرر)
            self.id = "generated_" + (self.title ?? UUID().uuidString)
        }
    }
}
