//
//  CachedNews.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class CachedNews: Object {
    dynamic var author: String?
    dynamic var title: String?
    dynamic var url: String?
    dynamic var urlToImage: String?
    dynamic var publishedAt: String?
    dynamic var sourceName: String?
    dynamic var categoryName: String?
    dynamic var saved = false
    dynamic var content: String = ""
    
    override class func primaryKey() -> String? {
        return "title"
    }
}
