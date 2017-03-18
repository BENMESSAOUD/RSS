//
//  RSSManagerTests.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import XCTest
@testable import News

class RSSManagerTests: XCTestCase {
    let connector = MockConnector()
    var manager: RSSManager!

    override func setUp() {
        super.setUp()
        manager = RSSManager(connector)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_loadChannel_Should_callloadRSSConnectorMethod_When_always() {
    //arrange
    //Acte
        self.manager.loadChannel { (channel, error) in
        }
    //assert
        XCTAssertTrue(connector.loadRSSIsCalled)
    }

    func test_loadChannel_Should_invokeBlockWithNilChannel_When_coonectorReturnNilXml() {
        //arrange
        connector.xml = nil
        //Acte
        self.manager.loadChannel { (channel, error) in
            //assert
            XCTAssertNil(channel)
        }
    }

    func test_loadChannel_Should_invokeBlockWithNilChannelAndXmlErrorType_When_connectorReturnWrongXml() {
        //arrange
        connector.xml = "this is not an xml"
        //Acte
        self.manager.loadChannel { (channel, error) in
            //assert
            XCTAssertNil(channel)
            XCTAssertEqual(error, ConnectorError.xml)
        }
    }

    func test_loadChannel_Should_invokeBlockWithChannelAndNilError_When_connectorReturnValideRSSXml() {
        //arrange
        connector.xml = "<rss xmlns:atom=\"http://www.w3.org/2005/Atom\" version=\"2.0\"><channel><title>Le Monde</title><description>site d'information</description><pubDate>Fri, 17 Mar 2017 11:58:20 +0100</pubDate><image><url>http://www.lemonde.fr/mmpub/img/lgo/lemondefr_rss.gif</url></image><item><link>http://www.lemonde.fr/mmpub/img/lgo/lemondefr_rss.gif</link><title>news title</title><description>news description</description><pubDate>Fri, 17 Mar 2017 11:26:25 +0100</pubDate><enclosure url=\"http://s1.lemde.fr/image/2017/03/17/644x322/5096145_3_d836_des-eleves-a-proximite-du-lycee-tocq_08285061fb6bb3a325a053ca7aaa4377.jpg\" type=\"image/jpeg\" length=\"51992\"/></item></channel></rss>"
        //Acte
        self.manager.loadChannel { (channel, error) in
            //assert
            XCTAssertNotNil(channel)
            XCTAssertNil(error)
        }
    }

    func test_loadChannel_Should_invokeBlockWithNilChannelAndXmlErrorType_When_connectorReturnXmlNotAsExpected() {
        //arrange
        connector.xml = "<xml><channel><title>Le Monde</title><description>site d'information</description></channel></xml>"
        //Acte
        self.manager.loadChannel { (channel, error) in
            //assert
            XCTAssertNil(channel)
            XCTAssertEqual(error, ConnectorError.xml)
        }
    }

}

class MockConnector: Connector {
    var xml :String?
    var error: ConnectorError?
    var loadRSSIsCalled = false
    override func loadRSS(_ rssURL: String, completion: @escaping (String?, ConnectorError?) -> Void) {
        loadRSSIsCalled = true
        completion(xml, error)
    }
}
