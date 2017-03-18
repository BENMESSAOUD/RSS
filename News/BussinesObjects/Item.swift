//
//  Item.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import Foundation
class Item {
    var link: String = kEmptyString
    var title: String = kEmptyString
    var description: String = kEmptyString
    var pubDate: String = kEmptyString
    var image: String = kEmptyString

    init(_ dictionary: [ItemKeys: String]) {
        link = dictionary[.link] ?? kEmptyString
        title = dictionary[.title] ?? kEmptyString
        description = dictionary[.description] ?? kEmptyString
        pubDate = dictionary[.date] ?? kEmptyString
        image = dictionary[.imageUrl] ?? kEmptyString
    }
}

extension Item {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self.pubDate)
    }
}
