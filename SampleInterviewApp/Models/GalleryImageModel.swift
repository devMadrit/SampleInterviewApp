//
//  GalleryImageModel.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 26.11.20.
//

import Foundation
internal struct GalleryImageModel: Codable, Resource {
    
    let uniqueId: String
    let imageName: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case uniqueId = "unique_id"
        case imageName = "image_name"
        case imageUrl = "image_url"
    }
}
