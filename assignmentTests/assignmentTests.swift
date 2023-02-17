//
//  assignmentTests.swift
//  assignmentTests
//
//  Created by Aman Verma on 13/02/23.
//

import XCTest
@testable import assignment
@testable import SDWebImage
import Combine

final class assignmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test() throws{
        let viewModel=HomeViewModel()
//        let spy=ValueSpy(viewModel.$gifModel)

        
    }
    

}

//private class ValueSpy{
//    private(set) var values=[GifModel]()
//    private var cancellables:AnyCancellable?
//
//    init(_ @Published publisher: GifModel){
//        cancellables=publisher.sink(receiveValue: {
//            [weak self] value in
//            self?.values.append(value)
//        })
//    }
//
//}

