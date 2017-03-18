//
//  RSSKeyDescription.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import Foundation

enum ChannelKeys : String {
    case name = "channel"
    case title = "title"
    case description = "description"
    case link = "link"
    case date = "pubDate"
    case image = "image"
    case imageUrl = "url"
    case items = "items"
}

enum ItemKeys : String {
    case name = "item"
    case title = "title"
    case description = "description"
    case link = "link"
    case date = "pubDate"
    case image = "enclosure"
    case imageUrl = "url"
}
