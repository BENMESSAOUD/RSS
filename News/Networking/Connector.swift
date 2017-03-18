//
//  Connector.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import Foundation
enum ConnectorError: Error{
    case url
    case xml
    case server

    var code: Int {
        switch self {
        case .url:
            return 0
        case .xml:
            return 1
        case .server:
            return 2
        }
    }

    var message: String {
        switch self {
        case .url:
            return "Error: cannot create URL"
        case .xml:
            return "Wrong XML format."
        case .server:
            return "An Error has been occured. Please try later."
        }
    }
}

class Connector {
    var session: URLSession

    init(_ session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    public func loadRSS(_ rssURL: String, completion: @escaping (String?, ConnectorError?) -> Void) {

        guard let url = URL(string: rssURL) else {
            completion(nil, ConnectorError.url)
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if let data = data , httpResponse.statusCode == 200 && error == nil {
                if let xmlString = String(data: data, encoding: .utf8) {
                    completion(xmlString, nil)
                }
                else{
                    completion(nil, ConnectorError.xml)
                }
            }
            else {
                completion(nil, ConnectorError.server)
            }

        }
        task.resume()
    }
}
