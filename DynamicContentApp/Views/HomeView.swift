//
//  HomeView.swift
//  DynamicContentApp
//
//  Created by Aliah Alhameed on 03/12/1446 AH.
//
// Views/HomeView.swift

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // ✅ رأس الشاشة (الهيدر)
                    HeaderView()

                    // ✅ حالة تحميل البيانات
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    
                    // ✅ حالة الخطأ في جلب البيانات
                    } else if let error = viewModel.errorMessage {
                        Text("❌ Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    
                    // ✅ عرض الأقسام في حال جلب البيانات بنجاح
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.filteredSections) { section in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // ✅ عنوان القسم مع سهم التنقل
                                    HStack {
                                        Text(section.title)
                                            .font(.title2.bold())
                                            .font(.custom("Inter", size: 22))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)

                                    // ✅ عرض العناصر الخاصة بالقسم
                                    sectionContent(for: section)
                                }
                            }
                            .padding(.bottom)
                        }
                        .padding(.top)
                    }
                }
            }
            .ignoresSafeArea(edges: .top) // ✅ إزالة الفراغ العلوي
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color.white)
        }
        .task {
            await viewModel.loadHomeSections()
        }
    }

    // MARK: - طريقة عرض المحتوى داخل كل قسم بحسب نوعه
    @ViewBuilder
    func sectionContent(for section: HomeSection) -> some View {
        switch section.displayType.lowercased() {

        case "square", "grid":
            VStack(spacing: 24) {
                ForEach(section.items) { item in
                    NavigationLink(destination: ContentDetailView(item: item)) {
                        HStack(alignment: .center, spacing: 16) {
                            AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                                switch phase {
                                case .empty: Color.gray.opacity(0.2)
                                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                                case .failure: Color.red.opacity(0.1)
                                @unknown default: EmptyView()
                                }
                            }
                            .frame(width: 96, height: 96)
                            .clipped()
                            .cornerRadius(20)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title ?? "No Title")
                                    .font(.custom("Inter", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .lineLimit(2)

                                Text("قبل 5 ساعات")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.gray)

                                HStack(spacing: 6) {
                                    Image(systemName: "play.fill").font(.system(size: 12))
                                    Text("30 دقيقة").font(.custom("Inter", size: 12))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

        case "horizontal":
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(section.items) { item in
                        NavigationLink(destination: ContentDetailView(item: item)) {
                            VStack(alignment: .leading, spacing: 10) {
                                AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                                    switch phase {
                                    case .empty: Color.gray.opacity(0.2)
                                    case .success(let image): image.resizable().scaledToFill()
                                    case .failure: Color.red.opacity(0.1)
                                    @unknown default: EmptyView()
                                    }
                                }
                                .frame(width: 200, height: 120)
                                .clipped()
                                .cornerRadius(16)

                                Text(item.title ?? "No Title")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .lineLimit(2)

                                if let desc = item.description {
                                    Text(desc)
                                        .font(.custom("Inter", size: 13))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: "play.fill").font(.system(size: 12))
                                    Text("30 دقيقة").font(.custom("Inter", size: 12))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding()
                            .frame(width: 200)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }

        default:
            VStack(alignment: .leading, spacing: 6) {
                ForEach(section.items) { item in
                    NavigationLink(destination: ContentDetailView(item: item)) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                                switch phase {
                                case .empty: Color.gray.opacity(0.2)
                                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                                case .failure: Color.red.opacity(0.1)
                                @unknown default: EmptyView()
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
            .padding(.horizontal)
        }
    }
}

// MARK: - Header View (الرأس) مع تصميم أنيق
struct HeaderView: View {
    var body: some View {
        ZStack {
            Color("Background")

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back 👋")
                        .font(.custom("Inter", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Discover new podcasts, audiobooks, and articles")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()

                NavigationLink(destination: SearchView()) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("Orange"))
                        .padding(10)
                        .background(Color("Background"))
                        .clipShape(Circle())
                }
            }
            .padding(.top,40)
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 160)
        .clipShape(RoundedCorner(radius: 24, corners: [.bottomLeft, .bottomRight]))
    }
}





#Preview {
    HomeView()
}
