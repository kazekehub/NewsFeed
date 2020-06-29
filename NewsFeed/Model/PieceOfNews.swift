//
//  PieceOfNews.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

struct PieceOfNews: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var url: String
    var urlToImage: String?
    var publishedAt: String
    //var content: String
}

struct Source: Codable {
    var name: String
}
