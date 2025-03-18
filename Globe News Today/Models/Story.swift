//
//  Story.swift
//  Globe News Today
//
//  Created by Masoud Soleimani on 2025-03-17.
//

import SwiftUI

struct NewsFeed: Decodable {
    let recommendations: [Story]
}

struct Story: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let protection_product: String?
    let byline: [String]?
    let promo_image: PromoImage?
    
    struct PromoImage: Decodable {
        let urls: ImageURLs
    }
    
    struct ImageURLs: Decodable {
        let url650: String
        
        enum CodingKeys: String, CodingKey {
            case url650 = "650"
        }
    }
}
