//
//  ContentDetailView.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//

import SwiftUI

struct ContentDetailView: View {
    let item: ContentItem

    @Environment(\.dismiss) private var dismiss

    // ✅ لحفظ الأيقونة المحددة حاليًا
    @State private var selectedIcon: String? = nil

    // ✅ لتفعيل حركة الضغط مؤقتًا
    @State private var pressedIcon: String? = nil

    var body: some View {
        ZStack(alignment: .topLeading) {
            // ✅ خلفية بلون مخصص من Assets
            Rectangle()
                .fill(Color("Background"))
                .frame(height: 260)
                .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea(edges: .top)

            // ✅ زر الرجوع (أعلى اليسار)
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.leading, 16)

            VStack(spacing: 0) {
                // ✅ صورة وعنوان وتقييم البودكاست
                HStack(alignment: .top, spacing: 16) {
                    if let url = item.imageUrl, let imageURL = URL(string: url) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 110, height: 150)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 110, height: 150)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title ?? "No Title")
                            .font(.custom("Inter", size: 22))
                            .bold()
                            .foregroundColor(.black)

                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 14))
                            }

                            Text("4.5")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }

                        Text("120 Reviews")
                            .font(.system(size: 12))
                            .foregroundColor(.black.opacity(0.9))
                    }
                }
                .padding(.leading, 24)
                .padding(.top, 60)

                // ✅ ScrollView لبقية المحتوى
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
//                        Text("About")
//                            .font(.custom("Inter", size: 18))
//                            .bold()
//                            .padding()

                        if let description = item.description {
                            Text(description)
                                .font(.custom("Inter", size: 18)) 
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .lineSpacing(6)
                                .padding()
                        }

                        // ✅ شريط الأيقونات بأسلوب ثمانية
                        HStack(spacing: 40) {
                            ForEach(["arrow.down.circle", "play.fill", "heart", "square.and.arrow.up"], id: \.self) { icon in
                                Button(action: {
                                    // عند الضغط:
                                    selectedIcon = icon
                                    pressedIcon = icon

                                    // ← إعادة تعيين بعد نصف ثانية لإلغاء الـ scale
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        pressedIcon = nil
                                    }

                                }) {
                                    Image(systemName: icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedIcon == icon ? Color("Orange") : .gray)

                                        .padding(12)
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(Circle())
                                        // ✅ حركة تكبير عند الضغط
                                        .scaleEffect(pressedIcon == icon ? 1.2 : 1.0)
                                        .animation(.easeOut(duration: 0.2), value: pressedIcon)
                                }
                            }
                        }
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
    }
}

// ✅ Extension لتحديد زوايا معينة
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
