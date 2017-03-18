//
//  RSSManager.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class RSSManager {
    var connector: Connector
    init(_ connector: Connector = Connector()) {
        self.connector = connector
    }

    func loadChannel(completion:@escaping (Channel?, ConnectorError?) -> Void){
        self.connector.loadRSS(leMondeRSSURL) { (xml, error) in
            guard let xml = xml else {
                completion(nil, error)
                return
            }
            if let dictionary = self.parseRSS(xml){
                let channel = Channel(dictionary: dictionary)
                completion (channel, nil)
            }
            else{
                completion (nil, ConnectorError.xml)
            }
        }
    }

    private func parseRSS(_ rss: String) -> [ChannelKeys: Any]?{
        do {
            let xml = try XML.parse(rss)
            return toDictionary(parser: xml)
        }
        catch {
            return nil
        }
    }

    private func toDictionary( parser: XML.Accessor) -> [ChannelKeys: Any]? {
        let channelElement = parser["rss", ChannelKeys.name.rawValue]
        guard channelElement.error == nil else {
            return nil
        }

        let channelTitle = channelElement[ChannelKeys.title.rawValue].text ?? kEmptyString
        let channelDescription = channelElement[ChannelKeys.description.rawValue].text ?? kEmptyString
        let channelPubDate = channelElement[ChannelKeys.date.rawValue].text ?? kEmptyString
        let channelImageUrl = channelElement[ChannelKeys.image.rawValue, ChannelKeys.imageUrl.rawValue].text ?? kEmptyString
        var itemsList = [[ItemKeys:String]]()
        if let allElements = channelElement.element?.childElements {
            itemsList = allElements.flatMap { (element) -> [ItemKeys:String]? in
                guard element.name == ItemKeys.name.rawValue else{
                    return nil
                }
                let xmlItem = XML.Accessor(element)
                let itemTitle = xmlItem[ItemKeys.title.rawValue].text ?? kEmptyString
                let itemLink = xmlItem[ItemKeys.link.rawValue].text ?? kEmptyString
                let itemDescription = xmlItem[ItemKeys.description.rawValue].text ?? kEmptyString
                let itemPubDate = xmlItem[ItemKeys.date.rawValue].text ?? kEmptyString
                let itemImageUrl = xmlItem[ItemKeys.image.rawValue].attributes[ItemKeys.imageUrl.rawValue] ?? kEmptyString
                let item: [ItemKeys:String] = [.title : itemTitle, .link : itemLink, .description : itemDescription, .date : itemPubDate, .imageUrl : itemImageUrl]
                return item
            }
        }


        let channel: [ChannelKeys:Any] = [.title : channelTitle, .description : channelDescription, .date : channelPubDate, .imageUrl : channelImageUrl, .items :itemsList]

        return channel
    }
}
