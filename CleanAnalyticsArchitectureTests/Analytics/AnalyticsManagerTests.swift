//
//  AnalyticsManagerTests.swift
//  CleanAnalyticsArchitectureTests
//
//  Created by Greener Chen on 2022/8/25.
//

import XCTest
@testable import CleanAnalyticsArchitecture

class AnalyticsManagerTests: XCTestCase {

    var sut: AnalyticsManager!
    var spyEngine1: AnalyticsEngineDI!
    var spyEngine2: AnalyticsEngineDI!
    
    override func setUpWithError() throws {
        spyEngine1 = SpyEngine(name: "1")
        spyEngine2 = SpyEngine(name: "2")
        sut = AnalyticsManager(engines: [spyEngine1, spyEngine2])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSendEventsToAllEngines() throws {
        let event = TestEvent(name: "test", metadata: ["loaded": "true"])
        sut.log(event)
        
        XCTAssertEqual(spyEngine1.events.count, 1)
        XCTAssertEqual(spyEngine2.events.count, 1)
        let eventOnEngine1 = spyEngine1.events.first!
        let eventOnEngine2 = spyEngine2.events.first!
        XCTAssertEqual(eventOnEngine1.name, "test")
        XCTAssertEqual(eventOnEngine1.metadata, ["loaded": "true"])
        XCTAssertEqual(eventOnEngine2.name, "test")
        XCTAssertEqual(eventOnEngine2.metadata, ["loaded": "true"])
    }

}

protocol SpyEngineProtocol {
    var events: [AnalyticsEvent] { get set }
}

typealias AnalyticsEngineDI = AnalyticsEngine & SpyEngineProtocol

class SpyEngine: AnalyticsEngineDI {
    let name: String
    var events: [AnalyticsEvent] = []
    
    init(name: String) {
        self.name = name
    }
    
    func sendEvent(name: String, metadata: [String : String]) {
        let event = TestEvent(name: name, metadata: metadata)
        events.append(event)
    }
}

struct TestEvent: AnalyticsEvent {
    var name: String
    var metadata: [String : String]
}