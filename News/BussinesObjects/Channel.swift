//
//  Channel.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import Foundation

class Channel {
    var title: String = kEmptyString
    var description: String = kEmptyString
    var pubDate :String = kEmptyString
    var image: String = kEmptyString
    var items = [Item]()

    init() {
    }

    init(dictionary: [ChannelKeys: Any]) {
        title = dictionary[.title] as? String ?? kEmptyString
        description = dictionary[.description] as? String ?? kEmptyString
        pubDate = dictionary[.date] as? String ?? kEmptyString
        image = dictionary[.imageUrl] as? String ?? kEmptyString

        if let itemsFromDictionary = dictionary[.items] as? [[ItemKeys:String]]{
            appendItems(array: itemsFromDictionary)
        }
    }

    func appendItem(dictionary: [ItemKeys:String]){
        let item = Item(dictionary)
        items.append(item)
    }

    func appendItems(array: [[ItemKeys:String]]) {
        let itemsCollection = array.map { (dictionary) -> Item in
            return Item(dictionary)
        }
        items.append(contentsOf: itemsCollection)
    }
}
