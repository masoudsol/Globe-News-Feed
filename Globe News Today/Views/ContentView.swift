//
//  ContentView.swift
//  Globe News Today
//
//  Created by Masoud Soleimani on 2025-03-17.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoryViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.stories) { story in
                StoryRow(story: story)
            }
            .navigationTitle("Trending Stories")
            .onAppear {
                viewModel.fetchStories()
            }
        }
    }
}

struct StoryRow: View {
    let story: Story
    var formattedByline: String {
        if let byline = story.byline, !byline.isEmpty {
            var result = byline.dropLast().joined(separator: ", ")
            if let lastElement = byline.last {
                if !result.isEmpty {
                    result += " and \(lastElement)"
                } else {
                    result = lastElement
                }
            }
            return result
        }
        return ""
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(story.title)
                    .font(.headline)
                + Text("❌")
                Text(formattedByline)
                    .font(.subheadline)
                
            }
            Spacer()
            if let imageUrl = story.promo_image?.urls.url650,
               let url = URL(string: imageUrl) {
                AsyncImageView(url: url)
            }
        }
        .padding(5)
    }
}

// I am targeting iOS 14, using my own custom AsyncIamgeView. AsyncIamge is only available on iOS 15+
struct AsyncImageView: View {
    let url: URL?

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear(perform: loadImage)
            }
        }
        .frame(width: 80, height: 60)
        .cornerRadius(8)
    }

    private func loadImage() {
        guard let url = url else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
