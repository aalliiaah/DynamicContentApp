//
//  APIService.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//
// Services/APIService.swift

// Services/APIService.swift

// Services/APIService.swift

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    // دالة لجلب أقسام الشاشة الرئيسية
    func fetchHomeSections() async throws -> [HomeSection] {
        guard let url = URL(string: "https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // ✅ طباعة محتوى JSON المستلم
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 البيانات من API:\n\(jsonString)")
        }

        // ✅ فك الغلاف الخارجي من JSON
        struct APIResponse: Codable {
            let sections: [HomeSection]?
        }

        // ✅ فك البيانات واستخدام [] كافتراضي لو كانت sections مفقودة
        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
        return decoded.sections ?? []
    }
}
