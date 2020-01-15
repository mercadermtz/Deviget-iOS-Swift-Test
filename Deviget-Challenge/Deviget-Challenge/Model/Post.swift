//
//  Post.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import Foundation

public struct Post: Codable, Equatable {
    public var read: Bool?
    public let author: String?
    public let createdUTC: TimeInterval
    public let thumbnail: String?
    public let title: String?
    public let numComments: Int
    public let url: String?
    public let id: String?
    
    enum CodingKeys: String, CodingKey {
        case read = "visited"
        case author
        case createdUTC = "created_utc"
        case thumbnail
        case title
        case numComments = "num_comments"
        case url
        case id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        read = try? container.decode(Bool.self, forKey: .read)
        author = try? container.decode(String.self, forKey: .author)
        createdUTC = try container.decode(TimeInterval.self, forKey: .createdUTC)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
        title = try? container.decode(String.self, forKey: .title)
        numComments = try container.decode(Int.self, forKey: .numComments)
        url = try? container.decode(String.self, forKey: .url)
        id = try? container.decode(String.self, forKey: .id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(read, forKey: .read)
        try container.encode(author, forKey: .author)
        try container.encode(createdUTC, forKey: .createdUTC)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(title, forKey: .title)
        try container.encode(numComments, forKey: .numComments)
        try container.encode(url, forKey: .url)
        try container.encode(id, forKey: .id)
    }
}
