//
//  StoryViewModel.swift
//  Globe News Today
//
//  Created by Masoud Soleimani on 2025-03-17.
//

import SwiftUI

class StoryViewModel: ObservableObject {
    @Published var stories: [Story] = []
    
    func fetchStories() {
        guard let url = URL(string: "https://d2c9087llvttmg.cloudfront.net/trending_and_sophi/recommendations.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let decodedStories = try JSONDecoder().decode(NewsFeed.self, from: data)
                DispatchQueue.main.async {
                    self.stories = decodedStories.recommendations
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func formattedAuthors(authores: [String]?) -> String {
        if let byline = authores, !byline.isEmpty {
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
}
