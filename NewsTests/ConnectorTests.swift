//
//  ConnectorTests.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import XCTest
@testable import News
class ConnectorTests: XCTestCase {
    let mockURLSession = MockURLSession()
    var connector: Connector!

    override func setUp() {
        super.setUp()

        self.connector = Connector(mockURLSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_loadRSS_Should_invokeBlockWithStringNilAndUrlErrorType_When_rssURLIsNotAValideURL() {
    //arrange
        let rssURL = "some string"
    //Acte
        self.connector.loadRSS(rssURL) { (string, error) in
            //assert
            XCTAssertNil(string)
            XCTAssertEqual(error, ConnectorError.url)
        }

    }

    func test_loadRSS_Should_invokeBlockWithStringNilAndServerErrorType_When_responseDataIsNil() {
        //arrange
        let rssURL = "http://valideURL.com"
        let response = HTTPURLResponse(url: URL(string: rssURL)!, statusCode: 200, httpVersion: "", headerFields: nil)
        mockURLSession.response = response

        //Acte
        self.connector.loadRSS(rssURL) { (string, error) in
            //assert
            XCTAssertNil(string)
            XCTAssertEqual(error, ConnectorError.server)
        }
        
    }

    func test_loadRSS_Should_invokeBlockWithStringNilAndServerErrorType_When_StatusCodeIsNot200() {
        //arrange
        let rssURL = "http://valideURL.com"
        let response = HTTPURLResponse(url: URL(string: rssURL)!, statusCode: 500, httpVersion: "", headerFields: nil)
        mockURLSession.response = response

        //Acte
        self.connector.loadRSS(rssURL) { (string, error) in
            //assert
            XCTAssertNil(string)
            XCTAssertEqual(error, ConnectorError.server)
        }

    }

    func test_loadRSS_Should_invokeBlockWithStringNilAndServerErrorType_When_ErrorIsNotNil() {
        //arrange
        let rssURL = "http://valideURL.com"
        let resultedString =  "<xml><valide>OK 😀</valide></xml>"
        let data = resultedString.data(using: .utf8)
        mockURLSession.data = data
        let response = HTTPURLResponse(url: URL(string: rssURL)!, statusCode: 200, httpVersion: "", headerFields: nil)
        mockURLSession.response = response
        mockURLSession.error = NSError (domain: "error message", code: 0, userInfo: nil)

        //Acte
        self.connector.loadRSS(rssURL) { (string, error) in
            //assert
            XCTAssertNil(string)
            XCTAssertEqual(error, ConnectorError.server)
        }

    }

}

class MockURLSession: URLSession {
    var data: Data?
    var response:URLResponse?
    var error: Error?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let task = MockURLSessionDataTask()
        completionHandler(self.data, self.response, self.error)

        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {

    }
}
